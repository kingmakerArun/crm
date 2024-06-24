import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'colors.dart';
import 'dashboard.dart';

class Service extends StatefulWidget {
  const Service({super.key});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {


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
      Uri.parse('http://localhost:3001/service/get/api'),

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
        body: jsonEncode(<String, dynamic>{
          "createdBy": dName,
        })
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        _data = jsonData.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool>? _successful;

  Future<bool> fun(String Name) async {
    var result = await http.post(
        Uri.parse("http://localhost:3001/service/post/api"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8'
        },
        body: jsonEncode(<String, dynamic>{
          "serviceName": Name,
          "createdBy": dName,
        }));
    try {
      if (result.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Service()),
        );
        //print("Service updated successfully!");
      } else {
        // Failed to update
        //print("Failed to update service.");
      }
    } catch (error) {
      // Error handling
      //print("Error updating service: $error");
    }

    return jsonDecode(result.body)["success"];
  }

  ///AlertDialogueBoxEditingData
  final TextEditingController _serviceNameController = TextEditingController();
  var name = "";
  var id = "";

  void _showEditDialog(int index) {
    // name=_data[index]["updatedBy"];
    id = _data[index]["_id"];
    _serviceNameController.text = _data[index]["serviceName"];
    // Set the initial value
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Service'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _serviceNameController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform update logic here

                final String updateUrl =
                    "http://localhost:3001/service/update/api/$id";
                final Map<String, String> updateData = {
                  "serviceName": _serviceNameController.text,
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
                    //print("Service updated successfully!");
                  } else {
                    // Failed to update
                   // print("Failed to update service.");
                  }
                } catch (error) {
                  // Error handling
                //  print("Error updating service: $error");
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Service()),
                );
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

//  final _key = GlobalKey<FormState>();
  bool _show = false;

  ab() {
    setState(() {
      _show = _Name.text.isNotEmpty == true;
    });
  }

  final TextEditingController _Name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            setState(() {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const board()));
            });
          },
        ),
        title: const Text(
          "Our Services",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          SizedBox(
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
                          content: SizedBox(
                            height: 150,
                            width: 100,
                            child: (_successful == null
                                ? addedList()
                                : messageDetail()),
                          ),
                        );
                      });
                },
                icon: const Icon(Icons.add),
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
                final String deleteUrl =
                    "http://localhost:3001/service/delete/api/$idd";
                //print(DeleteUrl);
                final Map<String, String> updateData = {};

                try {
                  final response = await http.post(
                    Uri.parse(deleteUrl),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(updateData),
                  );

                  if (response.statusCode == 200) {
                    // Successful update
                   // print("lead Delete successfully!");
                  } else {
                    // Failed to update
                   // print("Failed to delete service.");
                  }
                } catch (error) {
                  // Error handling
                //  print("Error delete service: $error");
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child:
                ListTile(
                  title:
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('Service Name: ${_data[index]['serviceName']}',style: h),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('Created By: ${_data[index]['createdBy']}',style: h),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('Created On: ${_data[index]['createdOn']}',style: h),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        //print(index);
                        _showEditDialog(index);
                      },
                      icon: const Icon(Icons.edit)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Column addedList() {
    return Column(
      children: [
        Text("Service Details", style: g),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child:
          TextFormField(
            controller: _Name,
            decoration: const InputDecoration(
              labelText: 'Please enter the Service name',
              border: OutlineInputBorder(),
            ),
            validator: (input) {
              if (input == null ||
                  input.isEmpty ||
                  !RegExp(r"^[a-zA-Z]").hasMatch(input)) {
                return 'please enter valid service name';
              }
              return null;
            },
            onChanged: (input) {
              ab();
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _successful = fun(_Name.text);
                    Navigator.of(context).pop();
                  });
                },
                child: const Text("ok")),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: const Text("Cancel"),
            ),
          ],
        ),
      ],
    );
  }

  FutureBuilder messageDetail() {
    return FutureBuilder(
        future: _successful,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const Text("added successfully");
          } else if (snapshot.hasError) {
            return const Text("error");
          }
          return const CircularProgressIndicator();
        });
  }
}
