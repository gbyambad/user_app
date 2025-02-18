import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_app/authentication/login_screen.dart';
import 'package:user_app/methods/common_methods.dart';
import 'package:user_app/pages/home_page.dart';
import 'package:user_app/widgets/loading_dialog.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameEditingController = TextEditingController();
  TextEditingController userPhoneEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsValiable() {
    cMethods.checkConnectivity(context);
    signUpFormValidation();
  }

  signUpFormValidation() {
    String userName = userNameEditingController.text.trim();
    String userPhone = userPhoneEditingController.text.trim();
    String email = emailEditingController.text.trim();
    String password = passwordEditingController.text.trim();

    if (userName.length < 3) {
      cMethods.displaySnackBar(
          "Your name must be at least 4 or more characters", context);
    } else if (userPhone.length < 7) {
      cMethods.displaySnackBar(
          "Your phone number must be at least 8 or more characters", context);
    } else if (!email.contains("@")) {
      cMethods.displaySnackBar("Please write a valid email", context);
    } else if (password.length < 5) {
      cMethods.displaySnackBar(
          "Your password must be atleast 6 or more characters", context);
    } else {
      registerNewUser();
    }
  }

  registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          const LoadingDialog(messageText: "Registering your account..."),
    );

    final User? userFirebase = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
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

    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);

    Map userDataMap = {
      "name": userNameEditingController.text.trim(),
      "email": emailEditingController.text.trim(),
      "phone": userPhoneEditingController.text.trim(),
      "id": userFirebase.uid,
      "blockStatus": "no"
    };
    userRef.set(userDataMap);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (e) => const HomePage(),
      ),
    );
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
                "Create a Users's Account",
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
                      controller: userNameEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Name",
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
                      controller: userPhoneEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "User Phone",
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
                        "Sign Up",
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Already have an Account? Login Here",
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
