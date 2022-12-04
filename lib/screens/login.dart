import 'package:easy_rent/clippers/login_clipper.dart';
import 'package:easy_rent/providers/advert_provider.dart';
import 'package:easy_rent/providers/control_providers.dart';
import 'package:easy_rent/screens/register.dart';
import 'package:easy_rent/services/firebase_authetication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailctrl = TextEditingController();
  final passwordctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BlueGigs",
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          Consumer(builder: (context, ref, child) {
            final value = ref.read(theme).state;
            return Switch(
                value: value == ThemeMode.dark,
                onChanged: (newValue) {
                  newValue == false
                      ? ref.refresh(theme).state = ThemeMode.light
                      : ref.refresh(theme).state = ThemeMode.dark;
                });
          }),
        ],
      ),
      body: Column(
        children: [
          ClipPath(
            clipper: LoginShapeClipper(),
            child: Container(
              color: Colors.blueGrey,
              height: MediaQuery.of(context).size.height * .45,
            ),
          ),
          Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0, top: 0.0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailctrl,
                    decoration: InputDecoration(
                      labelText: "User Name/Email",
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                  child: TextField(
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    controller: passwordctrl,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35.0,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .35,
                    child: Consumer(
                      builder: (context, ref, child) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            padding: EdgeInsets.all(5.0),
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            signIn(
                              emailctrl.text.toString(),
                              passwordctrl.text.toString(),
                            ).then((value) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => Homepage(),
                                ),
                              );
                            }).onError((error, stackTrace) {}
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Text(
                                //       error.toString(),
                                //     ),
                                //   ),
                                //),
                                );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account yet?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: "SignUp",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 28.0,
                              fontWeight: FontWeight.w900),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => registerScreen()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
