import 'package:cloud_firestore/cloud_firestore.dart';
class EmpresaModel {

  String empresaId;
  String nome;
  String logoUrl;  
  String descricao;  
  DateTime criadoEm = DateTime.now();
  DateTime atualizadoEm = DateTime.now();
  List<Map<String, dynamic>> cargos = [];
  List<Map<String, dynamic>> areas = [];
  List<Map<String, dynamic>> unidades = [];

  EmpresaModel({ 
    this.empresaId,  
    this.nome, 
    this.logoUrl, 
    this.descricao, 
  });

  getEmpresa(){
    return {
      "empresaId": this.empresaId,
      "nome": this.nome,
      "logoUrl": this.logoUrl,
      "descricao": this.descricao,
      "criadoEm": this.criadoEm,
      "atualizadoEm": this.atualizadoEm,
    };
  }

  fromDocumentSnapshot(DocumentSnapshot snapshot){
    this.empresaId = snapshot.data['empresaId'];
    this.nome = snapshot.data['nome'];
    this.logoUrl = snapshot.data['logoUrl'];
    this.descricao = snapshot.data['descricao'];
    this.criadoEm = snapshot.data['criadoEm'];
    this.atualizadoEm = snapshot.data['atualizadoEm'];
  }

  getCargos(){
    return this.cargos;
  }
  addCargo(Map<String, dynamic> cargo){
    this.cargos.add(cargo);
  }

  getAreas(){
    return this.areas;
  }
  addArea(Map<String, dynamic> area){
    this.areas.add(area);
  }

  getUnidades(){
    return this.unidades;
  }
  addUnidade(Map<String, dynamic> unidade){
    this.unidades.add(unidade);
  }
  
}
