import 'package:easy_rent/functions/reusble_fuctionality.dart';
import 'package:easy_rent/models/advert_model.dart';
import 'package:easy_rent/models/user_model.dart';
import 'package:easy_rent/pages/dropDownInput.dart';
import 'package:easy_rent/pages/job_update.dart';
import 'package:easy_rent/pages/job_upload.dart';
import 'package:easy_rent/pages/navigation_drawer.dart';
import 'package:easy_rent/providers/control_providers.dart';

//import 'package:easy_rent/providers/firebase_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/jobs_provider.dart';
import '../providers/user_provider.dart';

class JobSeeker extends StatefulWidget {
  String jobType;

  JobSeeker({this.jobType = "", Key? key}) : super(key: key);

  @override
  State<JobSeeker> createState() => _JobSeekerState();
}

class _JobSeekerState extends State<JobSeeker> {
  final widgets = Widgets();
  var _searchclicked = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final profilestate = ref.watch(profile_provider).state;
      final advertAsync = ref.watch(totalJobsProvider(widget.jobType));

      return Scaffold(
        drawer: NavDrawer(1),
        appBar: AppBar(
          automaticallyImplyLeading: profilestate == 0 ? true : false,
          title: Text(
            profilestate == 1 ? "My Profile" : "Job Seeker",
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
                advertAsync.when(
                  data: (adverts) {
                    print(adverts.length);
                    List<User_Model> userList = [];

                    for (var item in adverts) {
                      final user = ref.watch(
                        userDetails(item.user_id),
                      );
                      userList.add(user);
                      print("hahahahahahaha");
                    }

                    return Container(
                      width: MediaQuery.of(context).size.width * .75,
                      margin: EdgeInsets.only(top: 20.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: adverts.length,
                        itemBuilder: (context, index) {
                          print("okayokayokay");
                          final user = userList[index];
                          print("hehehehehehehe ${adverts.length}");
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * .3,
                            child: GestureDetector(
                              child: widgets.card(adverts[index], user),
                              onTap: () => profilestate == 0
                                  ? showDialog(
                                      context: context,
                                      builder: (context) => widgets.postDialog(
                                        context,
                                        adverts[index],
                                        user,
                                      ),
                                    )
                                  : Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UpdatePost(
                                          adverts[index].job,
                                          adverts[index].amount,
                                          adverts[index].currency,
                                          adverts[index].duration,
                                          adverts[index].upload_id,
                                        ),
                                      ),
                                    ),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          //crossAxisSpacing: 2,
                        ),
                      ),
                    );
                  },
                  loading: () => Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, s) => Center(
                    child: Text("An Error Occured"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
