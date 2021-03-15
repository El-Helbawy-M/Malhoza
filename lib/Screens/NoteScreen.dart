import 'dart:io';
import 'package:molahza/System/SQLite.dart';
import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:molahza/System/AppCompenents.dart';
import 'package:molahza/System/DataListner.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class NoteScreen extends StatelessWidget {
  NoteScreen(this.id);
  final id;
  @override
  Widget build(BuildContext context) {
    //varbiles :
    var listner = Provider.of<DataListner>(context);
    List<HawkFabMenuItem> fabMenuList = [
      //======================================

      HawkFabMenuItem(
        ontap: () async {
          final imagePicker =
              await ImagePicker().getImage(source: ImageSource.camera);
          listner.changeImage(File(imagePicker.path));
          updateNote(<String, String>{"image": imagePicker.path}, id);
        },
        icon: Icon(Icons.camera_alt),
        label: "Take photo",
        color: Colors.black,
      ),

      //======================================

      HawkFabMenuItem(
        ontap: () async {
          final imagePicker =
              await ImagePicker().getImage(source: ImageSource.gallery);
          listner.changeImage(File(imagePicker.path));
          updateNote(<String, String>{"image": imagePicker.path}, id);
        },
        icon: Icon(Icons.image),
        label: "Add Image",
        color: Colors.black,
      ),

      //======================================
    ];
    //End

    return Scaffold(
      backgroundColor: listner.noteColor,

      //==============================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: listner.noteColor,
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
              listner.changeTextColor(textcolorList[colo]);
              updateNote(<String, String>{"textcolor": colo}, id);
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
              listner.changeNoteColor(colorList[colo]);
              updateNote(<String, String>{"notecolor": colo}, id);
            },
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == "Delete Image") {
                listner.changeImage(null);
                updateNote(<String, String>{"image": ""}, id);
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
                (listner.image == null)
                    ? SizedBox()
                    : Image.file(listner.image),
                TextField(
                  style: TextStyle(fontSize: 30, color: listner.textColor),
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
                    listner.changeTitl(value);
                    updateNote(<String, String>{"title": listner.title}, id);
                  },
                ),
                TextField(
                  maxLines: null,
                  style: TextStyle(color: listner.textColor),
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
                      "title": listner.title,
                      "subject": listner.subject,
                    }, id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
