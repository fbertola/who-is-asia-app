import 'package:flutter/material.dart';
import 'animated_splash_screen.dart';
import 'predictor.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dog breed",
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(children: <Widget>[
      Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Colors.pinkAccent,
          //   title: Text('Dog Breed classifier'),
          // ),
          body: Predictor()),
      IgnorePointer(
          child: AnimatedSplashScreen(
              color: Colors.pinkAccent //Theme.of(context).accentColor
              ))
    ]));
  }
}
