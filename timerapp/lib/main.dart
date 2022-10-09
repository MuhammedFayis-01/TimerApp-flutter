import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homeapp(),
    );
  }
}

class Homeapp extends StatefulWidget {
  @override
  State<Homeapp> createState() => _HomeappState();
}

class _HomeappState extends State<Homeapp> {
  int hours = 0;

  int minutes = 0;

  int second = 0;

  String digitssecond = '00';

  String digitshours = '00';

  String digitsminuts = '00';

  Timer? timer;

  bool Started = false;

  List timelaps = [];
  bool makePause = false;
  bool powerStart = false;

  //fn
  void stop() {
    timer!.cancel();
    setState(() {
      Started = false;
    });
  }

  void reset() {
    makeStart();
    timer!.cancel();
    setState(() {
      second = 0;
      minutes = 0;
      hours = 0;

      digitssecond = '00';
      digitsminuts = '00';
      digitshours = '00';
    });
  }

  void addlaps() {
    String snap = '$digitshours:$digitsminuts:$digitssecond';
    setState(() {
      timelaps.add(snap);
    });
  }

  void makeStart() {
    setState(() {
      makePause = false;
      powerStart = false;
    });
  }

  void makepause() {
    setState(() {
      makePause = true;
      powerStart = true;
    });
  }

  void start() {
    makepause();

    Started = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localsecond = second + 1;
      int localminutes = minutes;
      int localhours = hours;

      if (localsecond > 59) {
        if (localminutes > 59) {
          localhours++;
          localminutes = 0;
        } else {
          localminutes++;
          localsecond = 0;
        }
      }
      setState(() {
        second = localsecond;
        minutes = localminutes;
        hours = localhours;

        digitssecond = (second >= 10) ? '$second' : '0$second';
        digitsminuts = (minutes >= 10) ? '$minutes' : '0$minutes';
        digitshours = (hours >= 10) ? '$hours' : '0$hours';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Text(
                  'Stop Watch',
                  style: TextStyle(
                      fontSize: 29,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                  child: Text(
                "$digitshours:$digitsminuts:$digitssecond",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 79,
                ),
              )),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  itemCount: timelaps.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'lap n $index',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            '${timelaps[index]}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: RawMaterialButton(
                    onPressed: () {
                      (!Started) ? start() : stop();
                    },
                    shape: StadiumBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 35, 183, 22))),
                    child: Text(
                        makePause == false && powerStart == false
                            ? 'start'
                            : 'pause',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  )),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      addlaps();
                    },
                    icon: Icon(Icons.flag),
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: RawMaterialButton(
                    onPressed: reset,
                    fillColor: Color.fromARGB(255, 2, 16, 28),
                    shape: StadiumBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 100, 183, 22))),
                    child: Text('Reset',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
