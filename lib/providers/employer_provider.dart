import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_rent/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/employer.dart';
import '../models/user_model.dart';

final hireProvider = FutureProvider.autoDispose.family<User_Model, String>(
  (ref, workerId) async {
    late final user;
    var uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference employer = FirebaseFirestore.instance
        .collection("employer")
        .doc(uid)
        .collection("hired");
    print("hello");

    await employer.doc(workerId).set({
      "userId": uid,
      "workerId": workerId,
      "rated": false,
    });
    print("hello again");

    user = await ref.watch(userDetails(workerId));
    return user;
  },
);

final employerRated = FutureProvider<Employer>((ref) async {
  List<Employer> unratedWorkers = [];
  List<Map<dynamic, dynamic>> list;
  List<DocumentSnapshot> templist;
  late final worker;

  final userId = FirebaseAuth.instance.currentUser?.uid;

  CollectionReference reference = FirebaseFirestore.instance
      .collection("employer")
      .doc(userId)
      .collection("hired");

  QuerySnapshot querySnapshot = await reference.get();
  templist = querySnapshot.docs;
  list = templist.map((DocumentSnapshot docSnapshot) {
    return docSnapshot.data() as Map<dynamic, dynamic>;
  }).toList();
  for (var item in list) {
    if (item["userId"] == userId && item["rated"] == false) {
      Employer rate = Employer(
          userId: item['userId'],
          workerId: item['workerId'],
          rated: item['rated']);
      unratedWorkers.add(rate);
    }
  }
  worker =
      await unratedWorkers.elementAt(Random().nextInt(unratedWorkers.length));
  return worker;
});
