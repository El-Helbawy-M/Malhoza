import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:molahza/System/AppCompenents.dart';
import 'package:molahza/System/DataListner.dart';
import 'package:molahza/System/Dialogs.dart';
import 'package:molahza/System/SQLite.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'NoteScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //=====================================

      key: key,

      //=====================================

      drawer: AppDrawer(),

      //=====================================

      backgroundColor: Colors.white,

      //=====================================

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          int id = Random().nextInt(1000000000);
          await insertNote(<String, dynamic>{
            "title": "",
            "subject": "",
            "notecolor": "white",
            "image": "",
            "textcolor": "black",
            "id": id,
          });
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider<DataListner>(
                  create: (_) => DataListner(),
                  child: NoteScreen(id),
                ),
              ),
              (route) => false);
        },
      ),

      //=====================================

      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
            icon: Icon(Icons.subject, color: Colors.black),
            onPressed: () {
              key.currentState.openDrawer();
            },
          ),
        ),
        title: Text(
          "Malhoza",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),

      //=====================================

      body: SingleChildScrollView(
        child: Notes(),
      ),

      //=====================================
    );
  }
}

//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================

class Notes extends StatefulWidget {
  const Notes({
    Key key,
  }) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  //Variable
  //========================================
  List<Map> list = [];
  String dirPath = "";
  //========================================

  //Funcations :
  //========================================
  loadPath() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("dir") != null)
      setState(() => dirPath = pref.getString("dir"));
  }

  getData() async {
    if (notes() != null) {
      list = await notes();
      setState(() {});
    }
  }

  @override
  void initState() {
    getData();
    loadPath();
    super.initState();
  }
  //========================================

  @override
  Widget build(BuildContext context) {
    if (list == null)
      return Container();
    else
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          list.length,
          (index) => Slidable(
            actionPane: SlidableBehindActionPane(),
            child: ListViewNote(
                title: list[index]["title"],
                subject: list[index]["subject"],
                notecolor: list[index]["notecolor"],
                image: list[index]["image"],
                id: list[index]["id"],
                textColor: list[index]["textcolor"]),
            actions: [
              //==============================

              IconSlideAction(
                closeOnTap: true,
                caption: 'Delete',
                color: Colors.white,
                icon: Icons.delete,
                onTap: () {
                  insertTrash(list[index]);
                  deleteNote(list[index]["id"]);
                  getData();
                },
              ),

              //==============================

              IconSlideAction(
                caption: 'Convert',
                color: Colors.white,
                icon: Icons.compare_arrows,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => ChoseDialog(
                      content:
                          "${list[index]["title"]}\n${list[index]["subject"]}",
                      context: context,
                      path: dirPath,
                      textColor: pdftextcolorList[list[index]["textcolor"]],
                    ),
                  );
                },
              ),

              //==============================
            ],
          ),
        ),
      );
  }
}
