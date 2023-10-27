import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_rent/models/advert_model.dart';
import 'package:easy_rent/models/user_model.dart';
import 'package:easy_rent/pages/dropDownInput.dart';
import 'package:easy_rent/pages/job_update.dart';
import 'package:easy_rent/pages/navigation_drawer.dart';
import 'package:easy_rent/providers/user_provider.dart';

//import 'package:easy_rent/providers/firebase_providers.dart';
import 'package:easy_rent/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../providers/control_providers.dart';
import '../providers/employer_provider.dart';
import '../providers/jobs_provider.dart';
import '../functions/reusble_fuctionality.dart';

class Employer extends StatefulWidget {
  String jobType;

  Employer({this.jobType = ""});

  @override
  State<Employer> createState() => _EmployerState();
}

class _EmployerState extends State<Employer> {
  var _rating;
  var _searchclicked = 0;

  @override
  Widget build(BuildContext context) {
    final widgets = Widgets();

    final _ratingdialog = RatingDialog(
        title: Text(
          "Rating Dialog",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        message: Text(
          "Tap a star to add a Rating",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 23),
        ),
        image: FlutterLogo(size: 100),
        submitButtonText: "Rate",
        commentHint: "Set your custom comment hint",
        onCancelled: () {},
        onSubmitted: (response) {
          print("Rating is : ${response.rating}");
          setState(() {
            _rating = response.rating.toString();
          });
        });

    Future<void> rate(String workerId, String rating) async {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      CollectionReference reference =
          FirebaseFirestore.instance.collection("users");

      CollectionReference reference2 = FirebaseFirestore.instance
          .collection("employer")
          .doc(userId)
          .collection("hired");

      QuerySnapshot result = await reference.get();
      final result2 = result.docs;
      final list = result2.map((DocumentSnapshot docSnapshot) {
        return docSnapshot.data() as Map<String, dynamic>;
      }).toList();
      for (var item in list) {
        if (item["userId"] == workerId) {
          item["rating"] = rating;
          print("hello there ${rating}");
        }
        await reference.doc(item["userId"]).update(item);
        print("hello there again  ${item}");
      }

      QuerySnapshot result3 = await reference2.get();
      var result4 = result3.docs;
      final list2 = result4.map((DocumentSnapshot docSnapshot) {
        return docSnapshot.data() as Map<String, dynamic>;
      }).toList();
      for (var item in list2) {
        if (item["workerId"] == workerId) {
          item["rated"] = true;
        }
        await reference2.doc(workerId).update(item);
      }
    }

    return Consumer(builder: (context, ref, child) {
      final profilestate = ref.watch(profile_provider).state;
      final listcards = ref.watch(totalJobsProvider(widget.jobType).future);
      return Scaffold(
        drawer: NavDrawer(2),
        appBar: AppBar(
          automaticallyImplyLeading: profilestate == 0 ? true : false,
          title: Text(
            profilestate == 1 ? "My Profile" : "Employer Page",
            textAlign: TextAlign.center,
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                profilestate == 0
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 20.0, bottom: 30.0, left: 25.0, right: 25.0),
                          padding: EdgeInsets.only(left: 25.0, right: 25.0),
                          //width: MediaQuery.of(context).size.width*.75,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: _searchclicked == 0
                              ? IconButton(
                                  onPressed: () async {
                                    setState(() {
                                      _searchclicked = 1;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.search,
                                    size: 50.0,
                                    color: Colors.white,
                                  ),
                                )
                              : SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: DropdownInput(
                                    hintText: "Job Type",
                                    options: [
                                      "",
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
                                    value: widget.jobType,
                                    onChanged: (String? value) {
                                      setState(() {
                                        widget.jobType = value!;
                                      });
                                    },
                                    getLabel: (String value) => value,
                                  ),
                                ),
                        ),
                      )
                    : Container(),
                FutureBuilder(
                  future: listcards,
                  builder:
                      (context, AsyncSnapshot<List<Advert_Model>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text("An error occured");
                      } else if (snapshot.hasData) {
                        final data = snapshot.data;
                        print("data twenty = ${data?.length}");
                        List<User_Model> userList = [];
                        for (var item in data!) {
                          final user = ref.watch(
                            userDetails(item.user_id),
                          );
                          userList.add(user);
                        }
                        return Container(
                          width: MediaQuery.of(context).size.width * .75,
                          margin: EdgeInsets.only(top: 20.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final user = userList[index];
                              print("hehehehehehehe ${data.length}");
                              return SizedBox(
                                width: MediaQuery.of(context).size.width * .3,
                                child: GestureDetector(
                                  child: widgets.card(data![index], user),
                                  onTap: () => profilestate == 0
                                      ? showDialog(
                                          context: context,
                                          builder: (context) =>
                                              widgets.postDialog(
                                            context,
                                            data[index],
                                            user,
                                          ),
                                        )
                                      : Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => UpdatePost(
                                              data[index].job,
                                              data[index].amount,
                                              data[index].currency,
                                              data[index].duration,
                                              data[index].upload_id,
                                            ),
                                          ),
                                        ),
                                ),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              //crossAxisSpacing: 2,
                            ),
                          ),
                        );
                      }
                    }
                    return Text("nothing to show");
                  },
                ),
                ElevatedButton(
                  child: Text("Rate"),
                  onPressed: () async {
                    final unrated = await ref.watch(employerRated);
                    return unrated.when(
                      data: (data) async {
                        print("Data : ${data.workerId}");
                        await showDialog(
                            context: context,
                            builder: (context) => _ratingdialog).then(
                          (value) => rate(data.workerId, _rating).then(
                            (value) async {
                              // userProvider
                              await ref.watch(userDetails(data.workerId));
                            },
                          ),
                        );
                      },
                      loading: () => Center(
                        child: CircularProgressIndicator(),
                      ),
                      error: (e, s) => Center(
                        child: Text("An Error Occured"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
