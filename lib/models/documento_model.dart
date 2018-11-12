class DocumentoModel {
  String documentoId;
  String manualId;
  String usuId;
  String titulo;
  String subtitulo;
  String resumo;
  String imagemUrl;
  String documentoUrl;
  String icone;
  String cor;
  String criadoEm = "${DateTime.now()}";
  String atualizadoEm = "${DateTime.now()}";

  DocumentoModel({
    this.documentoId,
    this.manualId,
    this.usuId,
    this.titulo,
    this.subtitulo,
    this.resumo,
    this.imagemUrl,
    this.documentoUrl,
    this.icone,
    this.cor,
  });

  getDocumento() {
    return {
      "tarefaId": this.documentoId,
      "procedimentoId": this.manualId,
      "usuId": this.usuId,
      "titulo": this.titulo,
      "subtitulo": this.subtitulo,
      "resumo": this.resumo,
      "imagemUrl": this.imagemUrl,
      "documentoUrl": this.documentoUrl,
      "icone": this.icone,
      "cor": this.cor,
      "criadoEm": this.criadoEm,
      "atualizadoEm": this.atualizadoEm,
    };
  }

  setDocumento(var tarefa){
    this.documentoId = tarefa["tarefaId"];
    this.manualId = tarefa["procedimentoId"];
    this.usuId = tarefa["usuId"];
    this.titulo = tarefa["titulo"];
    this.subtitulo = tarefa["subtitulo"];
    this.resumo = tarefa["resumo"];
    this.imagemUrl = tarefa["imagemUrl"];
    this.documentoUrl = tarefa["documentoUrl"];
    this.icone = tarefa["icone"];
    this.cor = tarefa["cor"];
    this.criadoEm = tarefa["criadoEm"];
    this.atualizadoEm = tarefa["atualizadoEm"];
  }
}
