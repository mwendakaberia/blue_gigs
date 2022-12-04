import 'package:easy_rent/pages/job_update.dart';
import 'package:easy_rent/pages/job_upload.dart';
import 'package:easy_rent/pages/navigation_drawer.dart';
import 'package:easy_rent/providers/advert_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class JobSeeker extends StatelessWidget {
  const JobSeeker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(
          "Job Seeker",
          textAlign: TextAlign.center,
        ),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final advertAsync = ref.watch(advertProvider);
          print("heyyyyyyyyyyy");
          return advertAsync.when(
            data: (adverts) {
              print(adverts.length);
              return ListView.builder(
                  itemCount: adverts.length,
                  itemBuilder: (context, index) {
                    final post = adverts[index];
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 25.0,left: 20.0,right: 20.0),
                          decoration: BoxDecoration(color: Colors.blueGrey,),
                          child: ListTile(
                            // leading: Image.network(
                            //   house.downloadUrl,
                            //   width: 100.0,
                            //   height: 100.0,
                            // ),
                            title: Text(
                              post.job,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w900,
                                fontFamily: "Times New Roman",
                              ),
                            ),
                            subtitle: Text(
                              "At ${post.currency} ${post.amount}",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Times New Roman",
                              ),
                            ),
                            trailing: Text(
                              "${post.duration}",
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Times New Roman",
                                color: Colors.white
                              ),
                            ),
                            onTap: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UpdatePost(
                                      post.job,
                                      post.amount,
                                      post.currency,
                                      post.duration,
                                      post.upload_id,),
                                ),
                              ),
                            },
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                      ],
                    );
                  });
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
