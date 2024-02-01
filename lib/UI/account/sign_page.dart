import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoreboard/UI/home/home_page.dart';

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signIn(
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
        if (value.user != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const HomePage();
              },
            ),
            (route) => false,
          );
        }
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "wrong-password":
          Fluttertoast.showToast(
            msg: "Password wrong!",
            toastLength: Toast.LENGTH_LONG,
          );
          break;
        case "invalid-email":
          Fluttertoast.showToast(
            msg: "Invalid email address!",
            toastLength: Toast.LENGTH_LONG,
          );
          break;
        case "user-disabled":
          Fluttertoast.showToast(
            msg: "This email address has been banned!",
            toastLength: Toast.LENGTH_LONG,
          );
          break;
        case "user-not-found":
          Fluttertoast.showToast(
            msg: "User not found!",
            toastLength: Toast.LENGTH_LONG,
          );
          break;
        default:
      }
    }
  }

  void signUp(
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
        if (value.user != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const HomePage();
              },
            ),
            (route) => false,
          );
        }
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "email-already-in-use":
          Fluttertoast.showToast(
            msg: "This email address already in use. Please use another email address",
            toastLength: Toast.LENGTH_LONG,
          );
          break;
        case "weak-password":
          Fluttertoast.showToast(
            msg: "The password you provided not good enough.",
            toastLength: Toast.LENGTH_LONG,
          );
          break;
        case "invalid-email":
          Fluttertoast.showToast(
            msg: "This email address not valid. Please use another email address",
            toastLength: Toast.LENGTH_LONG,
          );
          break;
        case "operation-not-allowed":
          Fluttertoast.showToast(
            msg: "This email address has been banned",
            toastLength: Toast.LENGTH_LONG,
          );
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 32,
                left: 32,
                right: 32,
                bottom: 8,
              ),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  labelText: "E-mail",
                  hintText: "E-mail",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 32,
                right: 32,
                bottom: 8,
              ),
              child: TextField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password),
                  labelText: "Password",
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (emailController.text != "") {
                        if (passwordController.text != "") {
                          signUp(emailController.text, passwordController.text);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Password can't be null",
                            toastLength: Toast.LENGTH_LONG,
                          );
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "E-mail can't be null",
                          toastLength: Toast.LENGTH_LONG,
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (emailController.text != "") {
                        if (passwordController.text != "") {
                          signIn(emailController.text, passwordController.text);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Password can't be null",
                            toastLength: Toast.LENGTH_LONG,
                          );
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "E-mail can't be null",
                          toastLength: Toast.LENGTH_LONG,
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
