import 'dart:io';

import 'package:easy_rent/models/advert_model.dart';
import 'package:easy_rent/models/user_model.dart';
import 'package:easy_rent/pages/chats.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class Widgets {
  Widget card(Advert_Model post, User_Model user) {
    return Container(
      //width: MediaQuery.of(context).size.width * .75,
      child: Card(
        margin: EdgeInsets.all(2.0),
        elevation: 5.0,
        shape: Border.all(color: Colors.cyan),
        child: Column(
          children: [
            Text(
              post.job,
              softWrap: true,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
                fontFamily: "Times New Roman",
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              child: user.imgUrl != null &&
                      !user.imgUrl.toString().isEmpty &&
                      user.imgUrl.toString().length != 0
                  ? Image.network(
                      user.imgUrl,
                      width: 150.0,
                      height: 150.0,
                    )
                  : Icon(
                      Icons.person_outline,
                      size: 100,
                      color: Colors.blue,
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Charge : ${post.currency} ${post.amount} ${post.duration}",
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contactDialogu(BuildContext context, User_Model user) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      widthFactor: 0.75,
      alignment: FractionalOffset.center,
      child: IntrinsicHeight(
        child: AlertDialog(
          title: Text("Personal Contacts"),
          actions: [
            TextButton(
              child: Text("Exit"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Icon(
                Icons.person_outline,
                size: 100,
                color: Colors.blue,
              ),
              Text(
                'User Profile',
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Card(
                  elevation: 6,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('User Name : '),
                            Text('${user.name}')
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Email Address : '),
                            Text('${user.email}')
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Phone Number : '),
                            Text('${user.phone}')
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Location : '),
                            Text('${user.location}')
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('About the Client : '),
                            Text('${user.details}')
                          ],
                        ),
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

  Widget postDialog(BuildContext context, Advert_Model post, User_Model user) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(25.0),
        child: AlertDialog(
          title: Text("Post Title"),
          actions: [
            TextButton(
              child: Text("Exit"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                return TextButton(
                    child: Text("Hire"),
                    onPressed: () {
                      print("oyahoyahoyahoyah");
                      Navigator.of(context).pop();
                      // showDialog(
                      //     context: context,
                      //     builder: (context) => contactDialogu(context, user));
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Chats(user.userId),
                        ),
                      );
                    });
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceBetween,
          content: Container(
            width: MediaQuery.of(context).size.width * .75,
            height: MediaQuery.of(context).size.width * .5,
            child: Card(
              elevation: 5.0,
              shape: Border.all(color: Colors.cyan),
              child: Column(
                children: [
                  Text(
                    post.job,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // SizedBox(
                  //   child: Image.network(
                  //     house.downloadUrl,
                  //     // width: 250.0,
                  //     // height: 250.0,
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                        "Charge : ${post.currency} ${post.amount} ${post.duration}"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text("Rating : ${user.rating}"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showSnackBar(BuildContext context, String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  late File image;
  final imagePicker = ImagePicker();

  Future<File> imagePickerMethod(BuildContext context) async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    // print("The first image is ${image}");

    if (pick != null) {
      image = File(pick.path);
    }
    print("The second image is ${image}");
    return image;
  }

  Future<File> cameraPickerMethod(BuildContext context) async {
    final pick = await imagePicker.pickImage(source: ImageSource.camera);

    if (pick != null) {
      image = File(pick.path);
    }
    return image;
  }
}
