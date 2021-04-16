import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/firebase_services/auth/authentication_service.dart';
import 'package:artisland/main.dart';
import 'package:artisland/pages/auth/signup/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatelessWidget {
  BuildContext _context;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var loading = AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Center(
        child: CircularProgressIndicator(value: null),
      ));

  AlertDialog getErrorDialog(String text) {
    return AlertDialog(
      content: Text(text),
      actions: [
        TextButton(
          child: Text('ok'),
          onPressed: () {
            Navigator.of(_context).pop();
          },
        )
      ],
    );
  }

  void showErrordialog(String error) {
    showDialog(
        builder: (c) {
          _context = c;
          return getErrorDialog(error);
        },
        context: _context);
  }

  void showLoading(BuildContext c) {
    showDialog(
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: c,
        builder: (c) {
          _context = c;
          return loading;
        });
  }

  void hideLoading() => Navigator.of(_context).pop();

  InputDecoration getOutlineBorder(String label) {
    return new InputDecoration(labelText: label, border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 100)));
  }

  void handleSignIn(BuildContext c) {
    showLoading(c);
    AuthenticationService.signIn(email: emailController.text.trim(), password: passwordController.text.trim()).then(
      (res) {
        if (res == "ok") {
          hideLoading();
        } else {
          hideLoading();
          showErrordialog(res);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: emailController,
            decoration: getOutlineBorder("Email"),
          ),
          SizedBox(height: 50),
          TextField(
            obscureText: true,
            decoration: getOutlineBorder("password"),
            controller: passwordController,
          ),
          SizedBox(height: 50),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text("Sign In", style: TextStyle(color: Colors.white)),
              color: Colors.blue[400],
              onPressed: () => handleSignIn(context),
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text("Sign Un", style: TextStyle(color: Colors.white)),
              color: Colors.blue[400],
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (c) => SignUp())),
            ),
          ])
        ],
      ),
    );
  }
}

class Label extends StatelessWidget {
  final String label;
  Label(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Text(
          label,
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ));
  }
}
