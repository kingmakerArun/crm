import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ReportDate.dart';
import 'ReportService.dart';
import 'colors.dart';
import 'dashboard.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {

  String dName=FirebaseAuth.instance.currentUser!.displayName!;

  fun(String Name, String mailId, String mobileNo) async {
    // Perform update logic here
    final Map<String, dynamic> updateData = {

      "leadName": Name,
      "mailId": mailId,
      "mobileNo": int.parse(mobileNo),
      "source": selectedService,
      "service": selectedService,
      "status": selectedService,
      "createdBy": dName
    };
    const String updateUrl = "http://localhost:3001/lead/post/api";

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
      MaterialPageRoute(builder: (context) => const board()),
    );
  }

  static List<String> ServiceName =<String> [];
  String? selectedService;
  fetchServiceData() async {
    final response = await http.post(
        Uri.parse('http://localhost:3001/service/get/api'),

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
      for(var data in jsonData){
        String Servicename1=data["serviceName"];
        ServiceName.add(Servicename1);
        print(ServiceName);
        String ServiceDate1=data["createdOn"];
      }
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon:Icon(Icons.arrow_back_rounded),
        onPressed: (){
          setState(() {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> board()));
          });
        }),
        title: Text( "Reports",style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/reports.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Search by Date",style: g),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 50,
                    width: 145,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'from Date',
                        icon: Image.asset( 'assets/date.jpg', width: 30.0, height: 20.0, fit: BoxFit.cover),
                        enabledBorder: OutlineInputBorder(
                            borderSide:BorderSide(color: Colors.orange)), // Optional: Add border decoration
                        // You can customize other decoration properties as needed
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          // value: selectedService,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedService = newValue;
                            });
                          },
                          items: ServiceName.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 50,
                    width: 145,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'from Date',
                        icon: Image.asset( 'assets/date.jpg', width: 30.0, height: 20.0, fit: BoxFit.cover),
                        enabledBorder: OutlineInputBorder(
                            borderSide:BorderSide(color: Colors.orange)), // Optional: Add border decoration
                        // You can customize other decoration properties as needed
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          // value: selectedService,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedService = newValue;
                            });
                          },
                          items: ServiceName.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: (){
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ReportDate()));
                  });
                }, child: Text("Search")),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Search by details",style: g),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 50,
                    width: 315,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Search',
                        icon: Image.asset( 'assets/search.png', width: 30.0, height: 20.0, fit: BoxFit.cover),
                        enabledBorder: OutlineInputBorder(
                            borderSide:BorderSide(color: Colors.orange)), // Optional: Add border decoration
                        // You can customize other decoration properties as needed
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedService,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedService = newValue;
                            });
                          },
                          items: ServiceName.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: (){
                  setState(() {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ReportService()));
                  });
                }, child: Text("Search")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
