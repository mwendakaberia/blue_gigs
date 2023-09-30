import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_rent/models/advert_model.dart';
import 'package:easy_rent/models/user_model.dart';
import 'package:easy_rent/pages/dropDownInput.dart';
import 'package:easy_rent/pages/navigation_drawer.dart';
import 'package:easy_rent/providers/user_provider.dart';

//import 'package:easy_rent/providers/firebase_providers.dart';
import 'package:easy_rent/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rating_dialog/rating_dialog.dart';

import '../providers/employer_provider.dart';
import '../providers/jobs_provider.dart';

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
    //final listcards = ref.watch(totalJobsProvider("").future);

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

    Widget card(Advert_Model post, User_Model user) {
      return Container(
        //width: MediaQuery.of(context).size.width * .75,
        child: Card(
          margin: EdgeInsets.all(2.0),
          elevation: 5.0,
          shape: Border.all(color: Colors.cyan),
          child: Column(
            children: [
              Text(
                post.job,
                softWrap: true,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: "Times New Roman",
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                child: user.imgUrl != null &&
                        !user.imgUrl.toString().isEmpty &&
                        user.imgUrl.toString().length != 0
                    ? Image.network(
                        user.imgUrl,
                        width: 150.0,
                        height: 150.0,
                      )
                    : Icon(
                        Icons.person_outline,
                        size: 100,
                        color: Colors.blue,
                      ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Charge : ${post.currency} ${post.amount} ${post.duration}",
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget contactDialogu(User_Model user) {
      return FractionallySizedBox(
        heightFactor: 0.5,
        widthFactor: 0.75,
        alignment: FractionalOffset.center,
        child: IntrinsicHeight(
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
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0,
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Location : '),
                              Text('${user.location}')
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('About the Client : '),
                              Text('${user.details}')
                            ],
                          ),
                        ),
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

    Widget postDialog(Advert_Model post, User_Model user) {
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
                        print("oyahoyahoyahoyah");
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (context) => contactDialogu(user));
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
                      child: Text("Rating : ${user.rating}"),
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
      drawer : NavDrawer(2),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Employer Page",
              textAlign: TextAlign.center,
            ),
            Consumer(
              builder: (context, ref, child) {
                return TextButton(
                  onPressed: () {
                    ref.watch(userDetails("").notifier).logOut().then(
                          (value) async => {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            ),
                          },
                        );
                  },
                  child: Text(
                    "Log Out",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                  ref.watch(totalJobsProvider(widget.jobType).future);
              print("Hello There");
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
                                child: card(data![index], user),
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => postDialog(
                                    data[index],
                                    user,
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
              );
            }),
            Consumer(builder: (context, ref, child) {
              return ElevatedButton(
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
                            await ref.watch(userProvider(data.workerId));
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
      ),
    );
  }
}
