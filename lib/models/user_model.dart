import 'package:cloud_firestore/cloud_firestore.dart';
class UserModel {

  String usuId;
  String empresaId;
  String nome;
  String email;
  String celular;
  String photoUrl;  
  String token; 
  String cargo;
  String cargoId;
  String area;
  String areaId;
  String unidade;
  String unidadeId;
  String criadoEm ;
  DateTime atualizadoEm = DateTime.now();
  Map<dynamic, dynamic> gruposConversas = {};

  UserModel({
    this.usuId,  
    this.nome, 
    this.email, 
    this.celular, 
    this.token, 
    this.empresaId, 
    this.photoUrl
  });

  getUser(){
    print("AQUI ESTOU");
    print(this.gruposConversas);
    return {
      "usuId":this.usuId,
      "empresaId":this.empresaId,
      "cargo":this.cargo,
      "cargoId":this.cargoId,
      "area":this.area,
      "areaId":this.areaId,
      "unidade":this.unidade,
      "unidadeId":this.unidadeId,
      "nome":this.nome,
      "email":this.email,
      "celular":this.celular,
      "photoUrl":this.photoUrl,
      "token":this.token,
      "criadoEm": this.criadoEm,
      "atualizadoEm": this.atualizadoEm,
      "grupos_conversas": this.gruposConversas
    };
  }

  getUserResumido(){
    print("AQUI ESTOUeeeeee");
    return {
      "usuId":this.usuId,
      "empresaId":this.empresaId,
      "cargo":this.cargo,
      "cargoId":this.cargoId,
      "area":this.area,
      "areaId":this.areaId,
      "unidade":this.unidade,
      "unidadeId":this.unidadeId,
      "nome":this.nome,
      "photoUrl":this.photoUrl,
    };
  }
  getUserResumidoComunicado(){
    print("AQUI ESTOUeeeeee");
    return {
      "usuId":this.usuId,
      "cargo":this.cargo,
      "cargoId":this.cargoId,
      "area":this.area,
      "areaId":this.areaId,
      "unidade":this.unidade,
      "unidadeId":this.unidadeId,
      "nome":this.nome,
      "photoUrl":this.photoUrl,
      "assinadoEm": DateTime.now()
    };
  }

  setUser(var user){
    this.usuId = user['usuId'];
    this.empresaId = user['empresaId'];
    this.nome = user['nome'];
    this.email = user['email'];
    this.celular = user['celular'];
    this.photoUrl = user['photoUrl'];
    this.token = user['token'];
    this.criadoEm = user['criadoEm'];
    this.atualizadoEm = user['atualizadoEm'];
    this.cargo = user['cargo'];
    this.cargoId = user['cargoId'];
    this.area = user['area'];
    this.areaId = user['areaId'];
    this.unidade = user['unidade'];
    this.unidadeId = user['unidadeId'];
    this.gruposConversas = user['grupos_conversas'];
  }

  fromDocumentSnapshot(DocumentSnapshot snapshot){
    this.usuId = snapshot.data['usuId'];
    this.empresaId = snapshot.data['empresaId'];
    this.nome = snapshot.data['nome'];
    this.email = snapshot.data['email'];
    this.celular = snapshot.data['celular'];
    this.photoUrl = snapshot.data['photoUrl'];
    this.token = snapshot.data['token'];
    this.criadoEm = snapshot.data['criadoEm'];
    this.atualizadoEm = snapshot.data['atualizadoEm'];
    this.cargo = snapshot.data['cargo'];
    this.cargoId = snapshot.data['cargoId'];
    this.area = snapshot.data['area'];
    this.areaId = snapshot.data['areaId'];
    this.unidade = snapshot.data['unidade'];
    this.unidadeId = snapshot.data['unidadeId'];
    this.gruposConversas = snapshot.data['grupos_conversas'];
  }

  setGruposConversas({String usuId}){
   this.gruposConversas[usuId] = true;
  }

}
