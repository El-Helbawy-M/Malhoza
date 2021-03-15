import 'package:flutter/material.dart';
import 'package:molahza/System/AppCompenents.dart';
import 'package:molahza/System/SQLite.dart';

class TrashScreen extends StatefulWidget {
  TrashScreen({Key key}) : super(key: key);

  @override
  _TrashScreenState createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  //Variables:
  //==================================

  List<Map> list = [];
  List<int> selectList = [];
  bool onSelect = false;
  AppBar appBarSelect() => new AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Text(selectList.length.toString()),
        actions: [
          IconButton(
            icon: Icon(Icons.cached),
            color: Colors.black,
            onPressed: () async {
              for (int x = 0; x < selectList.length; x++) {
                List map = await trashess(selectList[x]);
                insertNote(map[0]);
                deleteTrash(selectList[x]);
              }
              key.currentState.showSnackBar(
                message(selectList.length, "recovered", Colors.green),
              );
              endSelecting();
              gettrashes();
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_forever),
            color: Colors.black,
            onPressed: () {
              for (int x = 0; x < selectList.length; x++) {
                deleteTrash(selectList[x]);
              }
              key.currentState.showSnackBar(
                message(selectList.length, "deleted", Colors.red),
              );
              endSelecting();
              gettrashes();
            },
          ),
        ],
      );
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  //==================================

  //Funcations
  //==================================
  startSelecting(int index) => setState(
        () {
          onSelect = true;
          selectList.add(index);
        },
      );
  duratingSelecting({int index, bool check}) => setState(
        () {
          (!check) ? selectList.add(index) : selectList.remove(index);
          if (selectList.length == 0) endSelecting();
        },
      );
  endSelecting() => setState(
        () {
          onSelect = false;
          selectList = [];
        },
      );
  chooseOperation({int index, bool check}) =>
      (selectList.length == 0 && check == false)
          ? startSelecting(index)
          : duratingSelecting(index: index, check: check);

  gettrashes() async {
    if (trashes() != null) {
      list = await trashes();
      setState(() {});
    }
  }

  @override
  void initState() {
    gettrashes();
    super.initState();
  }

  //==================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //==============================================

      key: key,

      //==============================================

      backgroundColor: Colors.white,

      //==============================================

      drawer: AppDrawer(),

      //==============================================

      appBar: (!onSelect) ? appBar(key) : appBarSelect(),

      //==============================================
      body: SingleChildScrollView(
        child: Column(
          children: list
              .map((map) => Trash(
                    title: map["title"],
                    subject: map["subject"],
                    notecolor: map["notecolor"],
                    image: map["image"],
                    id: map["id"],
                    fun: (bool select) => setState(
                      () {
                        chooseOperation(
                          check: select,
                          index: map['id'],
                        );
                      },
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

// List.generate(
//             list.length,
//             (index) => Trash(
//               title: list[index]["title"],
//               subject: list[index]["subject"],
//               notecolor: list[index]["notecolor"],
//               image: list[index]["image"],
//               id: list[index]["id"],
//               fun: (bool select) => setState(
//                 () {
//                   chooseOperation(
//                     check: select,
//                     index: index,
//                   );
//                 },
//               ),
//             ),
//           )
