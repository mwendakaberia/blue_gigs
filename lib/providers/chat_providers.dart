import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_rent/models/message_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final totalChatRoomsProvider =
StreamProvider<List<Map<String, dynamic>>>((ref) async* {
  List<Chats_Model> chatRooms = [];
  List<Map<String, dynamic>> list;

  var snapshot = await
  FirebaseFirestore.instance.collection("Chats").get();
  var snapshot2 = snapshot.docs.map((DocumentSnapshot docSnapshot) {
    return docSnapshot.data() as Map<dynamic, dynamic>;
  }).toList();

  print("nnnnnnnnnnnnn ${snapshot2.length}");
  print("jjjjjjjjjjjj ${snapshot2}");

  // then((value) async {
  //   var value2 = await value.
  //   print("nnnnnnnnnnnnn ${value2.length}");
  //   print(
  //       "HAHAHAHAHAHAHAHAHAHA ${value2}");
  //           // reference
  //           // .collection("Messages")
  //           // .doc()
  //           // .id}");
  //
  //   // value.reference.collection("Messages")
  //   //     .get()
  //   //     .then((value) => print("ssssssssssssssssss ${value.docs
  //   //     .first
  //   //     .data()
  //   //     .isEmpty}"));
  //   //
  //   // print("HAHAHAHAHAHAHAHAHAHA3 ${value.reference.collection("Messages")
  //   //         .get()
  //   //         .then((value) =>
  //   //     value.docs
  //   //         .toList()
  //   //         .first
  //   //         .data()
  //   //         .isEmpty)}");
  //   //
  //   // value.reference.collection("Messages").get().then((value) {
  //   //   value.docs.forEach((element) {
  //   //     print("llllllllllllllll ${element.id}");
  //   //     print("llllllllllllllll ${element
  //   //         .data()
  //   //         .length}");
  //   //     print("llllllllllllllll ${element.data().cast()}");
  //   //   });
  //   // });
  //
  // });

  snapshot.docs.forEach((element) {
    print(
        "HAHAHAHAHAHAHAHAHAHA ${element.reference.id}");
    print(
        "HAHAHAHAHAHAHAHAHAHA2 ${element.id}");
    print(
        "HAHAHAHAHAHAHAHAHAHA3 ${element.data()}");
    print(
        "HAHAHAHAHAHAHAHAHAHA4 ${element.data()}");
  });

  var snapshot3 = FirebaseFirestore.instance
      .collection("Chats")
      .doc()
      .collection("Messages")
      .doc()
      .snapshots();
  snapshot3.forEach((element) {
    var data = Chats_Model.fromJson(element.data()!);
    print("datadatadadadadadada ${data}");
    chatRooms.add(data);
  });
  await chatRooms;
});

// @riverpod
// class AsyncChatRooms extends _$AsyncChatRooms{
//
// }

