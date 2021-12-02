import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:tekmob/elements/button_socmed.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/button_login_logout.dart';
import 'package:tekmob/elements/package_card.dart';
import 'package:tekmob/services/package/packageRepo.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';

class InboundPackage extends StatefulWidget {
  final String uid;

  const InboundPackage({required this.uid});

  @override
  _InboundPackageState createState() => _InboundPackageState();
}

class _InboundPackageState extends State<InboundPackage> {
  final _formKey = GlobalKey<FormState>();
  final firestoreInstance = FirebaseFirestore.instance;

  String warehouse = "";
  String title = "";
  String description = "";
  String x = "";
  String y = "";
  String z = "";
  String ean_id = "";
  String qty = "";
  String itemError = "You haven't add any item yet";
  bool errorSwitch = false;

  String _scanQR = '';

  List<PackageRepo> packageList = [];
  List<PackageRepo> itemBaruList = [];
  String itemName = "";

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanQR = barcodeScanRes;
    });
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      ean_id = barcodeScanRes;
    });
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance
          .collection('companies')
          .doc("KQHwcd4s2YAjlH0MgZhu")
          .collection('products');

      var doc = await collectionRef.doc(docId).get();
      if (doc.exists) itemName = doc['name'];
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(30, 30, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(120),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: ElevatedButton(
                      child: Icon(
                        Icons.arrow_back,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.pop(context, " cancel");
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Center(
                child: Column(children: [
                  Container(
                    /*
                @TODO 
                @irhamzh should revised the receiving package and what in store
                */
                    margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                    child: Text("Receive Package",
                        style: header_3.copyWith(
                            color: purpleDark, fontFamily: 'QuickSand')),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  IconButton(
                    // @irhamzh should assign assets
                    icon: Image.asset('assets/barcode_icon.png'),
                    iconSize: 16,
                    onPressed: () async {
                      await scanQR();
                    },
                  ),
                  Text('Scan result : $_scanQR\n'),
                  TextFormField(
                    initialValue: _scanQR,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Your Package Id Here'),
                  ),
                ]),
              )
            ],
          ),
        )),
      ),
    );
  }
}
