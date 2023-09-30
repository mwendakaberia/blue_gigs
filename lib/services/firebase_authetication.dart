import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection("users");
//var identityProvider;

Future<void> registerUser(String email, password, name, identity,contact) async {
  var res = await auth
      .createUserWithEmailAndPassword(email: email, password: password);
  if(res.user != null){
    print("second identity is ${identity}");
    //var uid = res.user?.uid;
    final userId = auth.currentUser!.uid;
    print("second uid is ${userId}");
    await users.doc(userId).set({
      "name":name,
      "identity":identity,
      "contact":contact,
      "userId":userId,
      "email":email,
      "rating":"0",
      "location":"",
      "details":"",
      "imgUrl":"",

    });
    print("Third identity is ${identity}");
  }
}

Future<void> signIn(String email, password) async {
  await auth.signInWithEmailAndPassword(email: email, password: password);
  print("Login uid : ${auth.currentUser!.uid}");
}

Future<void> signOut() async {
  await auth.signOut();

}
