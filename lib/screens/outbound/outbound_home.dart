import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:tekmob/elements/button_socmed.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/button_login_logout.dart';
import 'package:tekmob/screens/outbound/outbound_addpackage.dart';

class OutboundHome extends StatefulWidget {
  final String uid;

  const OutboundHome({required this.uid});

  @override
  _OutboundHomeState createState() => _OutboundHomeState();
}

class _OutboundHomeState extends State<OutboundHome> {
  final _formKey = GlobalKey<FormState>();

  // String title = "";
  // String description = "";
  // String destination = "";
  // String ean_id = "";
  // String qty = "";
  // String item = "";
  String idWarehouse = "";
  String warehouse = "";

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

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
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
                          Navigator.pop(context);
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
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                              child: Ink(
                                // color: purpleDark,
                                child: InkWell(
                                    onTap: () async {
                                      await getData(widget.uid);
                                      await getWarehouse(idWarehouse);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OutboundPackage(
                                                    uid: widget.uid,
                                                    warehouseId: warehouse,
                                                  )));
                                    },
                                    child: WideButton(
                                        buttonText: "+ Add Packages",
                                        colorSide: "Dark")),
                              )),
                        ]))
              ],
            ))));
  }
}
