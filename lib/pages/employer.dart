import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_rent/models/advert_model.dart';
import 'package:easy_rent/models/user_model.dart';
import 'package:easy_rent/pages/dropDownInput.dart';
import 'package:easy_rent/providers/advert_provider.dart';
import 'package:easy_rent/services/firebase_authetication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rating_dialog/rating_dialog.dart';

class Employer extends StatefulWidget {
  String jobType;

  Employer({this.jobType = ""});

  @override
  State<Employer> createState() => _EmployerState();
}

class _EmployerState extends State<Employer> {
  var _rating;

  @override
  Widget build(BuildContext context) {
    //final listcards = ref.watch(tenantAdvertsList("").future);

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

    Widget card(Advert_Model post) {
      return Container(
        width: MediaQuery.of(context).size.width * .75,
        child: Card(
          elevation: 5.0,
          shape: Border.all(color: Colors.cyan),
          child: Column(
            children: [
              Text(
                post.job,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Times New Roman",
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              // SizedBox(
              //   child: Image.network(
              //     house.downloadUrl,
              //     // width: 250.0,
              //     // height: 250.0,
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                    "Charge : ${post.currency} ${post.amount} ${post.duration}"),
              ),
            ],
          ),
        ),
      );
    }

    Widget contactDialogu(User_Model user) {
      return Center(
        child: AlertDialog(
          title: Text("Personal Contacts"),
          actions: [
            TextButton(
              child: Text("Exit"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
          content: Container(
            width: MediaQuery.of(context).size.width * .75,
            height: MediaQuery.of(context).size.width * .5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                ),
                Icon(
                  Icons.person_outline,
                  size: 100,
                  color: Colors.blue,
                ),
                Text(
                  'User Profile',
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Card(
                    elevation: 6,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('User Name : '),
                              Text('${user.name}')
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Email Address : '),
                              Text('${user.email}')
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Phone Number : '),
                              Text('${user.phone}')
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget postDialog(Advert_Model post,User_Model user) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: AlertDialog(
            title: Text("Post Title"),
            actions: [
              TextButton(
                child: Text("Exit"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Consumer(
                builder: (context, ref, child) {
                  return TextButton(
                      child: Text("Hire"),
                      onPressed: () {
                        //showDialog(context: context, builder: (context)=>postDialog(post));
                        final hire =
                            ref.watch(hireProvider(post.user_id));
                        return hire.when(
                          data: (value) => {
                          Navigator.of(context).pop(),
                            print("value ${value.email}"),
                            showDialog(
                                context: context,
                                builder: (context) => contactDialogu(value))
                          },
                          loading: () => Center(
                            child: CircularProgressIndicator(),
                          ),
                          error: (e, s) => Center(
                            child: Text("An Error Occured"),
                          ),
                        );
                      });
                },
              ),
            ],
            actionsAlignment: MainAxisAlignment.spaceBetween,
            content: Container(
              width: MediaQuery.of(context).size.width * .75,
              height: MediaQuery.of(context).size.width * .5,
              child: Card(
                elevation: 5.0,
                shape: Border.all(color: Colors.cyan),
                child: Column(
                  children: [
                    Text(
                      post.job,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    // SizedBox(
                    //   child: Image.network(
                    //     house.downloadUrl,
                    //     // width: 250.0,
                    //     // height: 250.0,
                    //   ),
                    // ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                          "Charge : ${post.currency} ${post.amount} ${post.duration}"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                          "Rating : ${user.rating}"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Employer Page",
              textAlign: TextAlign.center,
            ),
            TextButton(
              child: Text(
                "Sign Out",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              onPressed: () => signOut(),
            ),
          ],
        ),
      ),
      body: Column(
        //mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(
                top: 20.0, bottom: 30.0, left: 25.0, right: 25.0),
            padding: EdgeInsets.only(left: 25.0, right: 25.0),
            //width: MediaQuery.of(context).size.width*.75,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
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
                IconButton(
                  onPressed: () async {
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.search,
                    size: 50.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Consumer(builder: (context, ref, child) {
            final listcards =
                ref.watch(tenantAdvertsList(widget.jobType).future);
            return FutureBuilder(
              future: listcards,
              builder: (context, AsyncSnapshot<List<Advert_Model>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text("An error occured");
                  } else if (snapshot.hasData) {
                    final data = snapshot.data;
                    print("data = ${data?.length}");
                    return Container(
                      width: MediaQuery.of(context).size.width * .75,
                      margin: EdgeInsets.only(top: 20.0),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: data?.length,
                        itemBuilder: (context, index) {
                          final user = ref.watch(
                            postUserController(data![index].user_id),
                          );
                          return user.when(
                            data: (userdata) {
                              return Row(
                                children: [
                                  GestureDetector(
                                    child: card(data![index]),
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (context) => postDialog(
                                        data[index],userdata,
                                      ),
                                    ),
                                  ),
                                ],
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
                    );
                  }
                }
                return Text("nothing to show");
              },
            );
          }),
          Consumer(builder: (context, ref, child) {
            return RaisedButton(
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
                          await ref.refresh(postUserController(data.workerId));
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
            );
          }),
        ],
      ),
    );
  }
}
