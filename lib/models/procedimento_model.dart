// import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:procedures_hubbi/models/tarefa_model.dart';
import 'package:procedures_hubbi/models/user_model.dart';

class ProcedimentoModel {
  String procedimentoId;
  UserModel criadoPor = UserModel();
  UserModel delegadoPara = UserModel();
  String empresaId;
  String filialId;
  String titulo;
  String subtitulo;
  String descricao;
  String tipo = "procedimento"; // procedimento // tarefa
  Map participantes = {};
  List<Map<dynamic, dynamic>> tarefas = [];
  String imagemUrl;
  int icone;
  String cor;
  int corInt;
  String criadoEm = "${DateTime.now()}";
  String atualizadoEm = "${DateTime.now()}";
  bool done = false;
  bool aceito = true;
  DateTime dataPrazo;

  ProcedimentoModel({
    this.procedimentoId,
    this.criadoPor,
    this.delegadoPara,
    this.empresaId,
    this.filialId,
    this.titulo,
    this.subtitulo,
    this.descricao,
    this.tipo,
    this.imagemUrl,
    this.icone,
    this.cor,
    this.corInt,
    this.done = false,
    this.aceito = false,
    this.dataPrazo,
  });


  getProcedimento() {
    Map _criadoPor = {};
    Map _delegadoPara = {};
    if(this.delegadoPara != null) _delegadoPara = this.delegadoPara.getUserResumido();
    if(this.criadoPor != null) _criadoPor = this.criadoPor.getUserResumido();
    return { 
      "procedimentoId": this.procedimentoId,
      "delegadoPara": _delegadoPara,
      "criadoPor": _criadoPor,
      "empresaId": this.empresaId,
      "filialId": this.filialId,
      "titulo": this.titulo,
      "subtitulo": this.subtitulo,
      "descricao": this.descricao,
      "tipo": this.tipo,
      "participantes": this.participantes,
      "tarefas": this.tarefas,
      "imagemUrl": this.imagemUrl,
      "icone": this.icone,
      "cor": this.cor,
      "corInt": this.corInt,
      "criadoEm": this.criadoEm,
      "atualizadoEm": this.atualizadoEm,
      "done": this.done,
      "aceito": this.aceito,
      "dataPrazo": this.dataPrazo,
    };
  }
 
  setTarefa(Map tarefa){
    this.tarefas.add(tarefa);
  }

  setTarefas(List tarefas){
    tarefas.forEach( (tarefa) {
      this.setTarefa(tarefa);
    });
  }


  setParticipantes({String usuId}){
    this.participantes[usuId] = true;
    print("participantes:? ${this.participantes}");
  }



  setProcedimento(var procedimento){

    this.procedimentoId = procedimento["procedimentoId"];
    this.empresaId = procedimento["empresaId"];
    this.filialId = procedimento["filialId"];
    this.titulo = procedimento["titulo"];
    this.subtitulo = procedimento["subtitulo"];
    this.descricao = procedimento["descricao"];
    this.tipo = procedimento["tipo"];
    this.participantes = procedimento["participantes"];
    this.imagemUrl = procedimento["imagemUrl"];
    this.icone = procedimento["icone"];
    this.cor = procedimento["cor"];
    this.corInt = procedimento["corInt"];
    this.atualizadoEm = "${DateTime.now()}";
    this.done = procedimento["done"];
    this.aceito = procedimento["aceito"];
    this.dataPrazo = procedimento["dataPrazo"];

    UserModel _criadoPor = UserModel();
    _criadoPor.setUser(procedimento["criadoPor"]);
    this.criadoPor = _criadoPor;
    UserModel _delegadoPara = UserModel();
    _delegadoPara.setUser(procedimento["delegadoPara"]);
    this.delegadoPara = _delegadoPara;

    setTarefas(procedimento["tarefas"]);
  }



  setProcedimentoDocumentSnapShot(DocumentSnapshot procedimento){

    UserModel _criadoPor = UserModel();
    _criadoPor.setUser(procedimento["criadoPor"]);
    this.criadoPor = _criadoPor;
    UserModel _delegadoPara = UserModel();
    _delegadoPara.setUser(procedimento["delegadoPara"]);
    this.delegadoPara = _delegadoPara;

    this.procedimentoId = procedimento.data["procedimentoId"];
    this.empresaId = procedimento.data["empresaId"];
    this.filialId = procedimento.data["filialId"];
    this.titulo = procedimento.data["titulo"];
    this.subtitulo = procedimento.data["subtitulo"];
    this.descricao = procedimento.data["descricao"];
    this.tipo = procedimento.data["tipo"];
    if(procedimento.data["participantes"] != null) this.participantes = procedimento.data["participantes"];
    if(procedimento.data["tarefas"] != null && procedimento.data["tarefas"].toString() != "[]") {
      List tarefas = procedimento.data['tarefas'];
      tarefas.map((tarefa){
        this.tarefas.add(tarefa);
      }).toList();
    }
    this.imagemUrl = procedimento.data["imagemUrl"];
    this.icone = procedimento.data["icone"];
    this.cor = procedimento.data["cor"];
    this.corInt = procedimento.data["corInt"];
    if(procedimento.data["atualizadoEm"] != null) this.atualizadoEm = "${DateTime.now()}";
    this.done = procedimento.data["done"];
    this.aceito = procedimento.data["aceito"];
    this.dataPrazo = procedimento.data["dataPrazo"];
  }
}
