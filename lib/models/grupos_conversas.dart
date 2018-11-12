class GruposConversasModel {

  String gruposConversasId;
  DateTime criadoEm;
  DateTime updateAt;
  String ultimaConversa;
  String photoUrl;
  String nome;
  Map listaParticipantes = {};
  Map participantes =  {};
  Map participantesDados =  {};
  bool escrevendo = false;
  int qntConversas = 0;


  GruposConversasModel({
    this.gruposConversasId, 
    this.ultimaConversa, 
    this.photoUrl, 
    this.nome, 
  });

  setParticipanteDados({String usuId, String nome, String photo}){
    this.participantesDados[usuId] = {"usuId":usuId, "nome": nome, "photo":photo, "qntConversas": qntConversas};
  }

  setParticipantes({String usuId}){
   this.participantes[usuId] = true;
  }
  
  setListaParticipantes({String usuId}){
    this.listaParticipantes[usuId] = true;
  }

  getGrupoConversas(){
    return {
      "gruposConversasId":this.gruposConversasId,
      "criadoEm": "${DateTime.now()}",
      "update_at": "${DateTime.now()}",
      "ultimaConversa":this.ultimaConversa,
      "photoUrl":this.photoUrl,
      "nome":this.nome,
      "participantes": this.participantes,
      "participantesDados": this.participantesDados,
      "listaParticipantes": this.listaParticipantes,
      "escrevendo": this.escrevendo
    };
  }

  setDadosUsuarioJson(var grupoConversa){
    this.gruposConversasId = grupoConversa["gruposConversasId"];
    this.criadoEm = DateTime.parse(grupoConversa["criadoEm"]);
    this.updateAt = DateTime.parse(grupoConversa["update_at"]);
    this.ultimaConversa = grupoConversa["ultimaConversa"];
    this.participantes = grupoConversa["participantes"];
    this.nome = grupoConversa["nome"];
    this.participantes = grupoConversa["participantes"];
    this.participantesDados = grupoConversa["participantesDados"];
    this.listaParticipantes = grupoConversa["listaParticipantes"];
    this.escrevendo = grupoConversa["escrevendo"];
    print("grupoConversa daaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
  }

}