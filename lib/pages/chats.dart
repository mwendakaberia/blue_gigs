import 'dart:io';

import 'package:easy_rent/functions/chat_functions.dart';
import 'package:easy_rent/models/message_model.dart';
import 'package:easy_rent/providers/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../functions/reusble_fuctionality.dart';

class Chats extends StatefulWidget {
  final receiver;

  Chats(this.receiver, {Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final msgctrl = TextEditingController();
  File? _image = null;
  bool hasAttachment = false;
  bool submit = false;
  final widgets = Widgets();
  final chatFuctions = ChatFunctions();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    msgctrl.addListener(() {
      setState(() {
        submit = msgctrl.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("The first image is ${_image}");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chats",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _image == null
              ? Consumer(builder: (context, ref, child) {
                AsyncValue<List<Map<String, dynamic>>> chats = ref.watch(totalChatRoomsProvider);
                chats.whenData((value) => print("popipopipopipopipopi ${value}"));
                return SingleChildScrollView();
              })
              : Expanded(
                  child: Image.file(_image!),
                ),
          Container(
            // margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 10.0,
                      ),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: null,
                        // expands: true,
                        controller: msgctrl,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "Type message",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 5.0,
                      bottom: 5.0,
                      top: 5.0,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.attach_file,
                        size: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 5.0,
                      bottom: 5.0,
                      top: 5.0,
                    ),
                    child: IconButton(
                      onPressed: () async {
                        _image = await widgets.imagePickerMethod(context);
                        if (_image != null) {
                          hasAttachment = true;
                        }
                        print("The third image is ${_image}");
                        setState(() {
                          print("The forth image is ${_image}");
                        });
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        size: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 5.0,
                      bottom: 5.0,
                      top: 5.0,
                    ),
                    child: IconButton(
                      color: Colors.white,
                      disabledColor: Colors.grey,
                      onPressed: submit || hasAttachment
                          ? () {
                              chatFuctions.addMessage(
                                context,
                                Chats_Model(
                                  message: msgctrl.text.toString(),
                                  receiverId: widget.receiver,
                                  hasAttachment: hasAttachment,
                                  attachmentUrl: _image,
                                ),
                              );
                            }
                          : null,
                      icon: Icon(
                        Icons.send_outlined,
                        size: 30.0,
                        //color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
