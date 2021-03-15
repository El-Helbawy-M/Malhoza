import 'dart:async';
import 'dart:io';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ChoseDialog extends StatefulWidget {
  ChoseDialog({this.content, this.context, this.path, this.textColor});
  final context, content, path, textColor;
  @override
  _ChoseDialogState createState() => _ChoseDialogState();
}

//======================================
//======================================
//======================================
//======================================

class _ChoseDialogState extends State<ChoseDialog> {
  bool check = false, done = true;
  String name = "file", ext = ".txt";
  @override
  Widget build(BuildContext context) {
    return !check
        ? AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Text('Name & Extension :'),
            content: SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: TextFormField(
                      initialValue: name,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      onChanged: (value) => setState(() => name = value),
                    ),
                  ),
                  DropdownButton<String>(
                    isDense: true,
                    value: ext,
                    underline: Divider(
                      thickness: 0,
                      color: Colors.white,
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Text(".txt"),
                        value: ".txt",
                      ),
                      DropdownMenuItem(
                        child: Text(".pdf"),
                        value: ".pdf",
                      ),
                    ],
                    onChanged: (value) => setState(() => ext = value),
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  if (await Permission.storage.request().isGranted) {
                    if (widget.path == "") {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      String p =
                          await ExtStorage.getExternalStoragePublicDirectory(
                              ExtStorage.DIRECTORY_DOCUMENTS);
                      Directory directory =
                          await Directory("$p/Malhoza/").create();
                      pref.setString("dir", directory.path);
                      fileMap(name, ext, widget.content, directory.path,
                          widget.textColor)[ext]();
                    } else {
                      fileMap(name, ext, widget.content, widget.path,
                          widget.textColor)[ext]();
                    }
                  } else
                    setState(() => done = false);
                  setState(() => check = true);
                },
                child: Center(
                  child: Text("OK"),
                ),
              ),
            ],
          )
        : SplashDialog(
            context: context,
            done: done,
          );
  }
}

//======================================
//======================================
//======================================
//======================================

class SplashDialog extends StatefulWidget {
  SplashDialog({this.context, this.done});
  final context, done;
  @override
  _SplashDialogState createState() => _SplashDialogState();
}

class _SplashDialogState extends State<SplashDialog> {
  String check = "Loading";
  @override
  void initState() {
    Timer(
      Duration(seconds: 2),
      () => setState(() => (widget.done) ? check = "Done" : check = "Faild"),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(child: bodies(context)[check]);
  }
}

//======================================
//======================================
//======================================
//======================================

Map<String, Widget> bodies(BuildContext context) => {
      "Loading": SizedBox(
        width: 250,
        height: 250,
        child: Center(
            child: CircularProgressIndicator(
          strokeWidth: 6,
        )),
      ),
      "Done": FinishDialog(color: Colors.green, icon: Icons.done, str: "Done"),
      "Faild": FinishDialog(
        color: Colors.red,
        icon: Icons.close,
        str: "No Access",
      )
    };

//======================================
//======================================
//======================================
//======================================

class FinishDialog extends StatelessWidget {
  const FinishDialog({this.str, this.color, this.icon});
  final color, str, icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Center(
              child: Icon(
                icon,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: FlatButton(
              onPressed: () => Navigator.pop(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: color,
              child: Text(
                str,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, Function> fileMap(
        String name, String ext, String content, String path, PdfColor color) =>
    {
      ".txt": () async {
        File newFile = await File("$path$name$ext").create();
        newFile = await newFile.writeAsString(content);
      },
      ".pdf": () async {
        final pdf = pw.Document();
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Container(
                child: pw.Text(
                  content,
                  style: pw.TextStyle(color: color),
                ),
              ); // Center
            },
          ),
        );
        final file = File("$path$name$ext");
        await file.writeAsBytes(pdf.save());
      },
    };
