import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nots/second.dart';
import 'package:sqflite/sqflite.dart';
import 'database_system.dart';

void main() {
  runApp(MaterialApp(
    home: note(),
    debugShowCheckedModeBanner: false,
  ));
}

class note extends StatefulWidget {
  const note({Key? key}) : super(key: key);

  @override
  _noteState createState() => _noteState();
}

class _noteState extends State<note> {
  Database? Db;

  List<Map> list = [];
  List<Map> searchlist = [];
  bool status = false;
  bool search = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Getdata();
  }

  void Getdata() {
    system().initlizedata().then((value) {
      Db = value;
      setState(() {});

      system().viewdata(Db!).then((userdata) {
        list = userdata;
        searchlist = userdata;
        setState(() {
          status = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: search
          ? AppBar(
              title: TextField(
                decoration: InputDecoration(
                    suffix: IconButton(
                        onPressed: () {
                          search = false;
                          setState(() {});
                        },
                        icon: Icon(Icons.search))),
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      searchlist = [];

                      for (int i = 0; i < list.length; i++) {
                        String title = list[i]['title'];
                        if (title.toLowerCase().contains(value.toLowerCase())) {
                          searchlist.add(list[i]);
                        }
                      }
                    } else {
                      searchlist = list;
                    }
                  });
                },
              ),
            )
          : AppBar(
              title: Text("NOTES"),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        search = true;
                      });
                    },
                    icon: Icon(Icons.search))
              ],
            ),
      body: status
          ? ListView.builder(
              itemCount: search ? searchlist.length : list.length,
              itemBuilder: (context, index) {
                Map mm = search ? searchlist[index] : list[index];
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Text(
                          "${mm['title']}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${mm['note']}",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "${mm['date']}",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    // leading: Text("${list[index]['id']}"),
                    // title: Text("${list[index]['title']}"),
                    // subtitle: Text("${list[index]['note']}"),
                  ),
                );
              },
            )
          : CircularProgressIndicator(),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return title();
            },
          ));
        },
      ),
    );
  }
}
