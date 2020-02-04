import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/item.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello Flutter",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple
      ),
      home: HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  var items = new List<Item>();
  HomePage(){
    items = [];
//    items.add(Item(title: "Arroz", done: true));
//    items.add(Item(title: "Feijão", done: true));
//    items.add(Item(title: "Farinha", done: false));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();

  void add(){
    if(newTaskCtrl.text.isEmpty){
      return;
    }
    setState(() {
      widget.items.add(Item(title: newTaskCtrl.value.text, done: false));
      print(newTaskCtrl.value.text);
      newTaskCtrl.clear();
      save();
    });
  }

  void remove(int i){
    setState(() {
      widget.items.removeAt(i);
      save();
    });
  }

  Future load() async{
    var preferences =  await SharedPreferences.getInstance();
    var data = preferences.getString('data');
    if(data != null){
      Iterable decoder = jsonDecode(data);
      List<Item> result = decoder.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var preferences  = await SharedPreferences.getInstance();
    await preferences.setString("data", jsonEncode(widget.items));
  }

  _HomePageState(){
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: TextFormField(
              controller: newTaskCtrl,
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24
              ),
              decoration: InputDecoration(
                labelText: "Nova Tarefa",
                labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12
                )
              ),
            )
        ),

      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (ctx, i){
          final item  = widget.items[i];
          return Dismissible(
            child: CheckboxListTile(
                title: Text(item.title),
                value: item.done,
                onChanged: (value){
                  setState(() {
                    item.done = value;
                    save();
                  });
                }
            ),
            key: Key(item.title),
            background: Container(
              color: Colors.redAccent.withOpacity(.2),
            ),
            onDismissed: (direction){
              print(direction);
              remove(i);
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          add();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigoAccent,
      ),
    );
  }
}





