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

class InboundPackage extends StatefulWidget {
  final String uid;

  const InboundPackage({required this.uid});

  @override
  _InboundPackageState createState() => _InboundPackageState();
}

class _InboundPackageState extends State<InboundPackage> {
  final _formKey = GlobalKey<FormState>();
  final firestoreInstance = FirebaseFirestore.instance;
  final LocalStorage packageStorage = new LocalStorage('packageKey');
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String warehouse = "";
  String ean_id = "";
  bool errorSwitch = false;
  String _scanQR = '';
  String manualPackageId = '';
  bool manualPackageValidator = false;
  String companyId = '';
  String warehouseId = '';
  bool load = false;
  var listWarehouse = [];
  var listPackageId = [];
  var mapDropdown = new Map();
  var warehouseDropdownId;

  String dropdownValue = "";

  List<PackageRepo> packageList = [];
  List<PackageRepo> itemBaruList = [];
  String itemName = "";

  @override
  void didChangeDependencies() async {
    setState(() {
      load = true;
    });
    await getData(widget.uid);
    await getWarehouse(companyId, warehouseId);
    await getWarehouseList(companyId);
    print(listWarehouse);
    super.didChangeDependencies();
    print("masuk");
  }

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

  Future<void> getData(id) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(id).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var warehouseValue = data?['warehouseIds'][0];
      var companyValue = data?['companyId'];
      setState(() {
        warehouseId = warehouseValue;
        companyId = companyValue;
      });
    }
  }

  Future<void> getWarehouse(companyId, warehouseId) async {
    var collection = await FirebaseFirestore.instance
        .collection('companies')
        .doc(companyId)
        .collection('warehouses')
        .doc(warehouseId)
        .get();
    Map<String, dynamic>? data = collection.data();
    setState(() => warehouse = data?["name"]);
  }

  Future<void> getWarehouseList(companyId) async {
    QuerySnapshot collection = await FirebaseFirestore.instance
        .collection('companies')
        .doc(companyId)
        .collection('warehouses')
        .get();
    var listdocs = collection.docs;
    for (int i = 0; i < listdocs.length; i++) {
      var data = listdocs[i];
      if (data['name'] == warehouse) {
        listdocs.remove(data);
      }
      setState(() {
        listWarehouse = listdocs;
        dropdownValue = listWarehouse[0]['name'];
      });
    }
  }

  Future<void> getPackage(warehouseId, packageId) async {
    var collection = await FirebaseFirestore.instance
        .collection('companies')
        .doc(companyId)
        .collection('warehouses')
        .doc(warehouseId)
        .collection('packages')
        .doc(packageId)
        .get();
    Map<String, dynamic>? data = collection.data();
    if (data != null) {
      Map<String, dynamic>? newData = {
        "packageId": data['packageId'],
        "title": data['title'],
        "warehouseId": data['warehouseId'],
        "companyId": companyId,
        "items": data['items'],
        "createdAt": data['createdAt'].toDate().toString(),
        "warehouse": dropdownValue.toString()
      };
      listPackageId.add(data['packageId'].toString());
      packageStorage.setItem(data['packageId'], newData);
      // packageStorage.setItem("data", "boobies are the best");
      print("hasil localstorage = ");
      print(packageStorage.getItem(data['packageId']));
      print(packageStorage);
      setState(() {
        manualPackageValidator = false;
        // LANJUTIN MANUAL COEG,
        // tambahin dropdown warehouse
        // bikin caard package??
        // localstorage
      });
    } else {
      setState(() {
        manualPackageValidator = true;
      });
    }
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

  Future<Future<AlertDialog?>> showInputPackage(BuildContext context) async {
    return showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Form(
                  // key:_formKey,
                  child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    width: MediaQuery.of(context).size.width * 0.32,
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      // hint: Text(dropdownValue),
                      items: listWarehouse.map((value) {
                        print("value = " + value.id + " + " + value['name']);
                        mapDropdown[value['name']] = value.id;
                        return DropdownMenuItem<String>(
                          value: value['name'].toString(),
                          child: Text(value['name'].toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          dropdownValue = value.toString();
                          warehouseDropdownId = mapDropdown[dropdownValue];
                          print("dropdownValue = " + dropdownValue);
                          print("warehouse id = " + warehouseDropdownId);
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Please input a Package ID",
                  style: normalText.copyWith(
                      color: purpleDark, fontFamily: "Open Sans"),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 16, 24, 0),
                    child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Center(
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: TextFormField(
                                  style: TextStyle(
                                      color: blueDark, fontFamily: 'OpenSans'),
                                  decoration: inputFormDecor,
                                  onChanged: (val) {
                                    setState(() => manualPackageId = val);
                                  },
                                )),
                          ),
                          SizedBox(height: 24),
                          TextButton(
                            child: Text('Save Product'),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: blueViolet,
                              onSurface: Colors.grey,
                            ),
                            onPressed: () async {
                              await getPackage(
                                  warehouseDropdownId, manualPackageId);
                              if (manualPackageValidator == true) {
                                // Navigator.of(context).pop();
                              }
                              // setState(() {
                              //   PackageRepo newpack = PackageRepo(
                              //       eanId: ean_id,
                              //       quantity: int.parse(qty),
                              //       name: itemName);
                              //   packageList.add(newpack);
                              //   itemBaruList.add(newpack);
                              //   errorSwitch = false;
                              // });

                              // setState(() {
                              //   ean_id = "";
                              //   qty = "";
                              //   itemName = "";
                              // });
                              Navigator.of(context).pop();
                            },
                          )
                        ])),
              ],
            ),
          )));
        });
  }

  Future<Future<AlertDialog?>> showAddPackage(BuildContext context) async {
    return showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Do you want to store a new package with scanner or manually?",
                  style: normalText.copyWith(
                      color: purpleDark, fontFamily: "Open Sans"),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 32, 0, 16),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                              child: Ink(
                                // color: purpleDark,
                                child: InkWell(
                                    onTap: () async {
                                      print("tambil baru");
                                      await scanQR();
                                      Navigator.pop(context);
                                    },
                                    child: WideButton(
                                        buttonText: "Scan a new package",
                                        colorSide: "Not Dark")),
                              )),
                          Container(
                              padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                              child: Ink(
                                child: InkWell(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      await showInputPackage(context);
                                      // final res = await Navigator.of(context)
                                      //   .push(MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           OutboundPackage(
                                      //             uid: widget.uid,
                                      //             warehouseId: warehouse,
                                      //           )));
                                    },
                                    child: WideButton(
                                        buttonText: "Input a new Package",
                                        colorSide: "Not Dark")),
                              )),
                        ])),
              ],
            ),
          ));
        });
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
              Container(
                margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                child: Text("Cart",
                    style: header_3.copyWith(
                        color: purpleDark, fontFamily: 'QuickSand')),
              ),
              SizedBox(
                height: 32,
              ),
              Container(
                child: Column(
                  children: listPackageId
                      .map((package) => PackageCart(
                          packageData:
                              packageStorage.getItem(package.toString())))
                      .toList(),
                ),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                  child: Ink(
                    // color: purpleDark,
                    child: InkWell(
                        onTap: () async {
                          await showAddPackage(context);
                        },
                        child: WideButton(
                            buttonText: "+ Add Package", colorSide: "Dark")),
                  )),
              manualPackageValidator == true
                  ? Center(
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, 16, 0, 32),
                          child: Text("Package tidak ditemukan",
                              style: normalText.copyWith(color: Colors.red))),
                    )
                  : SizedBox(
                      height: 32,
                    ),
              Container(
                  padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                  child: Ink(
                    // color: purpleDark,
                    child: InkWell(
                        onTap: () async {
                          if (listPackageId.isEmpty) {
                            print("empty package");
                          } else {
                            final SharedPreferences prefs = await _prefs;
                            List<String>? tempList = [];
                            if (prefs.getStringList('cart_list') != null) {
                              print('if pertama');
                              tempList = prefs.getStringList('cart_list');
                            }
                            // else {
                            //   print('else null');
                            // }
                            tempList?.add(listPackageId.join(','));
                            prefs.setStringList("cart_list", tempList!);
                            print(prefs.get("cart_list"));
                            setState(() {
                              listPackageId = [];
                            });
                            // prefs.clear();
                            Navigator.of(context).pop();
                          }
                        },
                        child: WideButton(
                            buttonText: "Save Cart", colorSide: "Not Dark")),
                  )),
            ],
          ),
        )),
      ),
    );
  }
}
