import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:procedures_hubbi/models/procedimento_model.dart';
import 'package:procedures_hubbi/models/tarefa_model.dart';
import 'package:procedures_hubbi/models/user_model.dart';
import 'package:procedures_hubbi/ui/procedures/procedimento_user_list.dart';
// import 'package:procedures_hubbi/providers/user_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProcedimentoView extends StatefulWidget {
  final ProcedimentoModel procedimento;
  final String procedimentoId;

  ProcedimentoView({Key key, this.procedimento, this.procedimentoId})
      : super(key: key);

  @override
  _ProcedimentoViewState createState() => _ProcedimentoViewState();
}

class _ProcedimentoViewState extends State<ProcedimentoView> {
  UserModel userData = UserModel();
  DateTime dataPrazo = DateTime.now();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ProcedimentoModel procedimento = ProcedimentoModel();
  UserModel usuarioDelegado;
  DateTime _dataProcedimento;
  bool editar = false;
  final _novaTarefaTextController = new TextEditingController();
  final _descricaoTextController = TextEditingController();
  final _respostaTextController = TextEditingController();
  final _descricaoProcedimentoTextController = TextEditingController();
  List<DocumentSnapshot> tarefas;
  int qntTarefasFeitas;
  String prazoFinal = "";

  @override
  Widget build(BuildContext context) {
    if (widget.procedimento.dataPrazo != null) {
      prazoFinal = contagemRegressivaHorasDiasHorarioTrabalho(
          widget.procedimento.dataPrazo);
    }
    _descricaoProcedimentoTextController.text = widget.procedimento.descricao;
    //var qnt = tarefas.where((user) => user['done'] == true);
    //qntTarefasFeitas = qnt.length;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        //title: Text("Procedimento"),
        actions: (prazoFinal == "")
            ? <Widget>[
                FlatButton(
                    onPressed: () {
                      setState(() {
                        editar = !editar;
                      });
                    },
                    child: (editar)
                        ? Text(
                            "Delegar",
                            style: TextStyle(fontFamily: "GoogleSans"),
                          )
                        : Text(
                            "Editar",
                            style: TextStyle(fontFamily: "GoogleSans"),
                          ))
              ]
            : <Widget>[],
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Hero(
                  tag: "${widget.procedimentoId}",
                  child: Container(
                    height: 40.0,
                    width: 40.0,
                    child: Center(
                        child: Icon(
                            (widget.procedimento.icone != null)
                                ? IconData(widget.procedimento.icone,
                                    fontFamily: 'MaterialIcons')
                                : Icons.satellite,
                            color: (widget.procedimento.corInt != null)
                                ? Color(widget.procedimento.corInt)
                                : Colors.blue)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white,
                        border: Border.all(
                          color: (widget.procedimento.corInt != null)
                              ? Color(widget.procedimento.corInt)
                              : Colors.blue,
                        )),
                  )),
              title: Text(
                "${widget.procedimento.titulo}",
                style: TextStyle(
                    fontFamily: 'GoogleSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: Colors.black87),
              ),
              subtitle: Text(
                "${widget.procedimento.subtitulo}",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: (prazoFinal != "")
                  ? Text(
                      "Prazo $prazoFinal",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
            ),
            (editar)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                    controller: _descricaoProcedimentoTextController,
                    onChanged: (desc) => updateProcedimento(desc),
                    maxLines: 2,
                    decoration: InputDecoration(labelText: "Descrição"),
                  ),
                )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: (widget.procedimento.descricao != null)
                        ? Text(
                            "${widget.procedimento.descricao}",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: Colors.grey),
                            maxLines: 3,
                          )
                        : null),
            LinearPercentIndicator(
              width: MediaQuery.of(context).size.width * 1,
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              lineHeight: 8.0,
              percent: 1.0, //qntTarefasFeitas / tarefas.length,
              backgroundColor: Colors.black12,
              progressColor: (widget.procedimento.corInt != null)
                  ? Color(widget.procedimento.corInt)
                  : Colors.blue,
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
                child: StreamBuilder(
                    stream: (prazoFinal == "")
                        ? Firestore.instance
                            .collection("empresas")
                            .document(widget.procedimento.empresaId)
                            .collection("procedimentos")
                            .document(widget.procedimentoId)
                            .collection("tarefas")
                            .snapshots()
                        : Firestore.instance
                            .collection("empresas")
                            .document(widget.procedimento.empresaId)
                            .collection("procedimentos_delegados")
                            .document(widget.procedimentoId)
                            .collection("tarefas")
                            .orderBy("done")
                            .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.red,
                          ),
                        );
                      if (snapshot.data.documents.length == 0)
                        return Center(child: Text("Nenhuma tarefa definida"));
                      tarefas = snapshot.data.documents;
                      return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            TarefaModel tarefas2 = TarefaModel();
                            tarefas2.setTarefaDocumentSnapshot(
                                snapshot.data.documents[index]);
                            //   tarefas.add(tarefas2);

                            //   tarefas.add(tarefas2.getTarefa());
                            return _tarefaUnidade(tarefas2);
                          });
                    })),
            (!editar)
                ? ListTile(
                    title: (prazoFinal == "")
                        ? FlatButton(
                            onPressed: () async {
                              usuarioDelegado = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProcedimentoUserListPage()));
                              if (usuarioDelegado != null)
                                _showDialogSelectDate(context);
                              //delegarProcedimento();
                              //  Navigator.push(context, MaterialPageRoute(builder: (context) => ProcedimentoDelegar( procedimento: widget.procedimento)));
                            },
                            color: Colors.blue,
                            child: Text(
                              "DELEGAR",
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                  fontFamily: "GoogleSans"),
                            ),
                          )
                        : null)
                : ListTile(
                    leading: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        print("add nova tarefa");
                        TarefaModel tarefa = TarefaModel();
                        tarefa.titulo = _novaTarefaTextController.text;
                        print(_novaTarefaTextController.text);
                        setState(() {
                          // tarefas.add(tarefa.getTarefa());
                          //widget.procedimento.tarefas = tarefas;
                          _updateDb();
                        });

                        _salvaTarefa(tarefa);

                        _novaTarefaTextController.text = "";
                      },
                    ),
                    title: TextField(
                      controller: _novaTarefaTextController,
                      decoration: InputDecoration(
                        hintText: "Adicionar tarefa",
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  _tarefaUnidade(TarefaModel tarefa) {
    print("chegou aqui");
    print(tarefa.titulo);
    return ListTile(
        leading: Checkbox(
          onChanged: (bool resp) {
            _showAddResultado(tarefa, resp);
          },
          value: tarefa.done,
        ),
        title: Text(
          "${tarefa.titulo}",
          style: TextStyle(
              fontFamily: 'GoogleSans',
              fontWeight: FontWeight.w500,
              fontSize: 15.0,
              color: Colors.grey[600]),
        ),
        subtitle: (tarefa.done)
            ? Text(
                "Tarefa realiza em ${_apenasHoraTimeStamp(tarefa.atualizadoEm)}",
                style: TextStyle(
                    fontFamily: 'GoogleSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 8.0,
                    color: Colors.grey[600]))
            : null,
        trailing: (editar)
            ? PopupMenuButton(
                onSelected: _editarProcedimento,
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black54,
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                        value: {"descricao": tarefa}, child: Text("Descrição")),
                    PopupMenuItem(
                        value: {"excluir": tarefa}, child: Text("Excluir"))
                  ];
                },
              )
            : (tarefa.resposta != null && tarefa.resposta != "")
                ? IconButton(
                    onPressed: () {
                      _showDescricao(tarefa.resposta);
                    },
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.green,
                    ),
                  )
                : (tarefa.descricao != null && tarefa.descricao != "")
                    ? IconButton(
                        onPressed: () {
                          _showDescricao(tarefa.descricao);
                        },
                        icon: Icon(Icons.info_outline),
                      )
                    : null);
  }

  _apenasHoraTimeStamp(String time) {
    DateTime timestamp = DateTime.parse(time);
    String minuto;
    String hora;
    String dia;
    String mes;
    String ano;
    dia = timestamp.day.toString();
    mes = timestamp.month.toString();
    ano = timestamp.year.toString();
    (timestamp.hour < 24)
        ? hora = "${timestamp.hour}0"
        : hora = timestamp.hour.toString();
    (timestamp.minute < 10)
        ? minuto = "${timestamp.minute}0"
        : minuto = timestamp.minute.toString();
    return "$dia/$mes/$ano às ${timestamp.hour}:${minuto}";
  }

  Future _editarProcedimento(Map<String, TarefaModel> tarefa) async {
    if (tarefa['descricao'] != null) {
      //  Navigator.push(context, MaterialPageRoute(builder: (context) => ProcedimentoNew( procedimento: procedimento['editar'])));
      _showAddDescricao(tarefa['descricao']);
    }
    if (tarefa['excluir'] != null) {
      _showDesejaExcluir(tarefa['excluir'].tarefaId);
    }
  }

  void _showDescricao(String descricao) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: Text(
            "$descricao",
            style: TextStyle(
                fontFamily: 'GoogleSans',
                fontWeight: FontWeight.w500,
                fontSize: 15.0,
                color: Colors.black87),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("FECHAR"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddDescricao(TarefaModel tarefa) {
    _descricaoTextController.text = tarefa.descricao;
    print("tarefa.getTarefa()");
    print(tarefa.getTarefa());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          content: TextField(
            controller: _descricaoTextController,
            maxLines: 2,
            decoration: InputDecoration(labelText: "Descrição"),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("CANCELAR"),
              onPressed: () {
                _descricaoTextController.text = "";
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("SALVAR"),
              onPressed: () {
                tarefa.descricao = _descricaoTextController.text;
                _atualizaTarefa(tarefa, done: tarefa.done);
                _descricaoTextController.text = "";
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddResultado(TarefaModel tarefa, bool resp) {
    _respostaTextController.text = tarefa.resposta;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: (resp) ? null : Text("Tarefa já realizada"),
          content: (resp)
              ? TextField(
                  controller: _respostaTextController,
                  maxLines: 2,
                  decoration: InputDecoration(labelText: "Algo a acrescentar?"),
                )
              : Text("${tarefa.resposta}"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("CANCELAR"),
              onPressed: () {
                _respostaTextController.text = "";
                Navigator.of(context).pop();
              },
            ),
            (resp)
                ? FlatButton(
                    child: new Text("SALVAR"),
                    onPressed: () {
                      tarefa.resposta = _respostaTextController.text;
                      _atualizaTarefa(tarefa, done: resp);
                      _respostaTextController.text = "";
                      Navigator.of(context).pop();
                    },
                  )
                : null
          ],
        );
      },
    );
  }

  void _showDesejaExcluir(String tarefaId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alerta"),
          content: new Text("Deseja excluir esta tarefa ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("SIM"),
              onPressed: () {
                excluirTarefa(tarefaId);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("NAO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void excluirTarefa(String tarefaId) {
    Firestore.instance
        .collection("empresas")
        .document(widget.procedimento.empresaId)
        .collection("procedimentos")
        .document(widget.procedimentoId)
        .collection("tarefas")
        .document(tarefaId)
        .delete();
  }

  void updateProcedimento(String desc) {
    widget.procedimento.descricao = desc;
    widget.procedimento.atualizadoEm = DateTime.now().toString();
    Firestore.instance
        .collection("empresas")
        .document(widget.procedimento.empresaId)
        .collection("procedimentos")
        .document(widget.procedimentoId)
        .updateData(widget.procedimento.getProcedimento());
  }

  void _atualizaTarefa(TarefaModel tarefa, {bool done}) {
    tarefa.done = done;
    tarefa.atualizadoEm = DateTime.now().toString();
    print(tarefa.getTarefa());
    if (prazoFinal == "") {
      Firestore.instance
          .collection("empresas")
          .document(widget.procedimento.empresaId)
          .collection("procedimentos")
          .document(widget.procedimentoId)
          .collection("tarefas")
          .document(tarefa.tarefaId)
          .updateData(tarefa.getTarefa());
    } else {
      Firestore.instance
          .collection("empresas")
          .document(widget.procedimento.empresaId)
          .collection("procedimentos_delegados")
          .document(widget.procedimentoId)
          .collection("tarefas")
          .document(tarefa.tarefaId)
          .updateData(tarefa.getTarefa());
    }
  }

  void _salvaTarefa(TarefaModel tarefa) {
    Firestore.instance
        .collection("empresas")
        .document(widget.procedimento.empresaId)
        .collection("procedimentos")
        .document(widget.procedimentoId)
        .collection("tarefas")
        .add(tarefa.getTarefa())
        .then((snap) {
      tarefa.tarefaId = snap.documentID;
      Firestore.instance
          .collection("empresas")
          .document(widget.procedimento.empresaId)
          .collection("procedimentos")
          .document(widget.procedimentoId)
          .collection("tarefas")
          .document(tarefa.tarefaId)
          .updateData(tarefa.getTarefa());
    });
  }

  void _updateDb() {
    Firestore.instance
        .collection("empresas")
        .document(widget.procedimento.empresaId)
        .collection("procedimentos")
        .document(widget.procedimentoId)
        .updateData(widget.procedimento.getProcedimento());
  }

/*   void _ataulizaTarefa(TarefaModel tarefa, bool done) {
    tarefa.done = done;
    Firestore.instance
        .collection("empresas")
        .document(widget.procedimento.empresaId)
        .collection("procedimentos")
        .document(widget.procedimentoId)
        .collection("tarefas")
        .document(tarefa.tarefaId)
        .updateData(tarefa.getTarefa());
  } */

  void saveProcedimentoDelegado() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Procedimento enviado para ${usuarioDelegado.nome}"),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 2),
    ));

    widget.procedimento.dataPrazo = _dataProcedimento;
    widget.procedimento.delegadoPara = usuarioDelegado;
    widget.procedimento.criadoPor = userData;
    widget.procedimento.setParticipantes(usuId: usuarioDelegado.usuId);
    widget.procedimento.setParticipantes(usuId: userData.usuId);
    Firestore.instance
        .collection("empresas")
        .document(userData.empresaId)
        .collection("procedimentos_delegados")
        .add(widget.procedimento.getProcedimento())
        .then((snap) {
      print("QUANTAS TAREFAS TEM AQUI ${tarefas.length}");
      String procedimentoDelegadoId = snap.documentID;
      widget.procedimento.procedimentoId = procedimentoDelegadoId;
      Firestore.instance
          .collection("empresas")
          .document(userData.empresaId)
          .collection("procedimentos_delegados")
          .document(procedimentoDelegadoId)
          .updateData(widget.procedimento.getProcedimento())
          .then((snap2) {
        this.tarefas.forEach((tarefaSnap) {
          TarefaModel tarefa = TarefaModel();
          tarefa.setTarefaDocumentSnapshot(tarefaSnap);
          print(tarefa);
          // _salvaTarefa(tarefa);

          Firestore.instance
              .collection("empresas")
              .document(widget.procedimento.empresaId)
              .collection("procedimentos_delegados")
              .document(procedimentoDelegadoId)
              .collection("tarefas")
              .add(tarefa.getTarefa())
              .then((snap) {
            tarefa.tarefaId = snap.documentID;
            Firestore.instance
                .collection("empresas")
                .document(widget.procedimento.empresaId)
                .collection("procedimentos_delegados")
                .document(procedimentoDelegadoId)
                .collection("tarefas")
                .document(tarefa.tarefaId)
                .updateData(tarefa.getTarefa());
          });
        });
      });
    });
  }

  void _salvaTarefaDelegado(TarefaModel tarefa) {
    Firestore.instance
        .collection("empresas")
        .document(widget.procedimento.empresaId)
        .collection("procedimentos")
        .document(widget.procedimentoId)
        .collection("tarefas")
        .add(tarefa.getTarefa())
        .then((snap) {
      tarefa.tarefaId = snap.documentID;
      Firestore.instance
          .collection("empresas")
          .document(widget.procedimento.empresaId)
          .collection("procedimentos")
          .document(widget.procedimentoId)
          .collection("tarefas")
          .document(tarefa.tarefaId)
          .updateData(tarefa.getTarefa());
    });
  }

  Future _showDialogSelectDate(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Definir um prazo para ${usuarioDelegado.nome} ",
                style: TextStyle(fontFamily: "GoogleSans")),
            content: OutlineButton(
              onPressed: () async {
                await _selectDate();
                _showDialogDateView(context);
              },
              child: Text("Selecionar data",
                  style: TextStyle(fontFamily: "GoogleSans", fontSize: 15.0)),
              borderSide: BorderSide(color: Colors.black),
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text("CANCELAR"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  // calcula quanto tempo ou horas falta para acabar para um prazo x, levando em conta horario comercial de 8 as 18h
  String contagemRegressivaHorasDiasHorarioTrabalho(DateTime dataFinal) {
    DateTime dateNow = DateTime.now();
    int emHoras = 0;
    if (dataFinal.difference(dateNow).inDays == 0) {
      emHoras = 18 - dateNow.hour;
    }
    if (dataFinal.difference(dateNow).inHours > 0 &&
        dataFinal.difference(dateNow).inDays == 0) {
      emHoras = (18 - dateNow.hour) + 10;
    }

    if (emHoras > 0) {
      if (emHoras == 1) return "1 hora";
      return "$emHoras horas";
    } else {
      if (dataFinal.difference(dateNow).inDays == 1) return "1 dia";
      if (dataFinal.difference(dateNow).inDays < 0) return "";
      return "${dataFinal.difference(dateNow).inDays} dias";
    }
  }

  Future<String> _showDialogDateView(BuildContext context) async {
    String faltaPrazo =
        contagemRegressivaHorasDiasHorarioTrabalho(_dataProcedimento);
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Definir este prazo?",
                style: TextStyle(fontFamily: "GoogleSans")),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                (faltaPrazo == "")
                    ? Text("Data passada, selecione outra data",
                        style: TextStyle(
                            fontFamily: "GoogleSans",
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87))
                    : Text(
                        "${_dataProcedimento.day} / ${_dataProcedimento.month} / ${_dataProcedimento.year}",
                        style: TextStyle(
                            fontFamily: "GoogleSans",
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87)),
                Text("$faltaPrazo",
                    style: TextStyle(fontFamily: "GoogleSans", fontSize: 15.0))
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text("NÃO OUTRA DATA"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: new Text("SIM"),
                onPressed: (faltaPrazo == "")
                    ? null
                    : () async {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        saveProcedimentoDelegado();
                      },
              ),
            ],
          );
        });
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2022));
    if (picked != null) {
      setState(() {
        _dataProcedimento = picked;
      });
    }
  }
}
