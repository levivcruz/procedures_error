import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:procedures_hubbi/models/user_model.dart';
// import 'package:hubbi/providers/user_provider.dart';

class ProcedimentoUserListPage extends StatefulWidget {
  @override
  _ProcedimentoUserListPage createState() => _ProcedimentoUserListPage();
}

class _ProcedimentoUserListPage extends State<ProcedimentoUserListPage> {

  UserModel userData = UserModel();

  List<UserModel> usuarios = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enviar para o contato"),
        elevation: 0.0,
      ),
      body: new Container(
        color: Colors.white,
        child: new StreamBuilder(
            stream: Firestore.instance
                .collection("usuarios")
                .where("empresaId",
                    isEqualTo: userData.empresaId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                );
              return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, i) {
                  DocumentSnapshot ds = snapshot.data.documents[i];
                  UserModel usuario = UserModel();
                  usuario.fromDocumentSnapshot(ds);
                  usuarios.add(usuario);
                  print("olha o nome ${usuarios[i].nome}");
                  return new Column(
                    children: <Widget>[
                      new Divider(
                        height: 2.0,
                        color: Colors.black26,
                        indent: 70.0,
                      ),
                      new ListTile(
                          leading: CircleAvatar(
                              foregroundColor: Theme.of(context).primaryColor,
                              backgroundColor: Colors.grey,
                              backgroundImage: (usuario.photoUrl != null)
                                  ? new NetworkImage(usuario.photoUrl)
                                  : null),
                          title: Text(
                            "${usuario.nome}",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'GoogleSans'),
                          ),
                          subtitle: (usuario.cargo != null)
                              ? Text(
                                  "${usuario.cargo}",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'GoogleSans'),
                                )
                              : Text(
                                  "Sem cargo",
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'GoogleSans'),
                                ),
                          onTap: () {
                            //   _createChat(ds['usuId'], ds['nome'], ds['photoUrl'], userData.usuId, userData.nome, userData.photoUrl);
                            Navigator.pop(context, usuarios[i]);
                          })
                    ],
                  );
                },
              );
            }),
      ),
    );
  }
}
