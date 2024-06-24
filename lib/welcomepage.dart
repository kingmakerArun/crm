import 'package:flutter/material.dart';
import 'createAccount.dart';
import 'login.dart';

class welcomeScreen extends StatefulWidget {
  const welcomeScreen({super.key});

  @override
  State<welcomeScreen> createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    final screenHeight = mediaQueryData.size.height;
    final isPortrait = mediaQueryData.orientation == Orientation.portrait;
    final pixelRatio = mediaQueryData.devicePixelRatio;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // height: double.infinity,
          // width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://www.royacdn.com/unsafe/Site-c166794d-f215-4ca8-854d-8fb5742c92a6/Assets/Welcome_background_V3.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top:300.0),
                child: Container(
                  height: 300,
                  width: 450,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://cdn.pixabay.com/photo/2016/05/17/19/08/hyacinth-1398839_640.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 400.0, top: 300),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const LoginScreen()));
                          });
                        },
                        child: Text("Sign-in")),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const createAccount()));
                          });
                        },
                        child: Text("Sign-up")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
