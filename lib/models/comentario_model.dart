import 'package:cloud_firestore/cloud_firestore.dart';
class ComentarioModel {
  
  String comentario;
  String photoUrl;
  String resumo;
  Map criadoPor = {};
  DateTime criadoEm = DateTime.now();
  DateTime atualizadoEm = DateTime.now();


  ComentarioModel({ this.comentario, this.photoUrl,  this.resumo});

  Map<String, dynamic> get getMap => {
    "photoUrl": photoUrl,
    "comentario": comentario,
    "resumo": resumo,
    "criadoEm": criadoEm,
    "atualizadoEm": atualizadoEm,
    "criadoPor": criadoPor,
    };

    setCriadoPor(Map criadoPor){
      this.criadoPor = criadoPor;
    }

  setFromDocumentSnapshot(DocumentSnapshot snapshot){
    this.comentario = snapshot.data['comentario'];
    this.photoUrl = snapshot.data['photoUrl'];
    this.resumo = snapshot.data['resumo'];
    this.criadoEm = snapshot.data['criadoEm'];
    this.atualizadoEm = DateTime.now();
    this.criadoPor = snapshot.data['criadoPor'];
  }

}

