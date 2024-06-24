import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Report.dart';
import 'colors.dart';

class ReportService extends StatefulWidget {
  const ReportService({super.key});

  @override
  State<ReportService> createState() => _ReportServiceState();
}

class _ReportServiceState extends State<ReportService> {
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
                  context, MaterialPageRoute(builder: (context) => Report()));
            });
          },
        ),
        title: Text("Service based Report",style: b),
        centerTitle: true,
      ),
      body:ListView.builder(
          itemCount: _data.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
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
              ),
            );
          }),
    );
  }
}
