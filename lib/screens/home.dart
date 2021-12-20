import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:tekmob/elements/box_events.dart';
import 'package:tekmob/screens/inbound/inbound_addpackage.dart';
import 'package:tekmob/screens/inventory/inventory_home.dart';
import 'package:tekmob/screens/outbound/outbound_home.dart';
import 'package:tekmob/screens/wrapper_home.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/button_login_logout.dart';
import 'package:tekmob/elements/button_socmed.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  final String uid;

  const Home({required this.uid});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService authService = AuthService();
  final firestoreInstance = FirebaseFirestore.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String companyId = "";
  String companyName = "";
  String dropdownValue = "";
  var listWarehouse = [];
  var mapDropdown = new Map();
  String warehouseDropdownId = "";

  @override
  void didChangeDependencies() async {
    final SharedPreferences prefs = await _prefs;

    await getCompany(widget.uid);
    await getWarehouses(companyId);

    try {
      await saveToPrefs();
    } catch (e) {
      return await FirebaseAuth.instance.signOut();
    }

    print("company id = " + prefs.getString("companyId").toString());
    print("company name = " + prefs.getString("companyName").toString());
    print("warehouse id = " + prefs.getString("warehouseId").toString());
    print("warehouse name = " + prefs.getString("warehouseName").toString());

    setState(() {
      companyId = prefs.getString("companyId").toString();
      companyName = prefs.getString("companyName").toString();
      if (prefs.getString("warehouseName") != null &&
          prefs.getString("warehouseName") != "") {
        print('titit');
        print(prefs.getString("warehouseName"));
        dropdownValue = prefs.getString("warehouseName").toString();
        warehouseDropdownId = prefs.getString("warehouseId").toString();
      }
    });

    super.didChangeDependencies();
  }

  Future<void> getCompany(id) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(id).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      // var value = data?['warehouseIds'][0];
      setState(() => companyId = data?['companyId']);
    }
  }

  Future<void> getWarehouses(id) async {
    print("masuk get warehouse");
    var collection = FirebaseFirestore.instance.collection('companies');
    var docSnapshot = await collection.doc(id).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() => companyName = data?['name']);
    }
    QuerySnapshot collections = await FirebaseFirestore.instance
        .collection('companies')
        .doc(id)
        .collection('warehouses')
        .get();
    var listdocs = collections.docs;
    setState(() {
      listWarehouse = listdocs;
      dropdownValue =
          (listdocs[0]['name'] != "") ? listdocs[0]['name'] : "kontol";
      print("dropdown getWarehouses = " + dropdownValue);
    });
  }

  Future<void> saveToPrefs() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("companyId", companyId);
    prefs.setString("companyName", companyName);
    // prefs.setString("warehouseId", warehouseDropdownId);
    // setState(() {
    //   dropdownValue = prefs.getString('warehouseName').toString();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 56,
                ),
                Center(
                    child: Container(
                  width: 80,
                  child: const Image(
                    image: AssetImage('assets/crypto_logo.png'),
                  ),
                )),
                SizedBox(height: 56),
                Center(
                    child: Text(companyName,
                        style: normalText.copyWith(color: violet))),
                SizedBox(height: 15),
                Center(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    items: listWarehouse.map((value) {
                      mapDropdown[value['name']] = value.id;
                      return DropdownMenuItem<String>(
                        value: value['name'].toString(),
                        child: Text(value['name'].toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() async {
                        dropdownValue = value.toString();
                        warehouseDropdownId = mapDropdown[dropdownValue];
                        final SharedPreferences prefs = await _prefs;
                        prefs.setString("warehouseId", warehouseDropdownId);
                        prefs.setString("warehouseName", dropdownValue);
                        print(warehouseDropdownId);
                      });

                      setState(() async {
                        final SharedPreferences prefs = await _prefs;
                        dropdownValue =
                            prefs.getString("warehouseName").toString();
                        warehouseDropdownId =
                            prefs.getString("warehouseId").toString();
                      });
                    },
                  ),
                ),
                SizedBox(height: 75),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Ink(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () async {
                          final SharedPreferences prefs = await _prefs;
                          if (prefs.getString('warehouseId') == null ||
                              prefs.getString('warehouseId') == "") {
                            prefs.setString("warehouseName", dropdownValue);
                            prefs.setString(
                                'warehouseId', mapDropdown[dropdownValue]);
                          }
                          // else {
                          // prefs.setString("warehouseId", warehouseDropdownId);
                          // prefs.setString("warehouseName", dropdownValue);
                          // }
                          // prefs.setString("warehouseId", warehouseDropdownId);
                          // prefs.setString("warehouseName", dropdownValue);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InboundPackage(
                                    uid: widget.uid,
                                  )));
                        },
                        child: BoxEvent(
                            text: "Inbound",
                            iconEvents: Image(
                                height: 56,
                                width: 56,
                                image: AssetImage('assets/inbound_icon.png'))),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                    ),
                    Ink(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () async {
                          final SharedPreferences prefs = await _prefs;
                          if (prefs.getString('warehouseId') == null ||
                              prefs.getString('warehouseId') == "") {
                            prefs.setString("warehouseName", dropdownValue);
                            prefs.setString(
                                'warehouseId', mapDropdown[dropdownValue]);
                          }
                          //  else {
                          //   prefs.setString("warehouseId", warehouseDropdownId);
                          //   prefs.setString("warehouseName", dropdownValue);
                          // }
                          // prefs.setString("warehouseId", warehouseDropdownId);
                          // prefs.setString("warehouseName", dropdownValue);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OutboundHome(
                                    uid: widget.uid,
                                  )));
                        },
                        child: BoxEvent(
                            text: "Outbound",
                            iconEvents: Image(
                                height: 56,
                                width: 56,
                                image: AssetImage('assets/outbound_icon.png'))),
                      ),
                    ),
                  ],
                )),
                SizedBox(height: 40),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Ink(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () async {
                          final SharedPreferences prefs = await _prefs;
                          if (prefs.getString('warehouseId') == null ||
                              prefs.getString('warehouseId') == "") {
                            prefs.setString("warehouseName", dropdownValue);
                            prefs.setString(
                                'warehouseId', mapDropdown[dropdownValue]);
                          }
                          // else {
                          //   prefs.setString("warehouseId", warehouseDropdownId);
                          //   prefs.setString("warehouseName", dropdownValue);
                          // }
                          // prefs.setString("warehouseId", warehouseDropdownId);
                          // prefs.setString("warehouseName", dropdownValue);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InventoryHome(
                                    uid: widget.uid,
                                  )));
                        },
                        child: BoxEvent(
                            text: "Inventory",
                            iconEvents: Image(
                                height: 56,
                                width: 56,
                                image:
                                    AssetImage('assets/inventory_icon.png'))),
                      ),
                    ),
                  ],
                )),
                SizedBox(height: 56),
                Container(
                    padding: EdgeInsets.fromLTRB(60, 0, 60, 0),
                    child: Ink(
                      // color: purpleDark,
                      child: InkWell(
                          onTap: () async {
                            final SharedPreferences prefs = await _prefs;
                            if (prefs.getString('warehouseId') == null ||
                                prefs.getString('warehouseId') == "") {
                              prefs.setString("warehouseName", dropdownValue);
                              prefs.setString(
                                  'warehouseId', mapDropdown[dropdownValue]);
                            }
                            // else {
                            //   prefs.setString(
                            //       "warehouseId", warehouseDropdownId);
                            //   prefs.setString("warehouseName", dropdownValue);
                            // }
                            await authService.signOut();
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new WrapperHome()));
                          },
                          child: WideButton(
                            buttonText: "Log Out",
                            colorSide: "Dark",
                          )),
                    )),
              ],
            ))));
  }
}
