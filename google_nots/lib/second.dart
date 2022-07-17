import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'database_system.dart';
import 'main.dart';

class title extends StatefulWidget {
  const title({Key? key}) : super(key: key);

  @override
  _titleState createState() => _titleState();
}

class _titleState extends State<title> {

  bool error = false;
  bool validate = false;
  bool _validate = false;

  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();

  Database? Db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    system().initlizedata().then((value) {
      Db = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: t1,
                decoration: InputDecoration(
                  hintText: "Title",
                  errorText: validate ? "plz enter Title" : null,
                ),
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: t2,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: "Note",

                  errorText: error ? "plz enter note" : null,
                ),
                style: TextStyle(fontSize: 15),
              ),

            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: t3,

                decoration: InputDecoration(
                  errorText: _validate ? "plz enter date" : null,
                  icon: Icon(Icons.calendar_today),
                  labelText: "Select Date and Time",
                ),

                  onTap: () {


                    DateTimeRangePicker(
                        startText: "From",
                        endText: "To",
                        doneText: "Yes",
                        cancelText: "Cancel",
                        interval: 5,
                        initialStartTime: DateTime.now(),
                        initialEndTime: DateTime.now().add(Duration(days: 20)),
                        mode: DateTimeRangePickerMode.dateAndTime,
                        minimumTime: DateTime.now().subtract(Duration(days: 5)),
                        maximumTime: DateTime.now().add(Duration(days: 25)),
                        use24hFormat: true,
                        onConfirm: (start, end) {
                          String formate = DateFormat('dd-MM-yyyy  HH:mm:ss ').format(start);
                          t3.text = formate;
                          print(start);
                          print(end);
                        }).showPicker(context);

                    // TimeRange result = await showTimeRangePicker(
                    //   context: context,
                    // );
                    // print("result " + result.toString());





                    // DatePicker.showDatePicker(context,
                    //     showTitleActions: true,
                    //     minTime: DateTime(2018, 3, 5),
                    //     maxTime: DateTime(2023, 6, 7), onChanged: (date) {
                    //       print('change $date');
                    //     }, onConfirm: (date) {
                    //       print('confirm $date');
                    //       setState(() {
                    //         String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                    //         t3.text = formattedDate;
                    //       });
                    //     }, currentTime: DateTime.now(), locale: LocaleType.en);

                  },
              ),
            ),
            ElevatedButton(
                onPressed: () {

                  String title = t1.text;
                  String text = t2.text;
                  String date = t3.text;

                  if (title.isEmpty) {
                    setState(() {
                      validate = true;
                    });
                  } else if (text.isEmpty) {
                    setState(() {
                      error = true;
                    });
                  }else if (date.isEmpty) {
                    setState(() {
                      _validate = true;
                    });
                  }
                  else {
                    setState(() {
                      validate = false;
                      error = false;
                      _validate = false;

                      system().insert(title, text, date , Db!).then((value) {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return note();
                            },
                          ));
                        });

                    });
                  }
                  print("$title");
                  print("$text");
                  print("$date");
                },
                child: Text("Submit"))
          ],
        ),
      ),
    );
  }
}


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: RaisedButton(
            onPressed: () async {
              TimeRange result = await showTimeRangePicker(
                context: context,
              );
              print("result " + result.toString());
            },
            child: Text("Pure"),
          ),
        ));
  }
}