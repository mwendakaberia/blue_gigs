import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_rent/functions/reusble_fuctionality.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../models/message_model.dart';

class ChatFunctions {
  getChatIdByUserIds(String sender, String receiver) {
    if (sender.substring(0, 1).codeUnitAt(0) >
        receiver.substring(0, 1).codeUnitAt(0)) {
      return "${sender}_${receiver}";
    } else {
      return "${receiver}_${sender}";
    }
  }

  Future addMessage(BuildContext context, Chats_Model chat) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;

    final widgets = Widgets();

    String sender = auth.currentUser!.uid;
    String messageId = DateTime.now().millisecondsSinceEpoch.toString();
    var timeSent = DateTime.now();
    var chatId = getChatIdByUserIds(sender, chat.receiverId);
    var attachmentUrl;

    if (chat.hasAttachment == true) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("Chats")
          .child(chatId)
          .child(messageId);

      await ref.putFile(chat.attachmentUrl);
      attachmentUrl = await ref.getDownloadURL();
    }

    await firebaseFirestore
        .collection("Chats")
        .doc(chatId)
        .collection("Messages")
        .doc(messageId)
        .set(
      {
        "chatId": chatId,
        "messageId": messageId,
        "senderId": sender,
        "receiverId": chat.receiverId,
        "timeSent": timeSent,
        "message": chat.message,
        "hasAttachment": chat.hasAttachment,
        if (attachmentUrl != null) "attachementUrl": attachmentUrl,
      },
    ).then(
      (value) => widgets.showSnackBar(
        context,
        "Done",
        Duration(seconds: 1),
      ),
    );
  }
}
