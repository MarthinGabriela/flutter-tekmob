import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/splash_bg.png'), fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
                child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 150,
                ),
                Container(
                  width: 150,
                  child: const Image(
                    image: AssetImage('assets/crypto_logo.png'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                    text: TextSpan(
                        children: <TextSpan>[
                      new TextSpan(text: 'Stock'),
                      const TextSpan(
                          text: 'IT',
                          style: TextStyle(fontWeight: FontWeight.w900)),
                    ],
                        style: const TextStyle(
                          color: Colors.white,
                          // letterSpacing: 2,
                          fontSize: 40,
                          fontFamily: "Quicksand",
                        ))),
                SizedBox(
                  height: 120,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(25),
                        child: TextButton(
                          child: Text('Login',
                              style: const TextStyle(
                                // letterSpacing: 2,
                                fontSize: 20,
                                fontFamily: "Quicksand",
                              )),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: () {
                            Navigator.pushNamed(context, "/login");
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(25),
                        child: TextButton(
                          child: Text('Sign Up',
                              style: const TextStyle(
                                // letterSpacing: 2,
                                fontSize: 20,
                                fontFamily: "Quicksand",
                              )),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: () {},
                        ),
                      ),
                    ]),
                Text("Privacy Policy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: "Quicksand",
                      decoration: TextDecoration.underline,
                    ))
              ],
            )),
          )),
    );
  }
}
