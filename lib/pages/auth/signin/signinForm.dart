import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/firebase_services/auth/authentication_service.dart';
import 'package:artisland/main.dart';
import 'package:artisland/pages/auth/signup/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var loading = AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Center(
        child: CircularProgressIndicator(value: null),
      ));

  AlertDialog getErrorDialog(c, String text) {
    return AlertDialog(
      content: Text((text) != null && text.isNotEmpty ? text : "unknown error"),
      actions: [
        TextButton(
          child: Text('ok'),
          onPressed: () {
            Navigator.of(c).pop();
          },
        )
      ],
    );
  }

  void showErrordialog(c, String error) {
    var _c;
    showDialog(
        builder: (c) {
          _c = c;
          return getErrorDialog(_c, error);
        },
        context: c);
  }

  void showLoading(BuildContext c) {
    showDialog(
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: c,
        builder: (c) {
          return loading;
        });
  }

  void hideLoading(c) => Navigator.of(c).pop();

  InputDecoration getOutlineBorder(String label) {
    return new InputDecoration(labelText: label, border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 100)));
  }

  void handleSignIn(BuildContext c) async {
    showLoading(c);
    var res = await AuthenticationService.signIn(email: emailController.text.trim(), password: passwordController.text.trim());
    print("hey: $res");
    if (res == null) {
      hideLoading(c);
    } else {
      hideLoading(c);
      showErrordialog(c, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration getOutlineBorder(String label) {
      return new InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 100)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1)),
          hintStyle: Theme.of(context).textTheme.caption.copyWith(color: Colors.black));
    }

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text("Sign up", style: TextStyle(color: Colors.white)),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (c) => SignUp())),
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text("Sign In", style: TextStyle(color: Colors.white)),
                onPressed: () => handleSignIn(context),
              ),
            ]),
          )
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
