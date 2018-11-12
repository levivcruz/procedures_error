
import 'package:cloud_firestore/cloud_firestore.dart';

class ManualModel {
  String manualId;
  String usuId;
  String empresaId;
  String filialId;
  String titulo;
  String subtitulo;
  String resumo;
  String imagemUrl;
  String documentoUrl;
  String documentoLocal;
  int icone;
  String cor;
  int corInt;
  String criadoEm = "${DateTime.now()}";
  String atualizadoEm = "${DateTime.now()}";
  List<Map<dynamic, dynamic>> documentos = [];

  ManualModel({
    this.manualId,
    this.usuId,
    this.empresaId,
    this.filialId,
    this.titulo,
    this.subtitulo,
    this.resumo,
    this.imagemUrl,
    this.documentoUrl,
    this.documentoLocal,
    this.icone,
    this.cor,
    this.corInt,
  });


  getManual() {
    return {
      "manualId": this.manualId,
      "usuId": this.usuId,
      "empresaId": this.empresaId,
      "filialId": this.filialId,
      "titulo": this.titulo,
      "subtitulo": this.subtitulo,
      "resumo": this.resumo,
      "imagemUrl": this.imagemUrl,
      "documentoUrl": this.documentoUrl,
      "documentoLocal": this.documentoLocal,
      "icone": this.icone,
      "cor": this.cor,
      "corInt": this.corInt,
      "criadoEm": this.criadoEm,
      "atualizadoEm": this.atualizadoEm,
      "documentos": this.documentos,
    };
  }
 
  setManual(var manual){
    this.manualId = manual["manualId"];
    this.usuId = manual["usuId"];
    this.empresaId = manual["empresaId"];
    this.filialId = manual["filialId"];
    this.titulo = manual["titulo"];
    this.subtitulo = manual["subtitulo"];
    this.resumo = manual["resumo"];
    this.imagemUrl = manual["imagemUrl"];
    this.documentoUrl = manual["documentoUrl"];
    this.documentoLocal = manual["documentoLocal"];
    this.icone = manual["icone"];
    this.cor = manual["cor"];
    this.corInt = manual["corInt"];
    this.atualizadoEm = "${DateTime.now()}";
    this.documentos = manual["manuais"];
  }

    setDocumento(Map documento){
    print('documento model');
    //this.tarefas = [{"dd":"ddd"}];
    this.documentos.add(documento);
    print(this.documentos);

    //this.tarefas.add({"tarefaId": null, "procedimentoId": null, "usuId": null, "titulo": "tarefa 2", "subtitulo": "sub tarefa 2", "imagemUrl": "null", "icone": null, "cor": null, "criadoEm": null, "atualizadoEm": null, "done": false});
  }




  setManualDocumentoSnapShot(DocumentSnapshot manual){
    print("procedimento model");
    this.manualId =manual.documentID;
    this.usuId = manual.data["usuId"];
    this.empresaId = manual.data["empresaId"];
    this.filialId = manual.data["filialId"];
    this.titulo = manual.data["titulo"];
    this.subtitulo = manual.data["subtitulo"];
    this.resumo = manual.data["resumo"];
    this.imagemUrl = manual.data["imagemUrl"];
    this.documentoUrl = manual.data["documentoUrl"];
    this.documentoLocal = manual.data["documentoLocal"];
    this.icone = manual.data["icone"];
    this.cor = manual.data["cor"];
    this.corInt = manual.data["corInt"];
    if(manual.data["atualizadoEm"] != null) this.atualizadoEm = "${DateTime.now()}";
     if(manual.data["documentos"] != null && manual.data["documentos"].toString() != "[]") {
      List documentos = manual.data['documentos'];
      documentos.map((documento){
        this.documentos.add(documento);
      }).toList();
    }
  }
}
