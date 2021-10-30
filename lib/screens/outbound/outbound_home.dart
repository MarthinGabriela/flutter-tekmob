import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/button_login_logout.dart';

class OutboundHome extends StatefulWidget {
  const OutboundHome({Key? key}) : super(key: key);

  @override
  _OutboundHomeState createState() => _OutboundHomeState();
}

class _OutboundHomeState extends State<OutboundHome> {
  final formKey = GlobalKey<FormState>();

  String title = "";
  String description = "";
  String destination = "";
  // String item = "";

  Future<void> showAddItem(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text("hahahahahahahahaha"),
              // Form(
              //     key: formKey,
              //     child: Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: <Widget>[
              //           Container(
              //               child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: <Widget>[
              //                 Text("EAN ID",
              //                     style: normalText.copyWith(
              //                         fontFamily: "OpenSans",
              //                         fontWeight: FontWeight.w800,
              //                         color: purpleDark)),
              //               ])),
              //           SizedBox(width: 16),
              //           Container(child: Column()),
              //         ])),
              actions: <Widget>[
                TextButton(
                  child: Text('CLOSE'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.pushNamed(context, "/");
                  },
                )
              ]);
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
                    key: formKey,
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
