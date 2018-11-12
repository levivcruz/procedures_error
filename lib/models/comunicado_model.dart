import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:procedures_hubbi/models/user_model.dart';
//import 'package:flutter/material.dart';
class ComunidadoModel {
  
  String titulo;
  String conteudo;
  String photoUrl;
  String resumo;
  String setor;
  String tipo;
  String link;
  String criadoPorId;
  String criadoPorNome;
  Map criadoPor = {};
  DateTime criadoEm = DateTime.now();
  DateTime atualizadoEm = DateTime.now();
  int qntComentarios;
  int qntAssinaturas;


  ComunidadoModel({ this.titulo,  this.conteudo, this.photoUrl,  this.resumo, this.setor, this.qntComentarios, this.qntAssinaturas, this.tipo, this.link,  this.criadoPorId,  this.criadoPorNome});

  Map<String, dynamic> get getMap => {
    "titulo": titulo,
    "conteudo": conteudo,
    "photoUrl": photoUrl,
    "resumo": resumo,
    "setor": setor,
    "tipo": tipo,
    "criadoPorId": criadoPorId,
    "criadoPorNome": criadoPorNome,
    "link": link,
    "criadoEm": criadoEm,
    "qntComentarios": qntComentarios,
    "qntAssinaturas": qntAssinaturas,
    "atualizadoEm": atualizadoEm,
    "criadoPor": criadoPor,
    };

    setCriadoPor(Map criadoPor){
      this.criadoPor = criadoPor;
    }

  setCominicadoFromDocumentSnapshot(DocumentSnapshot snapshot){
    this.titulo = snapshot.data['titulo'];
    this.conteudo = snapshot.data['conteudo'];
    this.photoUrl = snapshot.data['photoUrl'];
    this.resumo = snapshot.data['resumo'];
    this.setor = snapshot.data['setor'];
    this.criadoPorId = snapshot.data['criadoPorId'];
    this.criadoPorNome = snapshot.data['criadoPorNome'];
    this.link = snapshot.data['link'];
    this.qntComentarios = snapshot.data['qntComentarios'];
    this.criadoEm = snapshot.data['criadoEm'];
    this.atualizadoEm = DateTime.now();
    this.qntAssinaturas = snapshot.data['qntAssinaturas'];
    this.criadoPor = snapshot.data['criadoPor'];
    
  }

}

