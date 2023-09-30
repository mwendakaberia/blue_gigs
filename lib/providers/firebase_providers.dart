import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_rent/models/employer.dart';
import 'package:easy_rent/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_rent/models/advert_model.dart';

final userJobsProvider = FutureProvider<List<Advert_Model>>((ref) async {
  List<Advert_Model> adverts = [];
  List<DocumentSnapshot> templist;
  List<Map<dynamic, dynamic>> list;

  final userId = FirebaseAuth.instance.currentUser?.uid;

  print("ttttttttttt");

  CollectionReference reference =
      FirebaseFirestore.instance.collection("posts");

  QuerySnapshot querySnapshot = await reference.get();
  templist = querySnapshot.docs;
  list = templist.map((DocumentSnapshot docSnapshot) {
    return docSnapshot.data() as Map<dynamic, dynamic>;
  }).toList();

  print('uuduuuuuuuuuu {{$list}}');

  for (var item in list) {
    print("hhhhhhhhhhhhh {{$item}}");
    if (item["userId"] == userId) {
      print("jjjjjjjjjjjjjj {{$item}}");
      //final user = ref.read(userProvider).value;
      Advert_Model house = Advert_Model(
        job: item['job'],
        currency: item['currency'],
        duration: item['duration'],
        amount: item['amount'],
        upload_id: item['postId'],
      );
      adverts.add(house);
    }
    print("fffffffff");
  }
  return adverts;
});

final totalJobsProvider =
    FutureProvider.family<List<Advert_Model>, String>((ref, job) async {
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
    } else {
      if (item["job"] == job) {
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
  return totalAdverts;
});

final userProvider = FutureProvider<User_Model>((ref) async {
  late User_Model user;
  List<DocumentSnapshot> templist;
  List<Map<dynamic, dynamic>> list;

  final userId = FirebaseAuth.instance.currentUser?.uid;

  if(userId==null){
    user=User_Model(
    );
  }else{
    print("wwwwwwwwww");

    CollectionReference reference =
    FirebaseFirestore.instance.collection("users");

    QuerySnapshot querySnapshot = await reference.get();
    templist = querySnapshot.docs;
    list = templist.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data() as Map<dynamic, dynamic>;
    }).toList();

    print('zzzzzzzzzzzz {{$list}}');

    for (var item in list) {
      print("ppppppppppp {{$item}}");
      if (item["userId"] == userId) {
        print("yyyyyyyyyyyy {{$item}}");
        user = User_Model(
          name: item['name'],
          identity: item['identity'],
          phone: item['contact'],
          rating: item['rating'],
          email: item['email'],
        );
      }
      print("fffffffff");
    }
  }
  print("The final identity is : ${user.identity}");
  return user;
});

final hireProvider = FutureProvider.family<User_Model, String>(
  (ref, workerId) async {
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

    late User_Model user;
    List<DocumentSnapshot> templist;
    List<Map<dynamic, dynamic>> list;

    //final userId = FirebaseAuth.instance.currentUser?.uid;

    print("ttttttttttt");

    CollectionReference reference =
        FirebaseFirestore.instance.collection("users");

    QuerySnapshot querySnapshot = await reference.get();
    templist = querySnapshot.docs;
    list = templist.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data() as Map<dynamic, dynamic>;
    }).toList();

    print('uuduuuuuuuuuu {{$list}}');

    for (var item in list) {
      print("hhhhhhhhhhhhh {{$item}}");
      if (item["userId"] == workerId) {
        print("jjjjjjjjjjjjjj {{$item}}");
        user = User_Model(
          name: item['name'],
          identity: item['identity'],
          phone: item['contact'],
          rating: item['rating'],
          email: item['email'],
        );
        //users.add(user);
      }
    }
    return user;
  },
);

final employerRated = FutureProvider<Employer>((ref) async {
  List<Employer> unratedWorkers = [];
  List<Map<dynamic, dynamic>> list;
  List<DocumentSnapshot> templist;

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
  var worker =
      unratedWorkers.elementAt(Random().nextInt(unratedWorkers.length));
  return worker;
});

final postUserController =
    FutureProvider.family<User_Model, String>((ref, userId) async {
  var user;
  List<DocumentSnapshot> templist;
  List<Map<dynamic, dynamic>> list;

  CollectionReference reference =
      FirebaseFirestore.instance.collection("users");

  QuerySnapshot querySnapshot = await reference.get();
  templist = querySnapshot.docs;
  list = templist.map((DocumentSnapshot docSnapshot) {
    return docSnapshot.data() as Map<dynamic, dynamic>;
  }).toList();

  print('uuduuuuuuuuuu {{$list}}');

  for (var item in list) {
    print("hhhhhhhhhhhhh {{$item}}");
    if (item["userId"] == userId) {
      print("jjjjjjjjjjjjjj {{$item}}");
      user = User_Model(
        name: item['name'],
        identity: item['identity'],
        phone: item['contact'],
        rating: item['rating'],
        email: item['email'],
      );
      //users.add(user);
    }
  }
  return user;
});
