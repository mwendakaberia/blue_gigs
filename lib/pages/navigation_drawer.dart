import 'package:easy_rent/pages/employer.dart';
import 'package:easy_rent/pages/job_seeker.dart';
import 'package:easy_rent/pages/job_upload.dart';
import 'package:easy_rent/pages/settings.dart';
import 'package:easy_rent/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/user_provider.dart';
import '../services/firebase_authetication.dart';

class NavDrawer extends StatelessWidget {
  int role;

  NavDrawer(this.role);
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final user = ref.watch(userDetails(""));
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Side menu',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              // decoration: BoxDecoration(
              //     color: Colors.green,
              //     image: DecorationImage(
              //         fit: BoxFit.fill,
              //         image: AssetImage('assets/images/cover.jpg'))),
            ),
            ListTile(
              leading: Icon(Icons.house),
              title: Text(this.role == 1 ? 'Add Speciality' : 'Create Gig'),
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => UploadJob(this.role),
                  ),
                ),
              },
            ),
            ListTile(
              leading: Icon(Icons.verified_user),
              title: Text('Profile'),
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => this.role == 1 ? JobSeeker() : Employer(),
                  ),
                ),
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Settings(
                      url: user.imgUrl,
                      location: user.location,
                      details: user.details,
                      name: user.name,
                      phone: user.phone,
                    ),
                  ),
                ),
              },
            ),
            Consumer(builder: (context, ref, child) {
              return ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  print("third ${auth.currentUser!.uid}");
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
              );
            }),
          ],
        ),
      );
    });
  }
}
