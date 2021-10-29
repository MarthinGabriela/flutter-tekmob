import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tekmob/screens/splash.dart';
import 'package:tekmob/screens/sign/login.dart';
import 'package:tekmob/screens/sign/register.dart';
import 'package:tekmob/screens/wrapper_home.dart';
import 'package:tekmob/services/userRepo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserRepo?>.value(
        value: AuthService().user,
        catchError: (e, err) => null,
        initialData: null,
        child: MaterialApp(home: WrapperHome()));
  }
}



// void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp();
//   runApp(MaterialApp(initialRoute: '/', routes: {
    // '/': (context) => StreamProvider<UserRepo?>.value(
    //     value: AuthService().user,
    //     initialData: null,
    //     child: MaterialApp(home: WrapperHome())),
    // '/login': (context) => Login(),
    // '/signup': (context) => SignUp(),
//   }));
// }