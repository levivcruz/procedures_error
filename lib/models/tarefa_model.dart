import 'package:cloud_firestore/cloud_firestore.dart';

class TarefaModel {
  String tarefaId;
  String procedimentoId;
  String usuId;
  String titulo;
  String descricao;
  String resposta;
  String subtitulo;
  Map participantes;
  String imagemUrl;
  String icone;
  String cor;
  String criadoEm = "${DateTime.now()}";
  String atualizadoEm = "${DateTime.now()}";
  bool done = false;

  TarefaModel({
    this.tarefaId,
    this.procedimentoId,
    this.usuId,
    this.descricao,
    this.resposta,
    this.titulo,
    this.subtitulo,
    this.imagemUrl,
    this.icone,
    this.cor,
    this.done = false,
  });

  getTarefa() {
    return {
      "tarefaId": this.tarefaId,
      "procedimentoId": this.procedimentoId,
      "usuId": this.usuId,
      "titulo": this.titulo,
      "descricao": this.descricao,
      "resposta": this.resposta,
      "subtitulo": this.subtitulo,
      "imagemUrl": this.imagemUrl,
      "icone": this.icone,
      "cor": this.cor,
      "criadoEm": this.criadoEm,
      "atualizadoEm": this.atualizadoEm,
      "done": this.done,
    };
  }

  setTarefa(var tarefa){
    this.tarefaId = tarefa["tarefaId"];
    this.procedimentoId = tarefa["procedimentoId"];
    this.usuId = tarefa["usuId"];
    this.descricao = tarefa["descricao"];
    this.resposta = tarefa["resposta"];
    this.titulo = tarefa["titulo"];
    this.subtitulo = tarefa["subtitulo"];
    this.imagemUrl = tarefa["imagemUrl"];
    this.icone = tarefa["icone"];
    this.cor = tarefa["cor"];
    this.criadoEm = tarefa["criadoEm"];
    this.atualizadoEm = tarefa["atualizadoEm"];
    this.done = tarefa["done"];
  }

  setTarefaDocumentSnapshot(DocumentSnapshot tarefa){

    this.tarefaId = tarefa.data["tarefaId"];
    this.procedimentoId = tarefa.data["procedimentoId"];
    this.usuId = tarefa.data["usuId"];
    this.descricao = tarefa.data["descricao"];
    this.resposta = tarefa.data["resposta"];
    this.titulo = tarefa.data["titulo"];
    this.subtitulo = tarefa.data["subtitulo"];
    this.imagemUrl = tarefa.data["imagemUrl"];
    this.icone = tarefa.data["icone"];
    this.cor = tarefa.data["cor"];
    this.criadoEm = tarefa.data["criadoEm"];
    this.atualizadoEm = tarefa.data["atualizadoEm"];
    this.done = tarefa.data["done"];
  }
}
