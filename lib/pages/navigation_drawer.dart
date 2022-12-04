import 'package:easy_rent/pages/job_seeker.dart';
import 'package:easy_rent/pages/job_upload.dart';
import 'package:easy_rent/providers/advert_provider.dart';
import 'package:easy_rent/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/firebase_authetication.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            title: Text('Add Speciality'),
            onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UploadJob(),
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
                  builder: (context) => JobSeeker(),
                ),
              ),
            },
          ),
        ],
      ),
    );
  }
}
