import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/user_model.dart';

final userProvider = FutureProvider.family<User_Model,String>((ref,uid) async {
  late User_Model user;
  List<DocumentSnapshot> templist;
  List<Map<dynamic, dynamic>> list;

  final userId = (uid != "" || !uid.isEmpty)?uid:FirebaseAuth.instance.currentUser?.uid;

  if(userId != null){
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
          imgUrl: item['imgUrl'],
          location: item['location'],
          details: item['details'],
        );
      }
      print("fffffffff");
    }
  }
  print("The final identity is : ${user.identity}");
  return user;
});

final userDetails = StateNotifierProvider.autoDispose.family<UserNotifier,User_Model,String>(
    (ref,uid){
      return UserNotifier(uid);
    },
);

class UserNotifier extends StateNotifier<User_Model>{
  String uid;
  UserNotifier(this.uid):super(User_Model(
    name:"",
    identity:"",
    phone:"",
    rating: "0",
    email: "",
    details: "",
    location: "",
    imgUrl: "",
  ),){
    getUserData();
    print("This is start of user notifier");
  }
  Future<User_Model> userData(String uid) async {
    //late User_Model user;
    List<DocumentSnapshot> templist;
    List<Map<dynamic, dynamic>> list;

    final userId = (uid != "" && !uid.isEmpty)?uid:FirebaseAuth.instance.currentUser?.uid;
    print("hello hello hellodbb hgfjdb ${FirebaseAuth.instance.currentUser?.uid}");

    if(userId != null){
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
          state = User_Model(
            name: item['name'],
            identity: item['identity'],
            phone: item['contact'],
            rating: item['rating'],
            email: item['email'],
            imgUrl: item['imgUrl'],
            location: item['location'],
            details: item['details'],
          );
        }
        print("fffffffff");
      }
    }
    // print("The final identity is : ${user.identity}");
    return state;
  }
  // final uid = FirebaseAuth.instance.currentUser!.uid;
  getUserData() async{
    await userData(uid);
  }

  logOut() async{
    await FirebaseAuth.instance.signOut();
    User_Model model = User_Model(
      name:"",
      identity:"",
      phone:"",
      rating: "0",
      email: "",
      details: "",
      location: "",
      imgUrl: "",
    );
    state = model;
  }

}