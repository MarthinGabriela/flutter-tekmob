import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:tekmob/elements/box_events.dart';
import 'package:tekmob/screens/inbound/inbound_addpackage.dart';
import 'package:tekmob/screens/outbound/outbound_home.dart';
import 'package:tekmob/screens/wrapper_home.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/button_login_logout.dart';
import 'package:tekmob/elements/button_socmed.dart';
import 'package:tekmob/elements/loading.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryHome extends StatefulWidget {
  final String uid;

  const InventoryHome({required this.uid});

  @override
  _InventoryHomeState createState() => _InventoryHomeState();
}

class _InventoryHomeState extends State<InventoryHome> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool load = false;
  String newCompanyId = "";
  String newCompanyName = "";
  String newWarehouseName = "";
  String newWarehouseId = "";
  var listShelves = [];
  var listProducts = [];
  var editItemIds = ["", ""];
  var editQty = "";

  void didChangeDependencies() async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      load = true;
      newCompanyId = prefs.getString("companyId").toString();
      newCompanyName = prefs.getString("companyName").toString();
      newWarehouseName = prefs.getString("warehouseName").toString();
      newWarehouseId = prefs.getString("warehouseId").toString();
    });

    await getWarehouseData();
    await getAllProducts();
    super.didChangeDependencies();

    setState(() {
      load = false;
    });
  }

  Future<void> getWarehouseData() async {
    print("masuk getWarehouseData()");
    QuerySnapshot collection = await FirebaseFirestore.instance
        .collection('companies')
        .doc(newCompanyId)
        .collection('warehouses')
        .doc(newWarehouseId)
        .collection('shelves')
        .get();
    var listdocs = collection.docs;
    var newListDocs = [];
    print(listdocs.length);

    listdocs.forEach((element) {
      print(element.id);
      print(element['items']);
      if (element['items'].length != 0) {
        newListDocs.add(element);
      }
    });

    setState(() {
      listShelves = newListDocs;
    });
  }

  Future<void> getAllProducts() async {
    print("masuk getAllProducts()");
    QuerySnapshot collection = await FirebaseFirestore.instance
        .collection('companies')
        .doc(newCompanyId)
        .collection('products')
        .get();

    setState(() {
      listProducts = collection.docs;
      print(listProducts);
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
                      child: Text("Inventory",
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
                              children: listShelves
                                  .map((shelve) => Center(
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          // decoration: BoxDecoration(
                                          //   borderRadius:
                                          //       BorderRadius.circular(16),
                                          //   border: Border.all(
                                          //       color: Colors.purple.shade800),
                                          //   color: Colors.white,
                                          // ),
                                          margin:
                                              EdgeInsets.fromLTRB(0, 16, 0, 16),
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    16, 8, 0, 8),
                                                child: Text(
                                                    shelve.id.toString(),
                                                    style: header_4.copyWith(
                                                      color: blueViolet,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "OpenSans",
                                                    )),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    16, 8, 16, 8),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: shelve['items']
                                                      .map<Widget>(
                                                          (item) => Center(
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          16,
                                                                          0,
                                                                          16),
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      1,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            16),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .purple
                                                                            .shade800),
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            16,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            0,
                                                                            16,
                                                                            0,
                                                                            16),
                                                                        child: Text(
                                                                            listProducts
                                                                                .firstWhere(
                                                                                  (element) => element.id == item['id'],
                                                                                )['name']
                                                                                .toString(),
                                                                            style: normalText.copyWith(
                                                                              color: blueViolet,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontFamily: "OpenSans",
                                                                            )),
                                                                      ),
                                                                      Container(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            0,
                                                                            0,
                                                                            16,
                                                                            0),
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            0,
                                                                            16,
                                                                            0,
                                                                            16),
                                                                        child: (editItemIds[0] == shelve.id &&
                                                                                editItemIds[1] == item["id"])
                                                                            ? Row(
                                                                                children: [
                                                                                  IconButton(
                                                                                    icon: const Icon(Icons.minimize, size: 24),
                                                                                    color: Colors.green[600],
                                                                                    tooltip: 'Edit Package',
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        editQty = (int.parse(editQty) - 1).toString();
                                                                                      });
                                                                                    },
                                                                                  ),
                                                                                  Container(
                                                                                    // width: double.infinity,
                                                                                    // height: double.infinity,
                                                                                    // height: MediaQuery.of(context)
                                                                                    //     .size
                                                                                    //     .width *
                                                                                    // 0.8,,
                                                                                    width: 32,
                                                                                    child: (TextFormField(
                                                                                      // initialValue: editQty.toString(),
                                                                                      controller: TextEditingController(text: editQty),
                                                                                      inputFormatters: <TextInputFormatter>[
                                                                                        FilteringTextInputFormatter.digitsOnly
                                                                                      ],
                                                                                    )),
                                                                                  ),
                                                                                  IconButton(
                                                                                    icon: const Icon(Icons.add, size: 24),
                                                                                    color: Colors.green[600],
                                                                                    tooltip: 'Edit Package',
                                                                                    onPressed: () {
                                                                                      setState(() {
                                                                                        editQty = (int.parse(editQty) + 1).toString();
                                                                                      });
                                                                                    },
                                                                                  )
                                                                                ],
                                                                              )
                                                                            : Row(children: [
                                                                                Text("x" + item['quantity'].toString(),
                                                                                    style: normalText.copyWith(
                                                                                      color: blueViolet,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontFamily: "OpenSans",
                                                                                    )),
                                                                                IconButton(
                                                                                  icon: const Icon(Icons.edit, size: 24),
                                                                                  color: Colors.green[600],
                                                                                  tooltip: 'Edit Package',
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      editItemIds = [
                                                                                        shelve.id,
                                                                                        item["id"]
                                                                                      ];
                                                                                      editQty = item["quantity"].toString();
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              ]),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ))
                                                      .toList(),
                                                ),
                                              )
                                            ],
                                          ))))
                                  .toList(),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ));
  }
}
