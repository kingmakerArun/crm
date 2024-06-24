import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_service.dart';
import 'createAccount.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name="";
  String emailid="";


  late GoogleSignInAccount _userObj;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        "904815360477-in6nfmadvtamr7mldv4tk80do0dv4hlg.apps.googleusercontent.com",
  );

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Check if user is not null before accessing properties
      if (user != null) {
        emailid = user.email!;
        name = user.displayName!;

        print("User Email: $emailid");
        print("User Name: $name");

        // Navigate to the next screen after successful login
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => board()),
        );
      } else {
        print("User is null");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  bool _isChecked = false;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/loginimg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // constraints: const BoxConstraints(maxWidth: 21),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Text(
                'Welcome back',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                'Login to your account',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  hintText: 'Please enter your mail-id',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Please enter your Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  final message = await AuthService().login(
                    email: _userNameController.text,
                    password: _passwordController.text,
                  );
                  if (message!.contains('Success')) {
                    Navigator.push(
                      context,
                       MaterialPageRoute(builder: (context) => board()),
                    );
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  );
                },
                child: const Text('Login'),
              ),
              const SizedBox(
                height: 30.0,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const createAccount(),
                    ),
                  );
                },
                child: const Text('Create Account'),
              ),
              const SizedBox(
                height: 30.0,
              ),
              FloatingActionButton.extended(
                onPressed: () async {
                 // signInWithGoogle();
                },
                icon: Image.asset("assets/google.png",
                  height: 32,width: 32),
                label: Text("sign in with google"),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
}
