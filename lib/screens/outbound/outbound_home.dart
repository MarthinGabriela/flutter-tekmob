import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:tekmob/elements/button_socmed.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/button_login_logout.dart';

class OutboundHome extends StatefulWidget {
  final String uid;

  const OutboundHome({required this.uid});

  @override
  _OutboundHomeState createState() => _OutboundHomeState();
}

class _OutboundHomeState extends State<OutboundHome> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String description = "";
  String destination = "";
  String ean_id = "";
  String qty = "";
  // String item = "";

  Future<Future<AlertDialog?>> showAddItem(BuildContext context) async {
    return showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
                // key: _formKey,
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 24, 0),
                            child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("EAN ID",
                                      style: normalText.copyWith(
                                          fontFamily: "OpenSans",
                                          fontWeight: FontWeight.w800,
                                          color: purpleDark)),
                                  Container(
                                      width: 144,
                                      child: TextFormField(
                                        style: TextStyle(
                                            color: blueDark,
                                            fontFamily: 'OpenSans'),
                                        decoration: inputFormDecor,
                                        onChanged: (val) {
                                          setState(() => ean_id = val);
                                        },
                                      ))
                                ])),
                        SizedBox(width: 16),
                        Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                              Text("QTY",
                                  style: normalText.copyWith(
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.w800,
                                      color: purpleDark)),
                              Container(
                                  width: 64,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    style: TextStyle(
                                        color: blueDark,
                                        fontFamily: 'OpenSans'),
                                    decoration: inputFormDecor,
                                    onChanged: (val) {
                                      setState(() => qty = val);
                                    },
                                  ))
                            ])),
                      ]),
                ),
                SizedBox(
                  height: 32,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              spreadRadius: 3,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Image.asset('assets/barcode_icon.png'),
                          iconSize: 16,
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: 132),
                      TextButton(
                        child: Text('Add Item'),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: blueViolet,
                          onSurface: Colors.grey,
                        ),
                        onPressed: () {
                          print(ean_id + " " + qty);
                          Navigator.of(context).pop();
                          print(ean_id + "+++++++++++++++++++" + qty);
                          // print('Pressed');
                        },
                      )
                    ],
                  ),
                )
              ],
            )),
            // actions: <Widget>[]
          );
          // TextButton(
          //   child: Text('Add Item'),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //     // Navigator.pushNamed(context, "/");
          //   },
          // )
        });
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
                          Navigator.pushNamed(context, "/");
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
                            child: Text("Title",
                                style: header_5.copyWith(
                                    color: blueDark, fontFamily: 'OpenSans')),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: TextFormField(
                                  style: TextStyle(
                                      color: blueDark, fontFamily: 'OpenSans'),
                                  decoration: inputFormDecor,
                                  onChanged: (val) {
                                    setState(() => title = val);
                                  },
                                  // validator: (val) => val!.isEmpty
                                  //     ? "Please enter an email"
                                  //     : null,
                                )),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                            child: Text("Description",
                                style: header_5.copyWith(
                                    color: blueDark, fontFamily: 'OpenSans')),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: TextFormField(
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  style: TextStyle(
                                      color: blueDark, fontFamily: 'OpenSans'),
                                  decoration: inputFormDecor,
                                  onChanged: (val) {
                                    setState(() => description = val);
                                  },
                                  // validator: (val) => val!.isEmpty
                                  //     ? "Please enter an email"
                                  //     : null,
                                )),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                            child: Text("Items",
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
                                      print(widget.uid);
                                      // await Future.delayed(
                                      //     Duration(seconds: 1));
                                      await showAddItem(context);
                                    },
                                    child: WideButton(
                                        buttonText: "+ Add Item",
                                        colorSide: "Dark")),
                              )),
                          SizedBox(
                            height: 32,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                            child: Text("Destination",
                                style: header_5.copyWith(
                                    color: blueDark, fontFamily: 'OpenSans')),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: TextFormField(
                                  style: TextStyle(
                                      color: blueDark, fontFamily: 'OpenSans'),
                                  decoration: inputFormDecor,
                                  onChanged: (val) {
                                    setState(() => destination = val);
                                  },
                                  // validator: (val) => val!.isEmpty
                                  //     ? "Please enter an email"
                                  //     : null,
                                )),
                          ),
                        ]))
              ],
            ))));
  }
}
