import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:tekmob/elements/button_socmed.dart';
import 'package:tekmob/elements/loading.dart';
import 'package:tekmob/elements/packageList_card.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/button_login_logout.dart';
import 'package:tekmob/screens/outbound/outbound_addpackage.dart';
import 'package:tekmob/services/package/packageListRepo.dart';
import 'package:tekmob/services/package/packageRepo.dart';
import 'package:tekmob/screens/inbound/inbound_addpackage.dart';

class OutboundHome extends StatefulWidget {
  final String uid;

  const OutboundHome({required this.uid});

  @override
  _OutboundHomeState createState() => _OutboundHomeState();
}

class _OutboundHomeState extends State<OutboundHome> {
  final _formKey = GlobalKey<FormState>();

  List<PackageList> listOfPackage = [];

  // String title = "";
  // String description = "";
  // String destination = "";
  // String ean_id = "";
  // String qty = "";
  // String item = "";
  String idWarehouse = "";
  String warehouse = "";
  String stringofPackage = "cancel";
  String itemName = "";

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   print("masuk1");
  //   print(stringofPackage);
  //   if (stringofPackage.contains(" ")) {
  //     print("masuk2");
  //     List<String> splittedSOP = stringofPackage.split(" ");
  //     for (int i = 0; i < splittedSOP.length; i++) {
  //       if (!(splittedSOP[i] == "cancel")) {
  //         print(splittedSOP[i]);
  //       }
  //     }
  //   }
  // }

  Future<void> getData(id) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(id).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var value = data?['warehouseIds'][0];
      setState(() => idWarehouse = value);
    }
  }

  Future<void> getWarehouse(id) async {
    var collection = await FirebaseFirestore.instance
        .collection('companies')
        .doc("KQHwcd4s2YAjlH0MgZhu")
        .collection('warehouses')
        .doc(id)
        .get();
    Map<String, dynamic>? data = collection.data();
    setState(() => warehouse = data?["name"]);
  }

  Future<bool> getItemName(String eanId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance
          .collection('companies')
          .doc("KQHwcd4s2YAjlH0MgZhu")
          .collection('products');

      var doc = await collectionRef.doc(eanId).get();
      if (doc.exists) itemName = doc['name'];
      return doc.exists;
    } catch (e) {
      throw e;
    }
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
                  "Do you want to create a new package or add from existing one?",
                  style: normalText.copyWith(
                      color: purpleDark, fontFamily: "Open Sans"),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 32, 0, 16),
                    child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Ink(
                                // color: purpleDark,
                                child: InkWell(
                                    onTap: () async {
                                      print("tambil baru");
                                    },
                                    child: WideButton(
                                        buttonText:
                                            "Add from Existing Packages",
                                        colorSide: "Not Dark")),
                              )),
                          Container(
                              padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                              child: Ink(
                                // color: purpleDark,
                                child: InkWell(
                                    onTap: () async {
                                      // print("1. " + stringofPackage);
                                      await getData(widget.uid);
                                      await getWarehouse(idWarehouse);
                                      Navigator.pop(context);
                                      final res = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  OutboundPackage(
                                                    uid: widget.uid,
                                                    warehouseId: warehouse,
                                                  )));

                                      setState(() {
                                        stringofPackage += res.toString();
                                        // listOfPackage = [];
                                      });

                                      var collectionRef = FirebaseFirestore
                                          .instance
                                          .collection('companies')
                                          .doc("KQHwcd4s2YAjlH0MgZhu")
                                          .collection('warehouses')
                                          .doc(idWarehouse)
                                          .collection('packages');

                                      print("masuk1");
                                      print("stringofPackage = " +
                                          stringofPackage);
                                      if (stringofPackage.contains(" ")) {
                                        setState(() {
                                          listOfPackage = [];
                                        });
                                        print("masuk2");
                                        List<String> splittedSOP =
                                            stringofPackage.split(" ");
                                        for (int i = 0;
                                            i < splittedSOP.length;
                                            i++) {
                                          if (!(splittedSOP[i] == "cancel")) {
                                            List<PackageRepo> listItem = [];

                                            var doc = await collectionRef
                                                .doc(splittedSOP[i])
                                                .get();

                                            for (int i = 0;
                                                i < doc["items"].length;
                                                i++) {
                                              await getItemName(
                                                  doc['items'][i]['id']);
                                              PackageRepo packageRepo =
                                                  PackageRepo(
                                                      eanId: doc["items"][i]
                                                          ['id'],
                                                      quantity: doc["items"][i]
                                                          ['quantity'],
                                                      name: itemName);
                                              listItem.add(packageRepo);
                                            }

                                            PackageList newPackList =
                                                PackageList(
                                                    listItem: listItem,
                                                    packageId: splittedSOP[i]);
                                            print("haha");
                                            setState(() {
                                              listOfPackage.add(newPackList);
                                            });
                                          }
                                        }
                                      }

                                      print("listofPackage size is = " +
                                          listOfPackage.length.toString());

                                      for (int i = 0;
                                          i < listOfPackage.length;
                                          i++) {
                                        print("package number " +
                                            i.toString() +
                                            " id = " +
                                            listOfPackage[i].packageId);
                                        print("package number " +
                                            i.toString() +
                                            " listItem length = " +
                                            listOfPackage[i]
                                                .listItem
                                                .length
                                                .toString());
                                      }
                                    },
                                    child: WideButton(
                                        buttonText: "Create a new Package",
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
            backgroundColor: Colors.white,
            body: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(32, 32, 0, 0),
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
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                    child: Text("Outbound",
                        style: header_3.copyWith(
                            color: purpleDark, fontFamily: 'QuickSand')),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                              child: Text("Packages",
                                  style: header_5.copyWith(
                                      color: blueDark, fontFamily: 'OpenSans')),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              child: Column(
                                children: listOfPackage
                                    .map((package) => PackageListWidget(
                                          packageList: package,
                                          // deletePackage: () {
                                          //   setState(() {
                                          //     packageList.remove(package);
                                          //   });
                                          // },
                                          // editPackage: () async {
                                          //   await showEditAddItem(
                                          //       context,
                                          //       // package.eanId, package.name, package.quantity,
                                          //       package);
                                          // }
                                        ))
                                    .toList(),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(32, 8, 32, 0),
                                child: Ink(
                                  // color: purpleDark,
                                  child: InkWell(
                                      onTap: () async {
                                        await showAddPackage(context);
                                      },
                                      child: WideButton(
                                          buttonText: "+ Add Packages",
                                          colorSide: "Dark")),
                                )),
                          ]))
                ],
              ),
            ))));
  }
}
