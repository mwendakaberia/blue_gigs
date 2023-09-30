import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_rent/functions/register_validator.dart';
import 'package:easy_rent/providers/control_providers.dart';
import 'package:easy_rent/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Settings extends StatefulWidget {
  var url, location, details, name, phone;

  Settings({
    Key? key,
    this.url,
    this.location,
    this.details,
    this.name,
    this.phone,
  }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController namectrl = new TextEditingController();
  TextEditingController detailsctrl = new TextEditingController();
  TextEditingController locationctrl = new TextEditingController();
  TextEditingController phonectrl = new TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;
  User? user;

  Future<void> getUserId() async {
    final user1 = (await auth.currentUser);
    setState(() {
      user = user1;
    });
  }

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("No file selected", Duration(seconds: 5));
      }
    });
  }

  Future cameraPickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("No file selected", Duration(seconds: 5));
      }
    });
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future uploadImage() async {
    await getUserId();
    String? userId = user?.uid;

    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${userId}/images")
        .child("post_$postID");

    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();

    //uploading to cloudfirestore
    await firebaseFirestore
        .collection("adverts")
        .doc("houses")
        .collection("images")
        .doc(postID)
        .set({
      "postId": postID,
      "name": namectrl.text.toString(),
      "details": detailsctrl.text.toString(),
      "location": locationctrl.text.toString(),
      "phone": phonectrl.text.length == 0 ? "0" : phonectrl.text.toString(),
      "downloadURL": downloadURL,
      "landlordId": userId,
    }).then((value) =>
            showSnackBar("Details uploaded successful", Duration(seconds: 2)));
  }

  Future<void> update_profile() async {
    await getUserId();
    String? uid = user?.uid;

    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${uid}/images")
        .child("post_$postID");

    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();

    CollectionReference reference =
        FirebaseFirestore.instance.collection("users");

    QuerySnapshot result = await reference.get();
    final result2 = result.docs;
    final list = result2.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data() as Map<String, dynamic>;
    }).toList();
    for (var item in list) {
      if (item["userId"] == uid) {
        item["name"] =
            !namectrl.text.isEmpty ? namectrl.text.toString() : widget.name;
        item["details"] = !detailsctrl.text.isEmpty
            ? detailsctrl.text.toString()
            : widget.details;
        item["location"] = !locationctrl.text.isEmpty
            ? locationctrl.text.toString()
            : widget.location;
        item["contact"] = phonectrl.text.length == 0
            ? widget.phone
            : phonectrl.text.toString();
        item["imgUrl"] = downloadURL;

        await reference.doc(item["userId"]).update(item);
      }
    }
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          //for rounded rectange clip
          child: Column(
            children: [
              const Text("Upload Image"),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: widget.url != null &&
                                !widget.url.toString().isEmpty &&
                                widget.url.toString().length != 0
                            ? Image.network(widget.url)
                            : _image == null ||
                                    _image.toString().isEmpty ||
                                    _image.toString().length == 0
                                ? const Center(child: Text("No Image Selected"))
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.file(_image!)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  imagePickerMethod();
                                },
                                child: Text("Select Image")),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  cameraPickerMethod();
                                },
                                child: Text("Take Picture")),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                //initialValue: widget.name,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  hintText: widget.name == null
                                      ? "Enter your Name"
                                      : widget.name,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        4.0,
                                      ),
                                    ),
                                  ),
                                ),
                                controller: namectrl,
                                validator: (value) {
                                  return validation.upload(value,
                                      "name can't be empty", widget.name);
                                },
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                //initialValue: widget.det,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.details),
                                  hintText: widget.details == null
                                      ? "Short Description about yourself"
                                      : widget.details,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        4.0,
                                      ),
                                    ),
                                  ),
                                ),
                                controller: detailsctrl,
                                validator: (value) {
                                  return validation.upload(
                                      value,
                                      "Description can't be empty",
                                      widget.details);
                                },
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.name,
                                //initialValue: widget.loc,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.location_on),
                                  hintText: widget.location == null
                                      ? "Location"
                                      : widget.location,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        4.0,
                                      ),
                                    ),
                                  ),
                                ),
                                controller: locationctrl,
                                validator: (value) {
                                  return validation.upload(
                                      value,
                                      "Location can't be empty",
                                      widget.location);
                                },
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                //initialValue: widget.pr,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone),
                                  hintText: widget.phone == null
                                      ? "Enter Telephone number"
                                      : widget.phone,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        4.0,
                                      ),
                                    ),
                                  ),
                                ),
                                controller: phonectrl,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          return ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (_image != null || widget.url != null) {
                                  update_profile()
                                      .then(
                                        (value) async => {
                                          print("Finished well"),
                                          showSnackBar(
                                            "Updated Successfully",
                                            Duration(seconds: 4),
                                          ),
                                          ref
                                              .watch(advert_state_provider)
                                              .state = 0,
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => Homepage(),
                                            ),
                                          ),
                                        },
                                      )
                                      .onError(
                                        (error, stackTrace) => showSnackBar(
                                          "Failed to update ${error.toString()}",
                                          Duration(seconds: 4),
                                        ),
                                      );
                                } else {
                                  showSnackBar(
                                    "Select Image first",
                                    Duration(milliseconds: 400),
                                  );
                                }
                              }
                              ;
                            },
                            child: Text("Update Profile"),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
