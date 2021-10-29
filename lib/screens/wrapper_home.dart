import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tekmob/screens/splash.dart';
import 'package:tekmob/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:tekmob/services/userRepo.dart';

class WrapperHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepo?>(context);

    print(user);

    if (user == null) {
      print("SPLLLLLASSSHUU");
      return Splash();
    } else {
      print("HOMEEEEE");
      return Home();
    }

    // return Splash();
  }
}
