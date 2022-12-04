import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_rent/pages/dropDownInput.dart';
import 'package:easy_rent/pages/job_seeker.dart';
import 'package:easy_rent/providers/advert_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UploadJob extends StatefulWidget {
  String job, currency, duration;

  UploadJob(
      {Key? key,
      this.job = "Plumber",
      this.currency = "KSh",
      this.duration = "Per work"})
      : super(key: key);

  @override
  _UploadJobState createState() => _UploadJobState();
}

class _UploadJobState extends State<UploadJob> {
  final amountCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future savePost() async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    String userId = auth.currentUser!.uid;

    //uploading to cloudfirestore
    await firebaseFirestore
        .collection("posts")
        .doc(postID)
        .set({
      "postId": postID,
      "job": widget.job,
      "currency": widget.currency,
      "amount": amountCtrl.text.toString(),
      "duration": widget.duration,
      "userId": userId,
    }).then((value) =>
        showSnackBar("Image uploaded successful", Duration(seconds: 2)));
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Speciality"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Please select the type of work you provider"),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownInput(
                    hintText: "Job Type",
                    options: [
                      "Plumber",
                      "Electrical Device Technician",
                      "Wifi Technician",
                      "Sewer Line Service",
                      "Gas Leak Technician",
                      "Carpet Cleaner",
                      "Gardener",
                      "Car Wash Operator",
                      "House Help"
                    ],
                    value: widget.job,
                    onChanged: (String? value) {
                      setState(() {
                        widget.job = value!;
                      });
                    },
                    getLabel: (String value) => value,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Please provide your charge rate"),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownInput(
                    hintText: "Currency",
                    options: [
                      "KSh",
                      "Dollar",
                    ],
                    value: widget.currency,
                    onChanged: (String? value) {
                      setState(() {
                        widget.currency = value!;
                      });
                    },
                    getLabel: (String value) => value,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, bottom: 10.0, top: 0.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: amountCtrl,
                    decoration: InputDecoration(
                      labelText: "Amount",
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
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownInput(
                    hintText: "Duration",
                    options: [
                      "Per day",
                      "Per hour",
                      "Per month",
                      "Per work",
                    ],
                    value: widget.duration,
                    onChanged: (String? value) {
                      setState(() {
                        widget.duration = value!;
                      });
                    },
                    getLabel: (String value) => value,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .35,
                    child: Consumer(
                      builder: (context,ref,child){
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
                            savePost()
                                .then(
                                  (value) async => {
                                    await ref.refresh(advertProvider),
                                    Navigator.of(context).pushReplacement(
                                  MaterialPageRoute
                                  (
                                  builder: (context) => JobSeeker(),
                                ),
                              ),},
                            )
                                .onError(
                                  (error, stackTrace) =>{}
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //     content: Text(
                                  //       error.toString(),
                                  //     ),
                                  //   ),
                                  // ),
                            );
                          },
                        );
                      },
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
