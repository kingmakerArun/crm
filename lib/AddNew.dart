import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'LeadList.dart';
import 'package:http/http.dart' as http;


class AddNew extends StatefulWidget {
  const AddNew({super.key});

  @override
  State<AddNew> createState() => _AddNewState();
}

class _AddNewState extends State<AddNew> {

  String dName=FirebaseAuth.instance.currentUser!.displayName!;
  String emailId=FirebaseAuth.instance.currentUser!.email!;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _mobileNo = TextEditingController();
  final TextEditingController _mailId = TextEditingController();
  bool _show =false;
  var name = "";
  var id = "";

  @override
  void initState() {
    super.initState();
    fetchServiceData();
    fetchSourceData();
    fetchStatusData();
  }


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
        //print("lead Created successfully!");
      } else {
        // Failed to update
        //print("Failed to Created service.");
      }
    } catch (error) {
      // Error handling
      //print("Error updating service: $error");
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LeadList()),
    );
  }
  final _key = GlobalKey<FormState>();
  a() {
    setState(() {
      _show = _name.text.isNotEmpty &&
          _mobileNo.text.isNotEmpty &&
          _mailId.text.isNotEmpty == true;
    });
  }

  static List<String> serviceName =<String> [];
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
    //print(response.body);
    //print(response.statusCode);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      for(var data in jsonData){
        String serviceName1=data["serviceName"];
        serviceName.add(serviceName1);
        //print(serviceName);
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  static List<String> sourceName = [];
  String? selectedSource;
  fetchSourceData() async {
    final response = await http.post(
        Uri.parse('http://localhost:3001/source/get/api'),

        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "createdBy": dName,
        })
    );

    //print(response.body);
    //print(response.statusCode);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      for(var data in jsonData){
        String sourceName1=data["sourceName"];
        sourceName.add(sourceName1);
        //print(sourceName);
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  static List<String> statusName = [];
  String? selectedStatus;
  fetchStatusData() async {
    final response = await http.post(
        Uri.parse('http://localhost:3001/status/get/api'),

        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "createdBy": dName,
        })
    );

    //print(response.body);
    //print(response.statusCode);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      for(var data in jsonData){
        String statusName1=data["statusName"];
        statusName.add(statusName1);
        //print(StatusName);
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            setState(() {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const LeadList()));
            });
          },
        ),
        title: const Text("Add New Lead"),
        centerTitle: true,
      ),
      body:
      Form(
        key: _key,
         autovalidateMode: AutovalidateMode.always,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    icon: Image.asset(
                      'assets/user.png',
                      width: 30.0,
                      height: 20.0,
                      fit: BoxFit.cover,
                    ),
                    labelText: 'Enter the Name',
                  ),
                  validator: (input) {
                    if (input == null ||
                        input.isEmpty ||
                        !RegExp(r"^[a-zA-Z]").hasMatch(input)) {
                      return 'please enter valid name';
                    }
                    return null;
                  },
                  onChanged: (input) {
                    a();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _mobileNo,
                  decoration: InputDecoration(
                    icon: Image.asset(
                      'assets/smartphone.png',
                      width: 30.0,
                      height: 20.0,
                      fit: BoxFit.cover,
                    ),
                    labelText: 'enter the Phone number',
                  ),
                  validator: (input) {
                    if (input == null ||
                        input.isEmpty ||
                        !RegExp(r"^[0-9]").hasMatch(input) ||
                        input.length != 10) {
                      return 'please enter phone number';
                    }
                    return null;
                  },
                  onChanged: (input) {
                    a();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: _mailId,
                  decoration: InputDecoration(
                    icon: Image.asset(
                      'assets/mail.png',
                      width: 30.0,
                      height: 20.0,
                      fit: BoxFit.cover,
                    ),
                    labelText: 'enter the email address',
                  ),
                  validator: (input) {
                    if (input == null ||
                        input.isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(input)) {
                      return 'please enter valid email address';
                    }
                    return null;
                  },
                  onChanged: (input) {
                    a();
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 50,
                  width: 400,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Service',
                      icon:  Image.asset( 'assets/service.png', width: 30.0, height: 20.0, fit: BoxFit.cover),
                      enabledBorder: const OutlineInputBorder(
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
                        items: serviceName.map<DropdownMenuItem<String>>((String value) {
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 50,
                  width: 400,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Source',
                      icon:  Image.asset( 'assets/source1.png', width: 30.0, height: 20.0, fit: BoxFit.cover),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:BorderSide(color: Colors.orange)), // Optional: Add border decoration
                      // You can customize other decoration properties as needed
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedSource,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedSource = newValue;
                          });
                        },
                        items: sourceName.map<DropdownMenuItem<String>>((String value) {
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  height: 50,
                  width: 400,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Status',
                      icon:  Image.asset( 'assets/status.png', width: 30.0, height: 20.0, fit: BoxFit.cover),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:BorderSide(color: Colors.orange)), // Optional: Add border decoration
                      // You can customize other decoration properties as needed
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedStatus,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedStatus = newValue;
                          });
                        },
                        items: statusName.map<DropdownMenuItem<String>>((String value) {
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
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        a();
                        fun(
                            _name.text,
                            _mailId.text,
                            _mobileNo.text
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LeadList()));
                      });
                    },
                    child: const Text("Add"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        a();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddNew()),
                        );
                      });
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
