import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_rent/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/advert_model.dart';

final totalJobsProvider = FutureProvider.autoDispose
    .family<List<Advert_Model>, String>((ref, job) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  late final user;

  user = await ref.watch(userDetails(uid!));

  List<Advert_Model> totalAdverts = [];
  List<Map<dynamic, dynamic>> list;
  List<DocumentSnapshot> templist;

  CollectionReference reference =
      FirebaseFirestore.instance.collection("posts");

  QuerySnapshot querySnapshot = await reference.get();
  templist = querySnapshot.docs;
  list = templist.map((DocumentSnapshot docSnapshot) {
    return docSnapshot.data() as Map<dynamic, dynamic>;
  }).toList();
  for (var item in list) {
    if (user.identity == "Job Seeker") {
      if (item['identityId'] == '2') {
        print("jjjjjjjjjjjjjj {{$item}}");
        //final user = ref.read(userProvider).value;
        Advert_Model house = Advert_Model(
          job: item['job'],
          currency: item['currency'],
          duration: item['duration'],
          amount: item['amount'],
          upload_id: item['postId'],
        );
        totalAdverts.add(house);
      }
    } else {
      if (item['identityId'] == '1') {
        if (job.isEmpty) {
          Advert_Model house = Advert_Model(
            job: item['job'],
            currency: item['currency'],
            duration: item['duration'],
            amount: item['amount'],
            upload_id: item['postId'],
            user_id: item['userId'],
          );
          totalAdverts.add(house);
        }else if (item["job"] == job) {
            Advert_Model house = Advert_Model(
              job: item['job'],
              currency: item['currency'],
              duration: item['duration'],
              amount: item['amount'],
              upload_id: item['upload_id'],
              user_id: item['userId'],
            );
            totalAdverts.add(house);
          }
      }
    }
  }
  return totalAdverts;
});
