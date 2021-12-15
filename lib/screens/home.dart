import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:tekmob/elements/box_events.dart';
import 'package:tekmob/screens/inbound/inbound_addpackage.dart';
import 'package:tekmob/screens/outbound/outbound_home.dart';
import 'package:tekmob/screens/storing/storing_home.dart';
import 'package:tekmob/screens/wrapper_home.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/button_login_logout.dart';
import 'package:tekmob/elements/button_socmed.dart';

class Home extends StatefulWidget {
  final String uid;

  const Home({required this.uid});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService authService = AuthService();

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
                    child: Text("PT. Hebat Terbaik",
                        style: normalText.copyWith(color: violet))),
                SizedBox(height: 15),
                Center(
                    child: Text("Dapur Utara",
                        style: header_5.copyWith(color: purpleDark))),
                SizedBox(height: 75),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Ink(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
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
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     new MaterialPageRoute(
                          //         builder: (context) => new OutboundHome()));

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
                SizedBox(height: 32),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Ink(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StoringHome(
                                    uid: widget.uid,
                                  )));
                        },
                        child: BoxEvent(
                            text: "Storing",
                            iconEvents: Image(
                                height: 56,
                                width: 56,
                                image: AssetImage('assets/storing_icon.png'))),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                    ),
                    Ink(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          // print("lmoa");
                          // print(widget.uid);
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
