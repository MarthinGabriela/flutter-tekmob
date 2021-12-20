import 'dart:convert';

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
import 'package:tekmob/elements/loading.dart';

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
  List<String> listPackageId = [];
  List<String> listWarehouseId = [];
  List<String> listMappingId = [];
  var packages = [];
  var mapDropdown = new Map();
  var warehouseDropdownId;

  String newCompanyId = "";
  String newCompanyName = "";
  String newWarehouseName = "";
  String newWarehouseId = "";

  String dropdownValue = "";

  List<PackageRepo> packageList = [];
  List<PackageRepo> itemBaruList = [];
  String itemName = "";
  String warehouseIdById = "";
  var warehouses;

  @override
  void didChangeDependencies() async {
    final SharedPreferences prefs = await _prefs;
    var cartList = prefs.getStringList('cart_list');
    var warehouseList = prefs.getStringList('warehouse_list');
    await getAllPackages();
    // prefs.clear();
    setState(() {
      load = true;
      newCompanyId = prefs.getString("companyId").toString();
      newCompanyName = prefs.getString("companyName").toString();
      newWarehouseName = prefs.getString("warehouseName").toString();
      newWarehouseId = prefs.getString("warehouseId").toString();
    });
    await getWarehouseList(newCompanyId);
    if (cartList != null) await getCardPackage();

    // cartList?.forEach((cart) => print(cart.toString()));
    // warehouseList?.forEach((warehouse) => print(warehouse.toString()));
    // print(prefs.getStringList('cart_list'));

    setState(() {
      if (cartList != null) {
        listMappingId = cartList;
      } else {
        listMappingId = [];
      }
      load = false;
    });

    // print(listWarehouse);
    super.didChangeDependencies();
  }

  Future<void> getAllPackages() async {
    var collection =
        await FirebaseFirestore.instance.collectionGroup('packages').get();
    var newColl = [];
    // print("KONTOL");
    // print(collection.docs);
    // // print("huehue");
    collection.docs.forEach((element) {
      if (element.data()['packageId'] != null) {
        newColl.add(element.data());
        // print(element.data());
      }
      // print(element.data()['packageId']);
    });

    setState(() {
      packages = newColl;
    });
  }

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    final SharedPreferences prefs = await _prefs;
    var cartList = prefs.getStringList('cart_list');
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print("that one");
      print(barcodeScanRes);
      String newId = "";
      packages.forEach((element) {
        if (element['packageId'] == barcodeScanRes) {
          newId = element['warehouseId'];
        }
      });
      if (newId == "") {
        setState(() {
          manualPackageValidator = true;
        });
      } else {
        setState(() {
          listMappingId.add(barcodeScanRes);
          // cartList?.add(barcodeScanRes);
          getPackage(barcodeScanRes);
          // prefs.setStringList('cart_list', cartList!);
          manualPackageValidator = false;
        });
      }

      print(listMappingId);
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
    final SharedPreferences prefs = await _prefs;
    var cartList = prefs.getStringList('cart_list');
    var warehouseList = prefs.getStringList('warehouse_list');
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print("this one?");
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      ean_id = barcodeScanRes;
    });
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
      if (data['name'] == newWarehouseName) {
        listdocs.remove(data);
      }
      setState(() {
        listWarehouse = listdocs;
        dropdownValue = listWarehouse[0]['name'];
        print("dropdown value = " + dropdownValue);
      });
    }
  }

  Future<void> getPackage(packageId) async {
    final SharedPreferences prefs = await _prefs;
    var cartList = prefs.getStringList('cart_list');
    var warehouseList = prefs.getStringList('warehouse_list');
    var newPack;

    if (cartList != null) {
      cartList.forEach((cart) => listPackageId.add(cart.toString()));
      warehouseList
          ?.forEach((warehouse) => listWarehouseId.add(warehouse.toString()));
    }

    var collection =
        await FirebaseFirestore.instance.collectionGroup("packages").get();

    print("kontol");
    print(collection);
    collection.docs.forEach((element) {
      if (element.data()['packageId'] == packageId) {
        newPack = element.data();
      }
    });
    // Map<String, dynamic>? data = collection.data();
    // var data = null;
    // print(data);
    if (newPack != null) {
      print("masuk not null");
      listPackageId.add(newPack['packageId'].toString());
      listWarehouseId.add(newPack['warehouseId'].toString());
      prefs.setStringList("cart_list", listPackageId);
      prefs.setStringList("warehouse_list", listWarehouseId);

      setState(() {
        manualPackageValidator = false;
        listPackageId = [];
        listWarehouseId = [];
      });
    } else {
      setState(() {
        manualPackageValidator = true;
      });
    }
  }

  Future<void> getCardPackage() async {
    print("masuk getcardpackage");
    final SharedPreferences prefs = await _prefs;
    // prefs.clear();
    var cartList = prefs.getStringList('cart_list');
    var warehouseList = prefs.getStringList('warehouse_list');
    int? size = cartList?.length;

    for (int i = 0; i < size!; i++) {
      var collection = await FirebaseFirestore.instance
          .collection('companies')
          .doc(newCompanyId)
          .collection('warehouses')
          .doc(warehouseList![i])
          .collection('packages')
          .doc(cartList![i])
          .get();
      Map<String, dynamic>? data = collection.data();

      var nameCollection = await FirebaseFirestore.instance
          .collection('companies')
          .doc(newCompanyId)
          .collection('warehouses')
          .doc(data!['warehouseId'])
          .get();

      Map<String, dynamic>? newName = nameCollection.data();

      Map<String, dynamic>? newData = {
        "packageId": data['packageId'],
        "title": data['title'],
        "warehouseId": data['warehouseId'],
        "companyId": newCompanyId,
        "items": data['items'],
        "description": data['description'],
        "createdAt": data['createdAt'].toDate().toString(),
        "warehouse": newName!['name']
      };

      packageStorage.setItem(data['packageId'], newData);
      // print("hasil localstorage = ");
      // print(packageStorage.getItem(data['packageId']));
    }

    print("selesai getcardpackage");
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      // var newId;
      // packages.forEach((element) {
      //   if (element['packageId'] == docId) {
      //     newId = element['warehouseId'];
      //   }
      // });
      var collectionRef = FirebaseFirestore.instance
          .collection('companies')
          .doc(newCompanyId)
          .collection('warehouses');

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
                              await getPackage(manualPackageId);
                              if (manualPackageValidator == true) {
                                Navigator.of(context).pop();
                              } else {
                                print("masuk else abis get package");
                                final SharedPreferences prefs = await _prefs;
                                var cartList = prefs.getStringList('cart_list');
                                if (cartList != null) {
                                  setState(() {
                                    listMappingId = cartList;
                                  });
                                }

                                Navigator.of(context).pop();
                              }
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
                child: Text("Inbound",
                    style: header_3.copyWith(
                        color: purpleDark, fontFamily: 'QuickSand')),
              ),
              SizedBox(
                height: 32,
              ),
              Container(
                child: load == true
                    ? Loading()
                    : Column(
                        children: listMappingId
                            .map((package) => PackageCart(
                                uid: widget.uid,
                                // packageData: packageStorage.getItem(package.toString()),
                                packageData: packages.firstWhere((element) =>
                                    element["packageId"] == package)))
                            .toList(),
                      ),
              ),
              load == true
                  ? SizedBox(
                      height: 16,
                    )
                  : Container(
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 0),
                      child: Ink(
                        // color: purpleDark,
                        child: InkWell(
                            onTap: () async {
                              await showAddPackage(context);
                            },
                            child: WideButton(
                                buttonText: "+ Add Package",
                                colorSide: "Dark")),
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
            ],
          ),
        )),
      ),
    );
  }
}
