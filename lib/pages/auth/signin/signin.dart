import 'package:artisland/pages/auth/signin/signinForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sign in"),
      ),
      body: SignInForm(),
    );
  }
}
