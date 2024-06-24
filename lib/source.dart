import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'colors.dart';
import 'dashboard.dart';

class sourc extends StatefulWidget {
  const sourc({super.key});

  @override
  State<sourc> createState() => _sourcState();
}

class _sourcState extends State<sourc> {

  String dName=FirebaseAuth.instance.currentUser!.displayName!;

  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void>
  fetchData() async {
    final response = await http.post(
      Uri.parse('http://localhost:3001/source/get/api'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode(<String, dynamic>{
          "createdBy": dName,
        })
    );
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        _data = jsonData.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  TextEditingController sourcecontroller = TextEditingController();
  Future<bool>? _successful;

  Future<bool> fun(String Name) async {
    var result = await http.post(
        Uri.parse("http://localhost:3001/source/post/api"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(<String, dynamic>{
          "sourceName": Name,
          "createdBy": dName,
        }));
    try {
      print(result.body);
      if (result.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => sourc()),
        );
        print("Source updated successfully!");
      } else {
        // Failed to update
        print("Failed to update source.");
      }
    } catch (error) {
      // Error handling
      print("Error updating source: $error");
    }
    return jsonDecode(result.body)["success"];
  }

  ///AlertDialogueBoxEditingData
  TextEditingController _sourceNameController = TextEditingController();
  var name = "";
  var id = "";

  void _showEditDialog(int index) {
    // name=_data[index]["updatedBy"];
    id = _data[index]["_id"];
    _sourceNameController.text = _data[index]["sourceName"];
    // Set the initial value
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Source'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _sourceNameController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform update logic here

                final String updateUrl =
                    "http://localhost:3001/source/update/api/$id";
                final Map<String, String> updateData = {
                  "sourceName": _sourceNameController.text,
                  "updatedBy": dName
                };
                try {
                  final response = await http.post(
                    Uri.parse(updateUrl),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(updateData),
                  );
                  if (response.statusCode == 200) {
                    // Successful update
                    print("Source updated successfully!");
                  } else {
                    // Failed to update
                    print("Failed to update source.");
                  }
                } catch (error) {
                  // Error handling
                  print("Error updating source: $error");
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => sourc()),
                );
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            setState(() {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => board()));
            });
          },
        ),
        title: Text(
          "Source List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Container(
            height: 40,
            width: 50,
            child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
              return IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (
                        context,
                      ) {
                        return AlertDialog(
                          content: Container(
                            height: 150,
                            width: 100,
                            child: (_successful == null
                                ? addedlist()
                                : messagedetail()),
                          ),
                        );
                      });
                },
                icon: Icon(Icons.add),
              );
            }),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(_data[index]['_id']),
            onDismissed: (direction) {
              String idd = _data[index]["_id"];
              setState(() async {
                final String DeleteUrl =
                    "http://localhost:3001/source/delete/api/$idd";
                print(DeleteUrl);
                final Map<String, String> updateData = {};
                try {
                  final response = await http.post(
                    Uri.parse(DeleteUrl),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(updateData),
                  );

                  if (response.statusCode == 200) {
                    // Successful update
                    print("lead Delete successfully!");
                  } else {
                    // Failed to update
                    print("Failed to delete service.");
                  }
                } catch (error) {
                  // Error handling
                  print("Error delete service: $error");
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                child: ListTile(
                  title: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('Source Name: ${_data[index]['sourceName']}',style: h),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('Created By: ${_data[index]['createdBy']}',style: h),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        print(index);
                        _showEditDialog(index);
                      },
                      icon: Icon(Icons.edit)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Column addedlist() {
    return Column(
      children: [
        Text("Add New Source Name", style: g),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: sourcecontroller,
            decoration: InputDecoration(
              hintText: "Source from",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _successful = fun(sourcecontroller.text);
                    Navigator.of(context).pop();
                  });
                },
                child: Text("ok")),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Text("cancel"),
            ),
          ],
        ),
      ],
    );
  }

  FutureBuilder messagedetail() {
    return FutureBuilder(
        future: _successful,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Text("added successfully");
          } else if (snapshot.hasError) {
            return Text("error");
          }
          return CircularProgressIndicator();
        });
  }
}
