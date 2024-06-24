import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled10/welcomepage.dart';

class otp extends StatefulWidget {
  final String verificationId;
  const otp({super.key, required this.verificationId});

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {

  final otpController = List.generate(6, (index)=> TextEditingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("verification"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index)=> otptext(context,index)),
          ),
          const SizedBox(height: 10,),
          ElevatedButton(onPressed: () async
          {
          try
          {
            String otpget = otpController.map((controller)=> controller.text).join();
            PhoneAuthCredential credential = PhoneAuthProvider.credential
              (verificationId: widget.verificationId, smsCode: otpget);
            await FirebaseAuth.instance.signInWithCredential(credential).then((onValue)
            {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const welcomeScreen()));
            });
          }
          catch(exception)
            {
              log(exception.toString());
            }

          }, child: const Text("verify code")),
        ],
      ),

    );
  }
  Widget otptext(BuildContext context, int index)
  {
    return Container(
      height: 40,width: 40,
      child: TextFormField(
        controller: otpController[index],
        onChanged: (value)
        {
          if(value.length==1)
            {
              FocusScope.of(context).nextFocus();
            }
        },
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          hintText: '0',
          border: OutlineInputBorder(),
        ),

      ),
    );
  }
}
