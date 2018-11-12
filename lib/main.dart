import 'package:flutter/material.dart';
import 'package:procedures_hubbi/ui/procedures/procedimento_view.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProcedimentoView(),
    );
  }
}


