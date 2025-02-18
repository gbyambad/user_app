import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:user_app/authentication/signup_screen.dart';
import 'package:user_app/global/global_val.dart';
import 'package:user_app/methods/common_methods.dart';
import 'package:user_app/pages/home_page.dart';
import 'package:user_app/widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsValiable() {
    cMethods.checkConnectivity(context);
    signInFormValidation();
  }

  signInFormValidation() {
    String email = emailEditingController.text.trim();
    String password = passwordEditingController.text.trim();

    if (!email.contains("@")) {
      cMethods.displaySnackBar("Please write a valid email", context);
    } else if (password.length < 5) {
      cMethods.displaySnackBar(
          "Your password must be atleast 6 or more characters", context);
    } else {
      signInUser();
    }
  }

  signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          const LoadingDialog(messageText: "Allowing you to Login..."),
    );

    final User? userFirebase = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
      email: emailEditingController.text.trim(),
      password: passwordEditingController.text.trim(),
    )
            .catchError(
      (ErrorMsg) {
        Navigator.pop(context);
        cMethods.displaySnackBar(ErrorMsg, context);
      },
    ))
        .user;
    if (!context.mounted) return;
    Navigator.pop(context);

    if (userFirebase != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(userFirebase!.uid);

      userRef.once().then((snap) {
        if (snap.snapshot.value != null) {
          if ((snap.snapshot.value as Map)["blockStatus"] == "no") {
            userName = (snap.snapshot.value as Map)["name"];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => const HomePage(),
              ),
            );
          } else {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar(
                "your are blocked. Contact admin: gbyambad@gmail.com", context);
          }
        } else {
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar(
              "your account does not exist as a User", context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset("assets/images/logo.png"),
              const Text(
                "Login as a User",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "User Email",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: passwordEditingController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "User password",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        checkIfNetworkIsValiable();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        "Login",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Don't have an Account? Register Here",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
