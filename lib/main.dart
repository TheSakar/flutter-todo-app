import 'package:flutter/material.dart';
import 'dart:developer';

main() {
  runApp(MaterialApp(
    home: Page1(),
  ));
}

class Page1 extends StatelessWidget {
  final _nameController = TextEditingController();
  final _nameInput = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Welcome to TODO app!')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Write your name here'),
            Center(
              child: Container(
                width: 250,
                child: Form(
                  key: _nameInput,
                  child: TextFormField(
                    controller: _nameController,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: RaisedButton(
                child: Text('Press to initialize the TODO!'),
                onPressed: () {
                  log('name ' + _nameController.text);
                  _nameInput.currentState.validate();
                  Navigator.of(context)
                      .push(_createRoute(_nameController.text));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Route _createRoute(String name) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Page2(name: name),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class Page2 extends StatefulWidget {
  final String name;

  const Page2({Key key, this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Page2State(name);
}

class _Page2State extends State<Page2> {
  List<String> _todos = new List<String>();
  List<String> _happened = new List();
  final String name;
  final _todoInput = new TextEditingController();

  final keys = List<GlobalKey<State>>(); 

  _Page2State(this.name);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text('Hi $name')),
          body: Container(
            margin: EdgeInsets.only(top: 35),
            child: Column(
              children: <Widget>[
                Text('Write your todo here'),
                Form(
                    child: Center(
                  child: Container(
                    width: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          controller: _todoInput,
                        ),
                        RaisedButton(
                          child: Text('Add TODO'),
                          onPressed: () =>
                              setState(() => _todos.add(_todoInput.text)),
                        )
                      ],
                    ),
                  ),
                )),
                getTodos(),
                Container(
                    margin: EdgeInsets.only(top: 20), 
                    child: Column(
                      children: [
                        Text('Done!'),
                        getHappened()
                      ]
                      ),
                    ),
              ],
            ),
          )),
    );
  }

Widget getHappened(){
return Column(
      children: _happened
          .map(
            (todo) => Container(
              height: 22,
              width: 350,
              margin: EdgeInsets.only(top: 13),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: RaisedButton(
                onPressed: () => setState(()=>{
                  _happened.remove(todo),
                }),
                disabledColor: Colors.grey,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    todo,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
            ),
          )
          .toList());
}


Widget getTodos() {
  return Column(
      children: _todos
          .map(
            (todo) => Container(
              height: 22,
              width: 350,
              margin: EdgeInsets.only(top: 13),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: RaisedButton(
                onPressed: () => setState(()=>{
                  _todos.remove(todo),
                  _happened.add(todo)
                }),
                disabledColor: Colors.grey,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    todo,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
              ),
            ),
          )
          .toList());
}

}

