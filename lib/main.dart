import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'filesPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'File Picker'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        constraints: BoxConstraints(maxWidth: 400),
        padding: EdgeInsets.all(32),
        alignment: Alignment.center,
        child: ElevatedButton(
          child: Text("Pick File"),
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
                allowMultiple: true,
                //Select to Type 
                type: FileType.custom,
                allowedExtensions: ["pdf", "mp4"]);
            if (result == null) {
              return;
            }

            openFiles(result.files);

            // //Open single file
            // final file = result.files.first;
            // openFile(file);

            // //openFile(file)
            // print(
            //     "name : ${file.name} \nBytes : ${file.bytes} \nSize : ${file.size} \nPath : ${file.path}");
            // final newFile = await saveFilePermanently(file);
            // print("From Path : ${file.path!} \nTo Path : ${newFile.path}}");
          },
        ),
      ),
    );
  }

  void openFiles(List<PlatformFile> files) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              FilesPage(files: files, onOpenedFile: openFile)));

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');

    return File(file.path!).copy(newFile.path);
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }
}
