import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_rent/providers/control_providers.dart';
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
    var profile = ref.watch(profile_provider).state;
    print("tttttttttttttt ${profile}");
    if (profile == 1) {
      print("inside profile controller");
      if (item['userId'] == uid) {
        print("inside profile controller two");
        Advert_Model advert = Advert_Model(
          job: item['job'],
          currency: item['currency'],
          duration: item['duration'],
          amount: item['amount'],
          upload_id: item['postId'],
          user_id: item['userId'],
        );
        totalAdverts.add(advert);
      }
    } else {
      if (user.identity == "Job Seeker") {
        if (item['identityId'] == '2') {
          print("jjjjjjjjjjjjjj {{$item}}");
          //final user = ref.read(userProvider).value;
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
          } else if (item["job"] == job) {
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
          } else if (item["job"] == job) {
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
  }
  return totalAdverts;
});

// class MyParameter extends Equatable  {
//   MyParameter({
//     required this.userId,
//     required this.locale,
//   });
//
//   final int userId;
//   final Locale locale;
//
//   @override
//   List<Object> get props => [userId, locale];
// }
