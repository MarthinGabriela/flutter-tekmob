import 'package:flutter/material.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:tekmob/screens/wrapper_home.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/loading.dart';
import 'package:tekmob/elements/button_login_logout.dart';
import 'package:tekmob/elements/button_socmed.dart';
import 'package:tekmob/screens/sign/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";
  bool load = false;
  // String firstName = "";
  // String lastName = "";
  // String confPass = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: load
            ? Loading()
            : Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                        child: Text("Sign Up",
                            style: header_3.copyWith(
                                color: purpleDark, fontFamily: 'QuickSand')),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(32, 8, 0, 0),
                        child: Row(
                          children: <Widget>[
                            Text("Already have an account?",
                                style: smallerText.copyWith(
                                    fontFamily: 'OpenSans', color: blueViolet)),
                            SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new Login()));
                              },
                              child: Text("Log In",
                                  style: smallerText.copyWith(
                                      fontFamily: 'OpenSans',
                                      color: blueViolet,
                                      fontWeight: FontWeight.w800,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 1)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Form(
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              // Container(
                              //   margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                              //   child: Padding(
                              //       padding: EdgeInsets.symmetric(vertical: 5),
                              //       child: TextFormField(
                              //         style: TextStyle(
                              //             color: blueDark, fontFamily: 'OpenSans'),
                              //         decoration: inputFormDecor.copyWith(
                              //             hintText: "First Name"),
                              //       )),
                              // ),
                              // Container(
                              //   margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                              //   child: Padding(
                              //       padding: EdgeInsets.symmetric(vertical: 5),
                              //       child: TextFormField(
                              //         style: TextStyle(
                              //             color: blueDark, fontFamily: 'OpenSans'),
                              //         decoration: inputFormDecor.copyWith(
                              //             hintText: "Last Name"),
                              //       )),
                              // ),
                              Container(
                                margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                                child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: TextFormField(
                                      style: TextStyle(
                                          color: blueDark,
                                          fontFamily: 'OpenSans'),
                                      decoration: inputFormDecor.copyWith(
                                          hintText: "Email"),
                                      onChanged: (val) {
                                        setState(() => email = val);
                                      },
                                      validator: (val) => val!.isEmpty
                                          ? "Please enter an email"
                                          : null,
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                                child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: TextFormField(
                                      obscureText: true,
                                      style: TextStyle(
                                          color: blueDark,
                                          fontFamily: 'OpenSans'),
                                      decoration: inputFormDecor.copyWith(
                                          hintText: "Password"),
                                      onChanged: (val) {
                                        setState(() => password = val);
                                      },
                                      validator: (val) => val!.length < 6
                                          ? "Password length must be 6 characters or more"
                                          : null,
                                    )),
                              ),
                              // Container(
                              //   margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                              //   child: Padding(
                              //       padding: EdgeInsets.symmetric(vertical: 5),
                              //       child: TextFormField(
                              //         obscureText: true,
                              //         style: TextStyle(
                              //             color: blueDark, fontFamily: 'OpenSans'),
                              //         decoration: inputFormDecor.copyWith(
                              //             hintText: "Confirmed Password"),
                              //       )),
                              // ),
                              Container(
                                  padding: EdgeInsets.all(30),
                                  child: Ink(
                                    // color: purpleDark,
                                    child: InkWell(
                                        onTap: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            setState(() => load = true);
                                            dynamic newUser = await authService
                                                .registerWithEmailAndPassword(
                                                    email, password);
                                            if (newUser == null) {
                                              setState(() =>
                                                  error = "There was an error");
                                              setState(() => load = false);
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          new WrapperHome()));
                                            }
                                          }
                                        },
                                        child: WideButton(
                                            buttonText: "Sign Up",
                                            colorSide: "Light")),
                                  )),
                              SizedBox(height: 8),
                              Text(error,
                                  style:
                                      smallerText.copyWith(color: Colors.red))
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.fromLTRB(32, 8, 0, 24),
                        child: Text("Or sign up with:",
                            style: smallerText.copyWith(
                                fontFamily: 'OpenSans', color: blueViolet)),
                      ),
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Ink(
                            child: InkWell(
                              onTap: () {},
                              child: SocmedButton(
                                  buttonText: "Gmail",
                                  iconSocmed: Image(
                                      height: 20,
                                      width: 20,
                                      image: AssetImage(
                                          'assets/google_icon.png'))),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Ink(
                            child: InkWell(
                              onTap: () {},
                              child: SocmedButton(
                                  buttonText: "Facebook",
                                  iconSocmed: Image(
                                      height: 20,
                                      width: 20,
                                      image: AssetImage(
                                          'assets/facebook_icon.png'))),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Ink(
                            child: InkWell(
                              onTap: () {},
                              child: SocmedButton(
                                  buttonText: "Twitter",
                                  iconSocmed: Image(
                                      height: 20,
                                      width: 20,
                                      image: AssetImage(
                                          'assets/twitter_icon.png'))),
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                )));
  }
}
