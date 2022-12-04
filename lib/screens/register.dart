import 'package:easy_rent/pages/dropDownInput.dart';
import 'package:easy_rent/pages/employer.dart';
import 'package:easy_rent/pages/job_seeker.dart';
import 'package:easy_rent/providers/advert_provider.dart';
import 'package:easy_rent/screens/home.dart';
import 'package:easy_rent/services/firebase_authetication.dart';
import 'package:flutter/material.dart';
import 'package:easy_rent/functions/register_validator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class registerScreen extends StatefulWidget {
  String identity;

  registerScreen({Key? key, this.identity = "Job Seeker"}) : super(key: key);

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  final _formKey = GlobalKey<FormState>();

  var namectrl = TextEditingController();

  var phonectrl = TextEditingController();

  var emailctrl = TextEditingController();

  var passwordctrl = TextEditingController();

  var password2ctrl = TextEditingController();

  var user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration Screen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Username",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            4.0,
                          ),
                        ),
                      ),
                    ),
                    controller: namectrl,
                    validator: (value) {
                      return validation.userNameValidation(
                          value, "Username Can't be Empty");
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail),
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            4.0,
                          ),
                        ),
                      ),
                    ),
                    controller: emailctrl,
                    validator: (value) {
                      return validation.emailValidation(value);
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      hintText: "Telephone",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            4.0,
                          ),
                        ),
                      ),
                    ),
                    controller: phonectrl,
                    validator: (value) {
                      return validation.userPhoneValidation(
                          value, "Telephone Can't be Empty");
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  DropdownInput(
                    hintText: "Identity",
                    options: ["Employer", "Job Seeker"],
                    value: widget.identity,
                    onChanged: (String? value) {
                      setState(() {
                        widget.identity = value!;
                      });
                    },
                    getLabel: (String value) => value,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            4.0,
                          ),
                        ),
                      ),
                    ),
                    controller: passwordctrl,
                    validator: (value) {
                      return validation.passwordValidation(value);
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: "Confirm Password",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            4.0,
                          ),
                        ),
                      ),
                    ),
                    controller: password2ctrl,
                    validator: (value) {
                      return validation.confirmPassword(
                        value,
                        passwordctrl.text.toString(),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade100,
                          Colors.blue.shade200,
                          Colors.blue.shade300
                        ],
                      ),
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer(
                        builder: (context, ref, child) {
                          return ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                registerUser(
                                  emailctrl.text.toString(),
                                  passwordctrl.text.toString(),
                                  namectrl.text.toString(),
                                  widget.identity,
                                  phonectrl.text.toString(),
                                ).then(
                                  (value) {
                                    print("Stating");
                                    //user = await ref.watch(identityProvider).state,
                                    //final user = ref.watch(userProvider);
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => Homepage(),
                                      ),
                                    );
                                  },
                                ).onError(
                                  (error, stackTrace) {},
                                );
                              }
                              ;
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              elevation: 7.0,
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 30.0,
                                color: Colors.amber,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
