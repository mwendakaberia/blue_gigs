import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_rent/pages/dropDownInput.dart';
import 'package:easy_rent/pages/job_seeker.dart';
import 'package:easy_rent/providers/advert_provider.dart';
import 'package:easy_rent/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UpdatePost extends StatefulWidget {
  final job, amount, currency, duration, upload_id;

  const UpdatePost(
      this.job, this.amount, this.currency, this.duration, this.upload_id,
      {Key? key})
      : super(key: key);

  @override
  _UpdatePostState createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  String job2='';
  String currency2='';
  String duration2='';

  final amountCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> updatePost() async {

    CollectionReference reference = FirebaseFirestore.instance
        .collection("posts");
    FirebaseAuth auth = FirebaseAuth.instance;
    var uid = auth.currentUser!.uid;

    QuerySnapshot result = await reference.get();
    final result2 = result.docs;
    final list = result2.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data() as Map<String, dynamic>;
    }).toList();
    for (var item in list) {
      if (item["postId"] == widget.upload_id && item["userId"] == uid) {
        item["job"] =
            !job2.isEmpty ? job2 : widget.job;
        item["currency"] = !currency2.isEmpty
            ? currency2
            : widget.currency;
        item["duration"] = !duration2.isEmpty
            ? duration2
            : widget.duration;
        item["amount"] =
            amountCtrl.text.length == 0 ? widget.amount : amountCtrl.text.toString();


        await reference
            .doc(item["postId"])
            .update(item);
      }
    }
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
                        job2 = value!;
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
                        currency2 = value!;
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
                      hintText: widget.amount,
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
                        duration2 = value!;
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
                              updatePost().then((value) async=> {
                                await ref.refresh(advertProvider),
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobSeeker(),),),
                              }).onError((error, stackTrace) => {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      error.toString(),
                                    ),
                                  ),
                                ),
                              });
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
