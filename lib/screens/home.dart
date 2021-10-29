import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:tekmob/elements/box_events.dart';
import 'package:tekmob/screens/wrapper_home.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/button_login_logout.dart';
import 'package:tekmob/elements/button_socmed.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

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
                        style: header_4.copyWith(color: purpleDark))),
                SizedBox(height: 75),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Ink(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {},
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
                        onTap: () {},
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
                        onTap: () {},
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
                          child: WideButton(buttonText: "Log Out")),
                    )),
              ],
            ))));
  }
}
