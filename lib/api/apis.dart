import 'dart:developer';
import 'dart:io';

import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/src/types/interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  // Makeing instead of firebase auth
  static FirebaseAuth auth = FirebaseAuth.instance;

  // For accessing cloud Firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // For accessing cloud FireStorage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //to return current user.   //User type comes from auth
  static User get user => auth.currentUser!;

  //for storing current user info
  static late ChatUserModel me;

  //for getting current user info
  static Future<void> getSelfInfo() async {
    //Retrieving current user uid from firestore
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      //id get user
      if (user.exists) {
        //Storing user value in me variable
        me = ChatUserModel.fromJson(user.data()!);

        log("\n The user data : ${user.data()}");
      }
      //If user does not exist that create new
      else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  //cheque if user exist or not
  static Future<bool> isExist() async {
    return (await firestore.collection("users").doc(user.uid).get()).exists;
  }

  //creating new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch;

    final chatUser = ChatUserModel(
      id: user.uid,
      name: user.displayName!,
      email: user.email!,
      about: "Hey, I'm using We chat !",
      image: user.photoURL!,
      createdAt: time.toString(),
      lastActive: time.toString(),
      isOnline: false,
      pushToken: '',
    );

    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  //For getting all users From firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllusers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //for Update Profile details
  static Future<void> updateProfile() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  //For storing chat images
  static Future<void> storeChatImages(ChatUserModel userInfo, File file) async {
    //getting file extension
    final extension = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'chat_images/${userInfo.id}/${DateTime.now().millisecondsSinceEpoch}.$extension');

    //uploding image in firestorage
    await ref
        .putFile(file, SettableMetadata(contentType: "image/$extension"))
        .then((p0) {
      log("Data tranfered : ${p0.bytesTransferred / 1000} kb");
    });

    //updating image in firestore
    final imageUrl = await ref.getDownloadURL();

    sendMesages(userInfo, imageUrl, Type.image);
  }

  // For Updating User Profile picture
  static Future<void> updateUserProfilePicture(File file) async {
    //getting file extension
    final extension = file.path.split('.').last;

    log('the extension is : ${extension} ');

    //storage file ref with path
    final ref = storage.ref().child('profile_picture/${user.uid}.$extension');

    //uploding image in firestorage
    await ref
        .putFile(file, SettableMetadata(contentType: "image/$extension"))
        .then((p0) {
      log("Data tranfered : ${p0.bytesTransferred / 1000} kb");
    });

    //updating image in firestore
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  ///*************** Messages related APIS****************************
  //chats(collection) --> conversation_id (doc) --> messages(collection) -->  message(doc)

  //useful for getting Conversation ID
  static String getConversationID(String userInfo_id) {
    log("The user_uid_hascode is ${user.uid.hashCode} And The userInfo_id_hascode is  ${userInfo_id.hashCode} ");

    //userInfo means front persion
    //is is normally false
    bool istrue = user.uid.hashCode <= userInfo_id.hashCode;

    log("The Conversation condition is : $istrue"); //just to check
    return user.uid.hashCode <= userInfo_id.hashCode
        ? "${user.uid}_$userInfo_id"
        : "${userInfo_id}_${user.uid}";
  }

  //For getting all users massage of Specific Conversation From firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllusersMassages(
      ChatUserModel chatUserModel) {
    return firestore
        .collection('chats/${getConversationID(chatUserModel.id!)}/messages/')
        .orderBy("sent_time", descending: true)
        .snapshots();
  }

  //for sending messages
  static void sendMesages(ChatUserModel userInfo, String msg, Type type) async {
    //messages sending time(also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final message = MassageModel(
      msg: msg,
      sentTime: time,
      fromID: user.uid,
      readTime: '',
      ToID: userInfo.id!,
      type: type,
    );

    // create the reference of that path location where we store the data
    final ref = firestore
        .collection('chats/${getConversationID(userInfo.id!)}/messages/');

    log("the Conversation ID is : ${getConversationID(userInfo.id!)}");

    log('The time or ID is : $time');

    // send the data in that reference with create the doc(time) file name
    // also convert that data into json formate
    await ref.doc(time).set(message.toJson());
  }

  //update the read status  of msg
  static Future<void> updatemessageReadStatus(MassageModel massageModel) async {
    //this is for to update front persion read status
    firestore
        .collection('chats/${getConversationID(massageModel.fromID)}/messages/')
        .doc(massageModel.sentTime)
        .update({'read_time': DateTime.now().millisecondsSinceEpoch});
  }

  //getting last message of Specific Conversation From firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastusersMassages(
      ChatUserModel chatUserModel) {
    return firestore
        .collection('chats/${getConversationID(chatUserModel.id!)}/messages/')
        .orderBy("read_time", descending: true)
        .limit(1)
        .snapshots();
  }
}
