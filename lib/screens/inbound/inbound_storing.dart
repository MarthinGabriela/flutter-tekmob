import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:tekmob/elements/button_socmed.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/button_login_logout.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tekmob/elements/item_card_storing.dart';
import 'package:tekmob/elements/loading.dart';

class InboundStoring extends StatefulWidget {
  final String uid;
  final String packageId;
  final String warehouseId;

  const InboundStoring(
      {required this.uid, required this.packageId, required this.warehouseId});

  @override
  _InboundStoringState createState() => _InboundStoringState();
}

class _InboundStoringState extends State<InboundStoring> {
  final firestoreInstance = FirebaseFirestore.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String userCompanyId = '';
  String userWarehouseId = '';
  var packageData;
  List<dynamic> itemsPackageData = [];
  List<dynamic> itemsPackage = [];
  bool load = false;
  var allShelvesData = [];
  var allShelvesId = [];
  String dropdownValue = "Warehouse";

  String newCompanyId = "";
  String newCompanyName = "";
  String newWarehouseName = "";
  String newWarehouseId = "";
  var arr;

  @override
  void didChangeDependencies() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      load = true;
      newCompanyId = prefs.getString("companyId").toString();
      newCompanyName = prefs.getString("companyName").toString();
      newWarehouseName = prefs.getString("warehouseName").toString();
      newWarehouseId = prefs.getString("warehouseId").toString();
    });
    print("newcompanyid = " + newCompanyId);
    print("newwarehouseid = " + newWarehouseId);
    // print("===========================");
    // print("masuk inbound storing");
    // print(widget.uid);
    // print(widget.warehouseId);
    // print(widget.packageId);
    // await getData(widget.uid);
    await getPackageData();
    await getPackageDataNames();
    await getShelves();

    super.didChangeDependencies();

    print("selesai didchangedependencies");
  }

  Future<void> getPackageData() async {
    print("masuk getpackagedata");
    var collection = await FirebaseFirestore.instance
        .collection('companies')
        .doc(newCompanyId)
        .collection('warehouses')
        .doc(widget.warehouseId)
        .collection('packages')
        .doc(widget.packageId)
        .get();
    Map<String, dynamic>? data = collection.data();
    setState(() {
      packageData = data;
      itemsPackageData = packageData['items'];
    });
    // print(packageData);
    print("selesai getpackagedata");
  }

  Future<void> getPackageDataNames() async {
    try {
      var collectionRef = FirebaseFirestore.instance
          .collection('companies')
          .doc(newCompanyId)
          .collection('products');
      // var products = await collectionRef.get();
      // products = products.docs.forEach((product) => product.data());

      // print(products);

      itemsPackageData.forEach((item) async {
        print("masuk masuk");
        var temp;
        var doc = await collectionRef.doc(item['id']).get();
        if (doc.exists) {
          temp = {
            'id': item['id'],
            'quantity': item['quantity'],
            'name': doc['name'],
            'shelves': 'temp',
          };
          setState(() {
            itemsPackage.add(temp);
          });
          // print("didalem getpackagedatanames = " + itemsPackage.toString());
        }
      });
      print(itemsPackage);

      setState(() {
        load = false;
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> getShelves() async {
    print("masuk getshelves");
    var collectionRef = FirebaseFirestore.instance
        .collection('companies')
        .doc(newCompanyId)
        .collection('warehouses')
        .doc(newWarehouseId)
        .collection('shelves');

    QuerySnapshot querySnapshot = await collectionRef.get();

    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    final allDataId = querySnapshot.docs.map((doc) => doc.id).toList();

    setState(() {
      allShelvesData = allData;
      allShelvesId = allDataId;
      dropdownValue = allShelvesId[0].toString();
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
                    print("pack = " + packageData['items'].toString());
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
            child: Text("Storing Package",
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
                    children: itemsPackage
                        .map((package) => Center(
                              child: Column(children: <Widget>[
                                Container(
                                    alignment: Alignment.center,
                                    // height: MediaQuery.of(context).size.height * 0.06,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 16, 0, 0),
                                          child: Text("ID: " + package['id'],
                                              style: normalText.copyWith(
                                                color: blueViolet,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "OpenSans",
                                              )),
                                        ),
                                        Container(
                                            margin: EdgeInsets.fromLTRB(
                                                16, 16, 16, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(package['name'],
                                                    style: normalText.copyWith(
                                                      color: Colors.black,
                                                      fontFamily: "OpenSans",
                                                    )),
                                                Text(
                                                    package['quantity']
                                                        .toString(),
                                                    style: normalText.copyWith(
                                                      color: blueViolet,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "OpenSans",
                                                    )),
                                              ],
                                            )),
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.32,
                                            child: DropdownButton<String>(
                                              value: dropdownValue,
                                              // hint: Text(dropdownValue),
                                              items: allShelvesId.map((value) {
                                                return DropdownMenuItem<String>(
                                                  value: value.toString(),
                                                  child: Text(value.toString()),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  package['shelves'] =
                                                      value.toString();
                                                  // warehouseDropdownId =
                                                  //     mapDropdown[
                                                  //         dropdownValue];
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16,
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: 16,
                                )
                              ]),
                            ))
                        .toList(),
                  ),
          ),
          SizedBox(
            height: 48,
          ),
          Container(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Ink(
                // color: purpleDark,
                child: InkWell(
                    onTap: () async {
                      final SharedPreferences prefs = await _prefs;
                      var shelvesId;
                      var itemsShelves;
                      var cartList = prefs.getStringList('cart_list');
                      var warehouseList = prefs.getStringList('warehouse_list');
                      List<String> newCartList = [];
                      List<String> newWarehouseList = [];
                      for (var element in itemsPackage) {
                        print("masuk loop itemspackage");
                        shelvesId = element['shelves'];
                        if (shelvesId == 'temp') {
                          shelvesId = dropdownValue;
                        }

                        var itemAdd = {
                          "quantity": element['quantity'],
                          "id": element['id']
                        };

                        var collection = await FirebaseFirestore.instance
                            .collection('companies')
                            .doc(newCompanyId)
                            .collection('warehouses')
                            .doc(newWarehouseId)
                            .collection('shelves')
                            .doc(shelvesId)
                            .get();

                        Map<String, dynamic>? data = collection.data();
                        itemsShelves = data?['items'];
                        itemsShelves.add(itemAdd);

                        print(itemsShelves);

                        var updatedFb = await firestoreInstance
                            .collection('companies')
                            .doc(newCompanyId)
                            .collection('warehouses')
                            .doc(newWarehouseId)
                            .collection('shelves')
                            .doc(shelvesId)
                            .update({"items": itemsShelves});
                      }
                      // itemsPackage.forEach((element) async {
                      //   print("masuk loop itemspackage");
                      //   shelvesId = element['shelves'];
                      //   if (shelvesId == 'temp') {
                      //     shelvesId = dropdownValue;
                      //   }

                      //   var itemAdd = {
                      //     "quantity": element['quantity'],
                      //     "id": element['id']
                      //   };

                      //   var collection = await FirebaseFirestore.instance
                      //       .collection('companies')
                      //       .doc(newCompanyId)
                      //       .collection('warehouses')
                      //       .doc(newWarehouseId)
                      //       .collection('shelves')
                      //       .doc(shelvesId)
                      //       .get();

                      //   Map<String, dynamic>? data = collection.data();
                      //   itemsShelves = data?['items'];
                      //   itemsShelves.add(itemAdd);

                      //   print(itemsShelves);

                      //   var updatedFb = await firestoreInstance
                      //       .collection('companies')
                      //       .doc(newCompanyId)
                      //       .collection('warehouses')
                      //       .doc(newWarehouseId)
                      //       .collection('shelves')
                      //       .doc(shelvesId)
                      //       .update({"items": itemsShelves});
                      // });

                      var size = cartList?.length;

                      for (int i = 0; i < size!; i++) {
                        if (cartList?[i] != widget.packageId) {
                          print(i);
                          print(cartList?[i]);
                          newCartList.add(cartList![i]);
                          newWarehouseList.add(warehouseList![i]);
                          // cartList?.removeAt(i);
                          // warehouseList?.removeAt(i);
                          // cartList?[i]
                        }
                      }
                      print(widget.packageId);
                      // print(cartList);
                      // print(newCartList);
                      print(warehouseList);
                      print(newWarehouseList);
                      prefs.setStringList('cart_list', newCartList);
                      prefs.setStringList('warehouse_list', newWarehouseList);
                      Navigator.of(context).pop();
                    },
                    child: WideButton(
                        buttonText: "Store Package", colorSide: "Not Dark")),
              )),
        ],
      )),
    )));
  }
}
