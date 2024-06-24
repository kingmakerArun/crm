import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AddNew.dart';
import 'colors.dart';
import 'dashboard.dart';
import 'package:http/http.dart' as http;

class LeadList extends StatefulWidget {
  const LeadList({super.key});

  @override
  State<LeadList> createState() => _LeadListState();
}

class _LeadListState extends State<LeadList> {

  String dName=FirebaseAuth.instance.currentUser!.displayName!;
  String emailId=FirebaseAuth.instance.currentUser!.email!;

  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void>
  fetchData() async {
       final response = await http.post(
        Uri.parse('http://localhost:3001/lead/get/api'),

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

  TextEditingController _Name = TextEditingController();
  TextEditingController _mobileNo = TextEditingController();
  TextEditingController _mailId = TextEditingController();

  fun(String Name, String mailId, String mobileNo,
      String sourceid, String serviceid,String statusid) async {
    // Perform update logic here
    final Map<String, dynamic> updateData = {

      "leadName": Name,
      "mailId": emailId,
      "mobileNo": 1234567890,
      "source":sourceid,
      "service":serviceid,
      "status":statusid,
      "createdBy":dName
    };
    final String updateUrl = "http://localhost:3001/lead/post/api";

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
        print("lead Created successfully!");
      } else {
        // Failed to update
        print("Failed to Created service.");
      }
    } catch (error) {
      // Error handling
      print("Error updating service: $error");
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LeadList()),
    );
  }


  ///AlertDialogueBoxEditingData
  TextEditingController _leadNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _mailController = TextEditingController();
  var name = "";
  var id = "";

  void _showEditDialog(int index) {
    id = _data[index]["_id"];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return
          AlertDialog(
          title: Text('Edit Lead details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _leadNameController,
                  decoration: InputDecoration(
                    hintText: 'Update the Lead Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    hintText: 'Update the Lead Phone number',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: _mailController,
                  decoration: InputDecoration(
                    hintText: 'Update the Lead mail ID',
                    border: OutlineInputBorder(),
                  ),
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
                    "http://localhost:3001/lead/update/api/$id";
                final Map<String, String> updateData = {
                  "source":"",
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
                    print("Lead updated successfully!");
                  } else {
                    // Failed to update
                    print("Failed to update lead.");
                  }
                } catch (error) {
                  // Error handling
                  print("Error updating lead: $error");
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LeadList()),
                );
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  final _key = GlobalKey<FormState>();
  bool _show = false;

  a() {
    setState(() {
      _show = _Name.text.isNotEmpty &&
          _mobileNo.text.isNotEmpty &&
          _mailId.text.isNotEmpty == true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: a,
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
          "Lead List",
          style: b,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNew()));
                // AddNew();
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body:ListView.builder(
          itemCount: _data.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(_data[index]["_id"]),
              onDismissed: (direction) async {
                String idd = _data[index]["_id"];

                  final String DeleteUrl =
                      "http://localhost:3001/lead/delete/api/$idd";
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
              },
              child: Card(
                child:
                ListTile(
                  title:
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('Lead Name: ${_data[index]['leadName']}',style: h),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('Mobile Number: ${_data[index]['mobileNo']}',style: h),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text('MailId: ${_data[index]['mailId']}',style: h),
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
            );
          }),
    );
  }
}
