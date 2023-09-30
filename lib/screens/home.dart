import 'package:easy_rent/pages/employer.dart';
import 'package:easy_rent/pages/job_seeker.dart';
import 'package:easy_rent/screens/login.dart';
//import 'package:easy_rent/providers/firebase_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (context, ref, child) {
          final user = ref.watch(userDetails(""));
          return Scaffold(
            body: user.identity == "Job Seeker"?JobSeeker():user.identity == "Employer"?Employer():Center(child: CircularProgressIndicator()),
          );
        });
    // Widget screen = CircularProgressIndicator();
    //
    // return screen;
  }
}
