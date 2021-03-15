import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:molahza/System/AppCompenents.dart';
import 'package:molahza/System/DataListner.dart';
import 'package:molahza/System/SQLite.dart';
import 'package:provider/provider.dart';

class ChangeNoteScreen extends StatefulWidget {
  ChangeNoteScreen(this.title, this.subject, this.notecolor, this.image,
      this.id, this.textColor);
  final title, subject, notecolor, image, id, textColor;
  @override
  _ChangeNoteScreenState createState() => _ChangeNoteScreenState();
}

class _ChangeNoteScreenState extends State<ChangeNoteScreen> {
  Color notecolor, textcolor;
  String imagePath;
  @override
  void initState() {
    imagePath = widget.image;
    notecolor = widget.notecolor;
    textcolor = widget.textColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //varbiles :
    var listner = Provider.of<DataListner>(context);
    List<HawkFabMenuItem> fabMenuList = [
      HawkFabMenuItem(
        ontap: () async {
          final imagePicker =
              await ImagePicker().getImage(source: ImageSource.camera);
          setState(() => imagePath = imagePicker.path);
          updateNote(<String, String>{"image": imagePicker.path}, widget.id);
        },
        icon: Icon(Icons.camera_alt),
        label: "Take photo",
        color: Colors.black,
      ),
      HawkFabMenuItem(
        ontap: () async {
          final imagePicker =
              await ImagePicker().getImage(source: ImageSource.gallery);
          setState(() => imagePath = imagePicker.path);
          updateNote(<String, String>{"image": imagePicker.path}, widget.id);
        },
        icon: Icon(Icons.image),
        label: "Add Image",
        color: Colors.black,
      ),
    ];
    //End

    return Scaffold(
      backgroundColor: notecolor,

      //==============================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: notecolor,
        leading: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              listner.clearAll();
              return Navigator.of(context)
                  .pushNamedAndRemoveUntil("MS", (route) => false);
            },
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.border_color,
              size: 20,
              color: Colors.black,
            ),
            itemBuilder: (context) => textcolorList.keys
                .map(
                  (color) => PopupMenuItem<String>(
                    value: color,
                    child: Row(
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: textcolorList[color],
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(color.toUpperCase()),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            onSelected: (colo) {
              setState(() => textcolor = textcolorList[colo]);
              updateNote(<String, String>{"textcolor": colo}, widget.id);
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.color_lens,
              color: Colors.black,
            ),
            itemBuilder: (context) => colorList.keys
                .map(
                  (color) => PopupMenuItem<String>(
                    value: color,
                    child: Row(
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: colorList[color],
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(color.toUpperCase()),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
            onSelected: (colo) {
              setState(() => notecolor = colorList[colo]);
              updateNote(<String, String>{"notecolor": colo}, widget.id);
            },
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == "Delete Image") {
                setState(() => imagePath = "");
                updateNote(<String, String>{"image": ""}, widget.id);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Delete Image',
                child: Container(
                  child: Text("Delete Image"),
                ),
              ),
            ],
          ),
        ],
      ),

      //==============================================

      body: HawkFabMenu(
        icon: AnimatedIcons.menu_close,
        fabColor: Colors.black,
        items: fabMenuList,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imagePath != "")
                  Image.file(File(imagePath))
                else
                  SizedBox(),
                TextFormField(
                  initialValue: widget.title,
                  style: TextStyle(fontSize: 30, color: textcolor),
                  decoration: InputDecoration(
                    hintText: "Title",
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    updateNote(<String, String>{"title": value}, widget.id);
                  },
                ),
                TextFormField(
                  initialValue: widget.subject,
                  style: TextStyle(color: textcolor),
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Subject",
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    listner.changeSubject(value);
                    updateNote(<String, String>{
                      "subject": listner.subject,
                    }, widget.id);
                  },
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
