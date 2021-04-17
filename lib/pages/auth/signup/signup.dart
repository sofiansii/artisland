import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/domain/user/user_manager.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  BuildContext _context;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void handleSignUn(BuildContext c) {
      showLoading(c);

      UserManager.createUserProfile(emailController.text.trim(), passwordController.text.trim(), "${firstName.text} ${lastName.text}", "male").then(
        (res) {
          print("res: $res");
          if (res == null) {
            hideLoading();
            Navigator.of(context).pop();
          } else {
            hideLoading();
            showErrordialog(res);
          }
        },
      );
    }

    InputDecoration getOutlineBorder(String label) {
      return new InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 100)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1)),
          hintStyle: Theme.of(context).textTheme.caption.copyWith(color: Colors.black));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("sign up"),
      ),
      body: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width - 20) / 2,
                child: TextField(
                  controller: firstName,
                  maxLength: 15,
                  maxLines: 1,
                  decoration: getOutlineBorder("First Name"),
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 20) / 2,
                child: TextField(
                  maxLength: 15,
                  maxLines: 1,
                  controller: lastName,
                  decoration: getOutlineBorder("Last Name"),
                ),
              ),
            ]),
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
            Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text("Sign un", style: TextStyle(color: Colors.white)),
                  ),
                  onPressed: () => handleSignUn(context),
                ))
          ],
        ),
      ),
    );
  }

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
}
