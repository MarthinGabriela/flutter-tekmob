import 'package:flutter/material.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:tekmob/screens/wrapper_home.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/button_login_logout.dart';
import 'package:tekmob/elements/button_socmed.dart';
import 'package:tekmob/screens/splash.dart';
import 'package:tekmob/screens/sign/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
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
                  child: Text("Login",
                      style: header_3.copyWith(
                          color: purpleDark, fontFamily: 'QuickSand')),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Text("New to this App?",
                          style: smallerText.copyWith(
                              fontFamily: 'OpenSans', color: blueViolet)),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new SignUp()));
                        },
                        child: Text("Sign Up",
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                          child: Text("Email",
                              style: header_4.copyWith(
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
                                  setState(() => email = val);
                                },
                                validator: (val) => val!.isEmpty
                                    ? "Please enter an email"
                                    : null,
                              )),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                          child: Text("Password",
                              style: header_4.copyWith(
                                  color: blueDark, fontFamily: 'OpenSans')),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: TextFormField(
                                style: TextStyle(
                                    color: blueDark, fontFamily: 'OpenSans'),
                                obscureText: true,
                                decoration: inputFormDecor,
                                onChanged: (val) {
                                  setState(() => password = val);
                                },
                                validator: (val) => val!.length < 6
                                    ? "Password length must be 6 characters or more"
                                    : null,
                              )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                            padding: EdgeInsets.all(30),
                            child: Ink(
                              // color: purpleDark,
                              child: InkWell(
                                  onTap: () async {
                                    if (formKey.currentState!.validate()) {
                                      dynamic loginUser = await authService
                                          .signInWithEmailAndPassword(
                                              email, password);
                                      if (loginUser == null) {
                                        setState(() =>
                                            error = "Wrong Email or Password");
                                      } else {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new WrapperHome()));
                                      }
                                    }
                                  },
                                  child: WideButton(buttonText: "Log In")),
                            )),
                        Center(
                          child: Text(error,
                              style: smallerText.copyWith(color: Colors.red)),
                        )
                      ],
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(32, 8, 0, 24),
                  child: Text("Or login with:",
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
                                image: AssetImage('assets/google_icon.png'))),
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
                                image: AssetImage('assets/facebook_icon.png'))),
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
                                image: AssetImage('assets/twitter_icon.png'))),
                      ),
                    )
                  ],
                ))
              ],
            ))));
  }
}
