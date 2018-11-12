import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:procedures_hubbi/models/procedimento_model.dart';
import 'package:procedures_hubbi/models/user_model.dart';
// import 'package:procedures_hubbi/providers/user_provider.dart';
// import 'package:material_color_picker/material_color_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProcedimentoNew extends StatefulWidget {
  ProcedimentoModel procedimento;
  ProcedimentoNew({Key key, this.procedimento}) : super(key: key);

  @override
  _ProcedimentoNewState createState() => _ProcedimentoNewState();
}

class _ProcedimentoNewState extends State<ProcedimentoNew> {
  UserModel userData = UserModel();

  int dueDate = new DateTime.now().millisecondsSinceEpoch;

  ProcedimentoModel procedimento = ProcedimentoModel();

  TextEditingController procedimentoText = TextEditingController();

  GlobalKey<FormState> _formState = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // inicia com valores padrao
    procedimento.titulo = "Procedimento";
    procedimento.subtitulo = "Geral";
    procedimento.icone = Icons.assignment.codePoint;
    procedimento.corInt = 4280391411; // azul padrao

    if (widget.procedimento != null) {
      procedimento = widget.procedimento;
      procedimentoText.text = procedimento.titulo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo procedimento"),
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: new SingleChildScrollView(
        child: Column(
          children: <Widget>[
            preVisualizacao(context),
            new Form(
              child: new Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: new TextFormField(
                  validator: (value) {
                    var msg = value.isEmpty
                        ? "Insira um título para o procedimento"
                        : null;
                    return msg;
                  },
                  onSaved: (value) {
                    procedimento.tipo = value;
                  },
                  controller: procedimentoText,
                  maxLines: null,
                  decoration: new InputDecoration(
                      labelText: "Título",
                      labelStyle: TextStyle(color: Colors.black)),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              onChanged: () {
                print(procedimentoText.text);
                setState(() {
                  procedimento.titulo = procedimentoText.text;
                });
              },
              key: _formState,
            ),
            new ListTile(
              leading: new Icon(Icons.format_paint),
              title: new Text("Cor"),
              subtitle: Container(
                  height: 10.0,
                  color: (procedimento.corInt != null)
                      ? Color(procedimento.corInt)
                      : Colors.grey),
              onTap: () {
                askedToLead().then((cor) {
                  setState(() {
                    procedimento.cor = "$cor";
                    procedimento.corInt = cor.value;
                  });
                  print("cor");
                  print(cor.value.toString());
                });
              },
            ),
            new ListTile(
              leading: new Icon(Icons.label),
              title: new Text("Setor"),
              subtitle: new Text(procedimento.subtitulo),
              onTap: () {
                _showPriorityDialog(context).then((prioridade) {
                  if (prioridade != null) {
                    setState(() {
                      procedimento.subtitulo = prioridade;
                    });
                  }
                });
              },
            ),
            new ListTile(
              leading: (procedimento.icone != null)
                  ? new Icon(
                      IconData(procedimento.icone, fontFamily: 'MaterialIcons'))
                  : null,
              title: new Text("Icone"),
              onTap: () {
                _showIcones(context).then((icone) {
                  if (icone != null) {
                    setState(() {
                      procedimento.icone = icone;
                    });
                  }
                });
              },
            ),
            SizedBox(height: 40.0),
            MaterialButton(
                child: Text(
                  "SALVAR",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 5.0),
                ),
                onPressed: () async {
                  if (_formState.currentState.validate()) {
                    _formState.currentState.save();

                    procedimento.empresaId = userData.empresaId;
                    procedimento.criadoPor = userData;

                    if (procedimento.procedimentoId != null) {
                      Firestore.instance
                          .collection("empresas")
                          .document(userData.empresaId)
                          .collection("procedimentos")
                          .document(procedimento.procedimentoId)
                          .updateData(procedimento.getProcedimento());
                    } else {
                      DocumentReference doc = await Firestore.instance
                          .collection("empresas")
                          .document(userData.empresaId)
                          .collection("procedimentos")
                          .add(procedimento.getProcedimento());
                      // atualiza id do procedimento
                      procedimento.procedimentoId = doc.documentID;
                      Firestore.instance
                          .collection("empresas")
                          .document(userData.empresaId)
                          .collection("procedimentos")
                          .document(procedimento.procedimentoId)
                          .setData(procedimento.getProcedimento());
                    }
                    Navigator.pop(context, procedimento);
                  }
                })
          ],
        ),
      ),
    );
  }

  Container preVisualizacao(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      height: 150.0,
      width: 130.0,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black12, width: 1.0, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15.0),
                height: 60.0,
                width: 60.0,
                child: Center(
                  child: Icon(
                    IconData(procedimento.icone, fontFamily: 'MaterialIcons'),
                    color: (procedimento.corInt != null)
                        ? Color(procedimento.corInt)
                        : Colors.grey,
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                    border: Border.all(
                      color: (procedimento.corInt != null)
                          ? Color(procedimento.corInt)
                          : Colors.grey,
                    )),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "${procedimento.titulo}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'GoogleSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
            width: 128.0,
            padding: EdgeInsets.only(left: 12.0, right: 12.0),
            lineHeight: 8.0,
            percent: 1.0,
            backgroundColor: Colors.black12,
            progressColor: (procedimento.corInt != null)
                ? Color(procedimento.corInt)
                : Colors.grey,
          )
        ],
      ),
    );
  }

  Future<Color> askedToLead() async => await showDialog(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: const Text('Select color'),
          /* children: <Widget>[
            new ColorPicker(
              type: MaterialType.transparency,
              onColor: (color) {
                Navigator.pop(context, color);
              },
              currentColor: Colors.blue,
            ),
          ], */
        );
      });

  Future<String> _showPriorityDialog(BuildContext context) async {
    return await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: const Text('Qual o setor?'),
            children: <Widget>[
              InkWell(
                onTap: () => Navigator.pop(context, "Financeiro"),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                  child: Text(
                    "Financeiro",
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(context, "RH"),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                  child: Text(
                    "RH",
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(context, "Marketing"),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                  child: Text(
                    "Marketing",
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
              )
            ],
          );
        });
  }

  Future<int> _showIcones(BuildContext context) async {
    return await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: const Text('Selecione um icone?'),
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: () =>
                        Navigator.pop(context, Icons.assignment.codePoint),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Icon(Icons.assignment),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context, Icons.check.codePoint),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Icon(Icons.check),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.pop(context, Icons.assessment.codePoint),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Icon(Icons.assessment),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: () =>
                        Navigator.pop(context, Icons.archive.codePoint),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Icon(Icons.archive),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.pop(context, Icons.calendar_today.codePoint),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Icon(Icons.calendar_today),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(
                        context, Icons.assignment_turned_in.codePoint),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Icon(Icons.assignment_turned_in),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: () =>
                        Navigator.pop(context, Icons.favorite_border.codePoint),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Icon(Icons.favorite_border),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.pop(context, Icons.history.codePoint),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Icon(Icons.history),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context, Icons.home.codePoint),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Icon(Icons.home),
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: () =>
                        Navigator.pop(context, Icons.warning.codePoint),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Icon(Icons.warning),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context, Icons.search.codePoint),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Icon(Icons.search),
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        Navigator.pop(context, Icons.shopping_cart.codePoint),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 10.0),
                      child: Icon(Icons.shopping_cart),
                    ),
                  )
                ],
              ),
            ],
          );
        });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2015, 8),
        lastDate: new DateTime(2101));
    if (picked != null) {
      setState(() {
        dueDate = picked.millisecondsSinceEpoch;
      });
    }
  }

  var monthsNames = [
    "Jan",
    "Fev",
    "Mar",
    "Abr",
    "Mai",
    "Jun",
    "Jul",
    "Ago",
    "Set",
    "Out",
    "Nov",
    "Dez"
  ];

  String getFormattedDate(int dueDate) {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(dueDate);
    return "${date.day} de ${monthsNames[date.month - 1]}";
  }
}
