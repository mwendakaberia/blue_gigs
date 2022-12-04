import 'package:easy_rent/pages/employer.dart';
import 'package:easy_rent/pages/job_seeker.dart';
import 'package:easy_rent/providers/advert_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/user_model.dart';

class Homepage extends ConsumerWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider.future);
    return FutureBuilder(
        future: user,
        builder: (context, AsyncSnapshot<User_Model> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("An error occured");
            } else if (snapshot.hasData) {
              final data = snapshot.data;
              print("data = ${data?.identity}");
              return data?.identity == "Job Seeker" ? JobSeeker() : Employer();
            }
          }
          return Text("nothing to show");
        });
  }
}
