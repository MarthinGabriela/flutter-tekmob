import 'package:flutter/material.dart';
import 'package:tekmob/screens/splash.dart';
import 'package:tekmob/screens/login.dart';

void main() => runApp(MaterialApp(initialRoute: '/', routes: {
      '/': (context) => Splash(),
      '/login': (context) => Login(),
      // '/dexlist': (context) => DexList(),
      // '/loading_2': (context) => Loading2(),
      // '/dexdetail': (context) => DexDetail(),
//      '/game': (context) => Game(),
//      '/end': (context) => EndScreen(),
//      '/loading2' : (context) => LoadingLast(),
    }));
