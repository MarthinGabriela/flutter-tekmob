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
  final firestoreInstance = FirebaseFirestore.instance;

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
  String dropdownValue = "Choose a warehouse";
  String destinationId = "";
  String description = "";
  bool load = false;
  bool errorSwitch = false;
  var listWarehouse = [];

  @override
  void didChangeDependencies() async {
    setState(() {
      load = true;
    });
    await getData(widget.uid);
    await getWarehouse(idWarehouse);
    super.didChangeDependencies();
    QuerySnapshot collection = await FirebaseFirestore.instance
        .collection('companies')
        .doc("KQHwcd4s2YAjlH0MgZhu")
        .collection('warehouses')
        .get();
    var listdocs = collection.docs;
    for (int i = 0; i < listdocs.length; i++) {
      var data = listdocs[i];
      if (data['name'] == warehouse) {
        listdocs.remove(data);
      }
      print(data['name']);
      // print(data.id);
    }

    setState(() {
      listWarehouse = listdocs;
      dropdownValue = listWarehouse[0]['name'];
      load = false;
    });
  }

  Future<void> getData(id) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(id).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var value = data?['warehouseIds'][0];
      setState(() => idWarehouse = value);
    }
  }

  Future<String> getWarehouseByName(name) async {
    String warehouseTargetId = "";
    QuerySnapshot collection = await FirebaseFirestore.instance
        .collection('companies')
        .doc("KQHwcd4s2YAjlH0MgZhu")
        .collection('warehouses')
        .get();
    var listdocs = collection.docs;
    for (int i = 0; i < listdocs.length; i++) {
      var data = listdocs[i];
      if (data['name'] == name) {
        warehouseTargetId = data['name'];
      }
    }

    return warehouseTargetId;
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
                                      // await getData(widget.uid);
                                      // await getWarehouse(idWarehouse);
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
    return load
        ? Loading()
        : Container(
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
                                          color: blueDark,
                                          fontFamily: 'OpenSans')),
                                ),
                                errorSwitch == false
                                    ? SizedBox(
                                        height: 16,
                                      )
                                    : Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 16, 0, 16),
                                        child: Center(
                                          child: Text(
                                              "You haven't add any package yet",
                                              style: normalText.copyWith(
                                                  color: Colors.red,
                                                  fontFamily: "OpenSans")),
                                        ),
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
                                Container(
                                  margin: EdgeInsets.fromLTRB(32, 16, 0, 0),
                                  child: Text("Destination",
                                      style: header_5.copyWith(
                                          color: blueDark,
                                          fontFamily: 'OpenSans')),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: MediaQuery.of(context).size.width *
                                        0.41,
                                    child: DropdownButton<String>(
                                      value: dropdownValue,
                                      hint: Text(dropdownValue),
                                      items: listWarehouse.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value['name'].toString(),
                                          child: Text(value['name'].toString()),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          dropdownValue = value.toString();
                                          print("dropdownValue = " +
                                              dropdownValue);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                                  child: Text("Description",
                                      style: header_5.copyWith(
                                          color: blueDark,
                                          fontFamily: 'OpenSans')),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: TextFormField(
                                        maxLines: null,
                                        keyboardType: TextInputType.multiline,
                                        style: TextStyle(
                                            color: blueDark,
                                            fontFamily: 'OpenSans'),
                                        decoration: inputFormDecor,
                                        onChanged: (val) {
                                          setState(() => description = val);
                                        },
                                        validator: (val) => val!.isEmpty
                                            ? "Please enter a description"
                                            : null,
                                      )),
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(32, 16, 32, 0),
                                    child: Ink(
                                      // color: purpleDark,
                                      child: InkWell(
                                          onTap: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (listOfPackage.isNotEmpty) {
                                                setState(() {
                                                  errorSwitch = false;
                                                });

                                                List<String> packageArray = [];

                                                for (int i = 0;
                                                    i < listOfPackage.length;
                                                    i++) {
                                                  packageArray.add(
                                                      listOfPackage[i]
                                                          .packageId);
                                                }
                                                var userRef = FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(widget.uid);

                                                var userIni =
                                                    await userRef.get();
                                                // var warehouseIds =
                                                //     userIni['warehouseIds'][0];

                                                var deliveryId;
                                                String warehouseTargetId =
                                                    await getWarehouseByName(
                                                        dropdownValue);

                                                await firestoreInstance
                                                    .collection('companies')
                                                    .doc('KQHwcd4s2YAjlH0MgZhu')
                                                    .collection('deliveries')
                                                    .add({
                                                  "authorFirstName":
                                                      userIni["firstName"],
                                                  "authorLastName":
                                                      userIni["lastName"],
                                                  "authorId": widget.uid,
                                                  "createdAt": DateTime.now(),
                                                  "description": description,
                                                  "status": "ready",
                                                  "warehouseIdFrom":
                                                      idWarehouse,
                                                  "warehouseIdTo":
                                                      warehouseTargetId,
                                                  "packageIds":
                                                      FieldValue.arrayUnion(
                                                          packageArray),
                                                }).then((value) {
                                                  deliveryId = value.id;
                                                });

                                                await firestoreInstance
                                                    .collection('companies')
                                                    .doc('KQHwcd4s2YAjlH0MgZhu')
                                                    .collection('deliveries')
                                                    .doc(deliveryId)
                                                    .update({
                                                  "deliveryId": deliveryId,
                                                });

                                                // if (itemBaruList.isNotEmpty) {
                                                //   for (int i = 0;
                                                //       i < itemBaruList.length;
                                                //       i++) {
                                                //     await firestoreInstance
                                                //         .collection('companies')
                                                //         .doc(
                                                //             'KQHwcd4s2YAjlH0MgZhu')
                                                //         .collection('products')
                                                //         .doc(itemBaruList[i]
                                                //             .eanId)
                                                //         .set({
                                                //       "name":
                                                //           itemBaruList[i].name
                                                //     });
                                                //   }
                                                // }
                                                Navigator.pop(context);
                                              } else {
                                                setState(() {
                                                  errorSwitch = true;
                                                  // itemError = "afafsadaffsfa";
                                                  // itemError =
                                                  //     "You haven't add any item yet";
                                                });
                                              }
                                            }
                                            // Navigator.of(context).pop(context, packageId);
                                          },
                                          child: WideButton(
                                              buttonText: "Save Delivery",
                                              colorSide: "Not Dark")),
                                    )),
                              ])),
                    ],
                  ),
                ))));
  }
}
