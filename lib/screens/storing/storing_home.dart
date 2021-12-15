import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:tekmob/elements/button_socmed.dart';
import 'package:tekmob/elements/packageCart_inbound.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/button_login_logout.dart';
import 'package:tekmob/elements/package_card.dart';
import 'package:tekmob/services/package/packageRepo.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoringHome extends StatefulWidget {
  final String uid;

  const StoringHome({required this.uid});

  @override
  _StoringHomeState createState() => _StoringHomeState();
}

class _StoringHomeState extends State<StoringHome> {
  // final _formKey = GlobalKey<FormState>();
  final firestoreInstance = FirebaseFirestore.instance;
  // final LocalStorage packageStorage = new LocalStorage('packageKey');
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void didChangeDependencies() async {
    final SharedPreferences prefs = await _prefs;
    print(prefs.getStringList('cart_list'));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
