class ChatModel {

  String usuId;
  String nome;
  String conversa;
  String tipo = "chat"; // chat // photo // pdf
  String url; 
  String criadoEm;
  Map participantes;
  bool conversaLida = false;
  bool escrevendo = false;

  ChatModel({this.usuId, this.nome, this.conversa, this.tipo, this.url, this.criadoEm, this.participantes});

  getChat(){
    return {
      "usuId":this.usuId,
      "nome":this.nome,
      "conversa":this.conversa,
      "tipo":this.tipo,
      "url":this.url,
      "criadoEm": "${DateTime.now()}",
      "participantes": this.participantes,
      "conversaLida": this.conversaLida,
      "escrevendo": this.escrevendo
    };
  }

}
