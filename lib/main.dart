import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  XFile? image;

  void _fontIDImage() async{
    final ImagePicker _picker = ImagePicker();

    final XFile? image2 = await _picker.pickImage(source: ImageSource.SOURCE_FRONT_IDImage);
    setState(() {
      image=image2!;
    });
  }
  void _backIDImage() async{
    final ImagePicker _picker = ImagePicker();

    final XFile? image2 = await _picker.pickImage(source: ImageSource.SOURCE_BACK_IDImage);
    setState(() {
      image=image2!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image==null?Container(): Image.file(File(image!.path)),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: _fontIDImage,
            tooltip: 'Increment',
            child: const Icon(Icons.add_a_photo_outlined),
          ),
          SizedBox(width: 100,),
          FloatingActionButton(
            onPressed: _backIDImage,
            tooltip: 'Increment2',
            child: const Icon(Icons.add_a_photo_rounded),
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
