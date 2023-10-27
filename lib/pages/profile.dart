import 'package:easy_rent/pages/employer.dart';
import 'package:easy_rent/pages/job_seeker.dart';
import 'package:easy_rent/providers/control_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Profile extends StatefulWidget {
  int role;

  Profile(this.role, {Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return WillPopScope(
          onWillPop: () async {
            ref.watch(profile_provider).state = 0;
            return true;
          },
          child: Scaffold(
            body: widget.role == 1 ? JobSeeker() : Employer(),
          ),
        );
      });
  }
}

