import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled10/service.dart';
import 'package:untitled10/source.dart';
import 'package:untitled10/status.dart';
import 'LeadList.dart';
import 'Report.dart';
import 'colors.dart';
import 'login.dart';

class board extends StatefulWidget {
  const board({super.key});

  @override
  State<board> createState() => _boardState();
}

class _boardState extends State<board> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LEAD OF PAGE",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        shadowColor: Colors.tealAccent,
        surfaceTintColor: Colors.cyan,
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        "https://t3.ftcdn.net/jpg/03/51/51/28/360_F_351512882_2kFH8IaSe4lyA7SXBLzEXyGKNEgbO1iH.jpg"),
                    fit: BoxFit.cover),
              ),
              child: Center(
                  child: Text(
                "DashBoard",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Service()));
                },
                child: ListTile(
                  tileColor: a,
                  title: Center(child: Text("Service Master", style: b)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => sourc()));
                },
                child: ListTile(
                  tileColor: a,
                  title: Center(child: Text("Source Master", style: b)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => status()));
                },
                child: ListTile(
                  tileColor: a,
                  title: Center(child: Text("Status Master", style: b)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Report()));
                },
                child: ListTile(
                  tileColor: a,
                  title: Center(child: Text("Report", style: b)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child:
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showDialog(
                          context: context,
                          builder: (
                              context,
                              ) {
                            return
                            AlertDialog(
                              title: Text('Are you want to logout?'),
                              actions: <Widget>[
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) =>
                                                      LoginScreen()));
                                        },
                                        child: Text('ok'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                    });
                  },
                  child: Text("Logout", style: f)),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: 220,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => LeadList()));
                      },
                      child: Card(
                        color: a,
                        child: Center(
                          child: Text(
                            "ADD NEW LEAD",
                            style: TextStyle(color: c, fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),

          SizedBox(height: 10,),
          Text("${FirebaseAuth.instance.currentUser!.email}"),
          Text("${FirebaseAuth.instance.currentUser!.displayName}"),
        ],
      ),
    );
  }
}
