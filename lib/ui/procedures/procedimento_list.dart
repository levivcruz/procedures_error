import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:procedures_hubbi/models/procedimento_model.dart';
import 'package:procedures_hubbi/models/user_model.dart';
import 'package:procedures_hubbi/ui/procedures/procedimento_new.dart';
import 'package:procedures_hubbi/ui/procedures/procedimento_user_list.dart';
import 'package:procedures_hubbi/ui/procedures/procedimento_view.dart';
// import 'package:procedures_hubbi/providers/user_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProcedimentoList extends StatefulWidget {
  @override
  _ProcedimentoListState createState() => _ProcedimentoListState();
}

class _ProcedimentoListState extends State<ProcedimentoList> {

  UserModel userData = UserModel();

  ProcedimentoModel procedimento = ProcedimentoModel();
  List<ProcedimentoModel> _listaProcedimentos = [];
  UserModel usuarioDelegado;
  DateTime _dataProcedimento;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Procedimentos"),
        elevation: 0.0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ProcedimentoModel result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProcedimentoNew()));
          print("resultado e ${result.titulo}");
          /*         print("add procedimenot");
          ProcedimentoModel procedimento = ProcedimentoModel();
          List<Object> tarefas = List();
          TarefaModel tarefa = TarefaModel();
          tarefa.titulo = "tarefa 1";
          tarefa.subtitulo = "sub tarefa 1";
          tarefas.add(tarefa);
          tarefa.titulo = "tarefa 2";
          tarefa.subtitulo = "sub tarefa 2"; 
          tarefas.add(tarefa);
          print("tarefa");
          print(tarefa);
          print("tarefas.length");
          print(tarefas.length);
          print(tarefa.getTarefa());
          procedimento.setTarefa(tarefa.getTarefa());
          procedimento.titulo = "novo procedimento";
          procedimento.subtitulo = "novos";
          //procedimento.tarefas = tarefas;
          Firestore.instance
              .collection("procedimentos")
              .add(procedimento.getProcedimento());
          print(procedimento.getProcedimento()); */
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 10.0),
          StreamBuilder(
              stream: Firestore.instance
                  .collection("empresas")
                  .document(userData.empresaId)
                  .collection("procedimentos")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return new Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ));

                int conta = 0;
                return GridView.count(
                  crossAxisCount: 2,
                  primary: false,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 8.0,
                  shrinkWrap: true,
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    procedimento = ProcedimentoModel();
                    procedimento.setProcedimentoDocumentSnapShot(document);
                    _listaProcedimentos.add(procedimento);
                    conta += 1;
                    return _procedimento(
                        procedimento: procedimento,
                        index: conta,
                        procedimentoId: document.documentID);
                  }).toList(),
                );
              })
        ],
      ),
    );
  }

  Future _editarProcedimento(
      Map<String, ProcedimentoModel> procedimento) async {
    if (procedimento['editar'] != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProcedimentoNew(procedimento: procedimento['editar'])));
    }
    if (procedimento['excluir'] != null) {
      _showDesejaExcluir(procedimento['excluir'].procedimentoId);
    }
    if (procedimento['enviar'] != null) {
      usuarioDelegado = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => ProcedimentoUserListPage()));
      if (usuarioDelegado != null)
        _showDialogSelectDate(
            context: context, procedimento: procedimento['enviar']);
    }
  }

  void excluirProcedimento(String procedimentoId) {
    Firestore.instance
        .collection("empresas")
        .document(userData.empresaId)
        .collection("procedimentos")
        .document(procedimentoId)
        .delete();
  }

  void _showDesejaExcluir(String procedimentoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alerta"),
          content: new Text("Deseja excluir este procedimento ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text("SIM"),
              onPressed: () {
                excluirProcedimento(procedimentoId);
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

  void saveProcedimentoDelegado(ProcedimentoModel procedimento) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Procedimento enviado para ${usuarioDelegado.nome}"),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 2),
    ));
    procedimento.dataPrazo = _dataProcedimento;
    procedimento.delegadoPara = usuarioDelegado;
    procedimento.criadoPor = userData;
    procedimento.setParticipantes(usuId: usuarioDelegado.usuId);
    procedimento.setParticipantes(
        usuId: userData.usuId);
    print(procedimento);
    /* Firestore.instance.collection("usuarios").document(usuarioDelegado.usuId)
      .collection("procedimentos").add(procedimento.getProcedimento()); */
    Firestore.instance
        .collection("empresas")
        .document(userData.empresaId)
        .collection("procedimentos_delegados")
        .add(procedimento.getProcedimento());
  }

  Future _showDialogSelectDate(
      {BuildContext context, ProcedimentoModel procedimento}) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Definir um prazo para ${usuarioDelegado.nome} ",
                style: TextStyle(fontFamily: "GoogleSans")),
            content: OutlineButton(
              onPressed: () async {
                await _selectDate();
                _showDialogDateView(
                    context: context, procedimento: procedimento);
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

  Future<String> _showDialogDateView(
      {BuildContext context, ProcedimentoModel procedimento}) async {
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
                        saveProcedimentoDelegado(procedimento);
                      },
              )
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

  Widget _procedimento(
      {int index, ProcedimentoModel procedimento, String procedimentoId}) {
    var qnt = procedimento.tarefas.where((user) => user['done'] == true);
    int qntTarefasFeitas = qnt.length;
    if (qntTarefasFeitas == null) qntTarefasFeitas = 0;
    return InkWell(
      onLongPress: () {
        Firestore.instance
            .collection("procedimentos")
            .document(procedimentoId)
            .delete();
      },
      onTap: () {
        Navigator.of(context).push(new PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                ProcedimentoView(
                    procedimento: procedimento, procedimentoId: procedimentoId),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return new SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(0.9, 1.0),
                  end: Offset.zero,
                ).animate(animation),
                child: new SlideTransition(
                  position: new Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(0.0, 1.0),
                  ).animate(secondaryAnimation),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 500)));
      },
      child: Container(
        margin: index.isEven
            ? EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 10.0)
            : EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 10.0),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black12, width: 1.0, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white),
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -2.0,
                right: -7.0,
                child: PopupMenuButton(
                  onSelected: _editarProcedimento,
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.black54,
                  ),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                          value: {"editar": procedimento},
                          child: Text("Editar")),
                      //    PopupMenuItem( value: {"enviar": procedimento}, child: Text("Enviar")),
                      PopupMenuItem(
                          value: {"excluir": procedimento},
                          child: Text("Excluir"))
                    ];
                  },
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Hero(
                      tag: "$procedimentoId",
                      child: Container(
                        margin: EdgeInsets.only(top: 15.0),
                        height: 60.0,
                        width: 60.0,
                        child: Center(
                          child: Icon(
                              (procedimento.icone != null)
                                  ? IconData(procedimento.icone,
                                      fontFamily: 'MaterialIcons')
                                  : Icons.satellite,
                              color: (procedimento.corInt != null)
                                  ? Color(procedimento.corInt)
                                  : Colors.blue),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.white,
                            border: Border.all(
                              color: (procedimento.corInt != null)
                                  ? Color(procedimento.corInt)
                                  : Colors.blue,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      procedimento.titulo,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'GoogleSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.black87),
                    ),
                    Text(
                      "${procedimento.subtitulo}",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width * 0.41,
                  padding: EdgeInsets.only(left: 12.0, right: 12.0),
                  lineHeight: 8.0,
                  percent:
                      1.0, //qntTarefasFeitas / procedimento.tarefas.length,
                  backgroundColor: Colors.black12,
                  progressColor: (procedimento.corInt != null)
                      ? Color(procedimento.corInt)
                      : Colors.blue,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
