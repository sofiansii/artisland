import 'package:artisland/domain/post/post_manager.dart';
import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/firebase_services/auth/authentication_service.dart';
import 'package:artisland/firebase_services/firebase_firestore.dart';
import 'package:artisland/pages/auth/signin/signinForm.dart';
import 'package:artisland/domain/user/user_manager.dart';
import 'package:artisland/firebase_services/real_time_database/database_services.dart';
import 'package:artisland/firebase_services/storage/firebase_storage.dart';
import 'package:artisland/pages/common/DefaultScaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  ThemeData brightTheme() => ThemeData(
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: Typography.blackCupertino.copyWith(headline6: TextStyle(color: Colors.black), bodyText1: TextStyle(fontSize: 15, color: Colors.black)),
        cardTheme: CardTheme(elevation: 3),
        buttonColor: Color(0xff3b55ce),
        primaryColor: Colors.white,
        primarySwatch: createMaterialColor(Color(0xff3b55ce)),
      );
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: brightTheme(),
      home: MultiProvider(providers: [
        Provider<StoreService>(create: (_) => StoreService(FirebaseFirestore.instance)),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(FirebaseDatabase.instance),
        ),
        Provider(create: (context) => PostManager())
      ], child: AuthWrapper()),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {

    


    return StreamBuilder(
        stream: UserManager.userStream,
        initialData: null,
        builder: (c, snp) {
          print("||||||||||||||||||||||: called");
          if (snp.data != null) {
            return DefualtScaffold();
            return Center(child: CircularProgressIndicator());
          } else
            return SignInForm();
        });

    // return StreamBuilder<User>(
    //     stream: authStream,
    //     // initialData: UserManager.user,
    //     builder: (contex, snp) {
    //       var user = snp.data;
    //       if (user != null) {
    //         return DefualtScaffold();
    //       }
    //       return SignInForm();
    //     });
  }
}
