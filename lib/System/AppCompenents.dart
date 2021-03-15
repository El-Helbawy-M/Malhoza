import 'dart:io';
import 'package:flutter/material.dart';
import 'package:molahza/Screens/ChangeNoteScreen.dart';
import 'package:molahza/Screens/MainScreen.dart';
import 'package:molahza/Screens/TrashScreen.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'DataListner.dart';

Map<String, dynamic> colorList = {
      'white': Colors.white,
      "red": Colors.red[100],
      "blue": Colors.blue[100],
      "green": Colors.green[100],
      "yellow": Colors.yellow[100],
      "orange": Colors.orange[100],
      "purple": Colors.purple[100],
    },
    textcolorList = {
      "red": Colors.red,
      "black": Colors.black,
      "blue": Colors.blue,
      "green": Colors.green,
      "yellow": Colors.yellow,
      "orange": Colors.orange,
      "purple": Colors.purple,
    },
    pdftextcolorList = {
      "red": PdfColors.red,
      "black": PdfColors.black,
      "blue": PdfColors.blue,
      "green": PdfColors.green,
      "yellow": PdfColors.yellow,
      "orange": PdfColors.orange,
      "purple": PdfColors.purple,
    };

//=====================================================
//=====================================================
//=====================================================
//=====================================================

class ListViewNote extends StatelessWidget {
  const ListViewNote({
    this.image,
    this.notecolor,
    this.subject,
    this.title,
    this.id,
    this.onTap,
    this.textColor,
  });
  final title, subject, notecolor, image, id, onTap, textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => DataListner(),
              child: ChangeNoteScreen(title, subject, colorList[notecolor],
                  image, id, textcolorList[textColor]),
            ),
          ),
          (route) => false,
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: colorList[notecolor],
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: .5, color: Colors.grey),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (image != "") ? Image.file(File(image)) : SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                title,
                maxLines: 3,
                style: TextStyle(fontSize: 25, color: textcolorList[textColor]),
              ),
            ),
            Text(
              subject,
              maxLines: 6,
              style: TextStyle(
                fontSize: 17,
                color: textcolorList[textColor],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//=====================================================
//=====================================================
//=====================================================
//=====================================================

class Trash extends StatefulWidget {
  const Trash({
    this.image,
    this.notecolor,
    this.subject,
    this.title,
    this.id,
    this.fun,
  });
  final title, subject, notecolor, image, id, fun;

  @override
  _TrashState createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  bool select = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        widget.fun(select);
        setState(() => select = !select);
      },
      child: Container(
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: colorList[widget.notecolor],
            borderRadius: BorderRadius.circular(5),
            border: (select)
                ? Border.all(width: 1.5, color: Colors.black)
                : Border.all(width: .5, color: Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (widget.image != "")
                  ? Image.file(File(widget.image))
                  : SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  widget.title,
                  maxLines: 3,
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Text(
                widget.subject,
                maxLines: 6,
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//=====================================================
//=====================================================
//=====================================================
//=====================================================

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("Images/MalhozeAsset 6.png"))),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 50,
              endIndent: 50,
              height: 20,
            ),
            ListTile(
              leading: Icon(Icons.note),
              title: Text("Notes"),
              onTap: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => MainScreen())),
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text("Trashes"),
              onTap: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => TrashScreen())),
            ),
          ],
        ),
      ),
    );
  }
}

//=====================================================
//=====================================================
//=====================================================
//=====================================================

AppBar appBar(key) => new AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        "Trashes",
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: IconButton(
          color: Colors.black,
          icon: Icon(Icons.subject),
          onPressed: () {
            key.currentState.openDrawer();
          },
        ),
      ),
    );

//=====================================================
//=====================================================
//=====================================================
//=====================================================

SnackBar message(int numb, String op, Color color) => SnackBar(
      content: Text(
        "$numb Trashes have been $op",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
