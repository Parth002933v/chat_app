// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSccreen extends StatelessWidget {
  ProfileSccreen({super.key, required this.userProfile});

  final ChatUserModel userProfile;

  final _formKey = GlobalKey<FormState>();

  String? _image;

  //Function to logout
  _signOut(BuildContext context) async {
    //for showing progressbar
    Dialogs.showProgressBar(context);

    //Log out from Firebase and Google signing package
    await APIs.auth.signOut().then(
      (value) async {
        return await GoogleSignIn().signOut().then(
          (value) {
            //for hiding progressbar
            Navigator.of(context).pop();

            //for moving to Home screen
            Navigator.of(context).pop();

            //Navigate to lock in screen
            if (context.mounted) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
            }
          },
        );
      },
    );
  }

  //for image picker
  void _showbottumSheet(BuildContext context, StateSetter newState) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          padding:
              EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .01),
          children: [
            //for Pick Profile Image Text
            const Text(
              'Pick Profile Image',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),

            //for adding some space
            SizedBox(height: mq.height * .02),

            //buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //pick from gallary Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(mq.width * .3, mq.height * .15),
                  ),
                  onPressed: () async {
                    //pick image from gallery
                    await selectImagePicker("gallery", newState, context);
                  },
                  child: Image.asset("assets/image_picker.png"),
                ),

                //take picture button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(mq.width * .3, mq.height * .15),
                  ),
                  onPressed: () async {
                    //await selectImagePicker("capture");
                    await selectImagePicker("capture", newState, context);
                  },
                  child: Image.asset("assets/camera.png"),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  //where to pick image
  Future<void> selectImagePicker(
      String s, StateSetter newState, BuildContext context) async {
    Dialogs.showProgressBar(context);

    //creating object
    final ImagePicker picker = ImagePicker();

    final XFile? image;

    //where to take image gallery of camera?
    //pick from gallery
    if (s.contains("Gallery".toLowerCase())) {
      // Pick an image.
      image =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    }
    //pick from camera
    else if (s.contains("capture".toLowerCase())) {
      // Capture a photo.
      image =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    }
    //if both option is incorrect
    else {
      image = null;
    }

    //check if image picked or not
    if (image != null) {
      log("The Image Path is : ${image.path}");

      //updating image
      newState(() {
        _image = image!.path;
      });

      //for updating image in firestore
      APIs.updateUserProfilePicture(File(_image!));

      //for hiding progressbar
      Navigator.of(context).pop();

      //for hiding bottom sheet
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keybord
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //AppBar
        appBar: AppBar(title: const Text("Profile screen")),

        //body
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .03),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //for adding some space
                  SizedBox(width: mq.width, height: mq.height * .03),

                  //for adding profile image
                  StatefulBuilder(
                    builder: (context, newState) => Stack(
                      children: [
                        _image != null
                            ?
                            //local image
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                ),
                              )
                            :

                            //profile image form server
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .3),
                                child: CachedNetworkImage(
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                  imageUrl: userProfile.image.toString(),
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          child: Icon(Icons.person)),
                                ),
                              ),

                        //edit button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            onPressed: () {
                              //_showButtomSheet();
                              _showbottumSheet(context, newState);
                            },
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: Icon(Icons.edit,
                                color: Colors.blueAccent.shade700),
                          ),
                        )
                      ],
                    ),
                  ),

                  //adding some space
                  SizedBox(height: mq.height * .03),

                  //adding email adrress
                  Text(
                    userProfile.email.toString(),
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),

                  //adding some space
                  SizedBox(height: mq.height * .05),

                  //adding name field
                  TextFormField(
                    initialValue: userProfile.name,
                    onSaved: (value) => APIs.me.name = value ?? '',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Required Field";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.blue),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        labelText: "Name",
                        hintText: "ex. rahul gandhi"),
                  ),

                  //adding some space
                  SizedBox(height: mq.height * .03),

                  //adding about field
                  TextFormField(
                    initialValue: userProfile.about,
                    onSaved: (value) => APIs.me.about = value ?? '',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Required Field";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.info_outline, color: Colors.blue),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      labelText: "About",
                      hintText: "I'm feeling great ",
                    ),
                  ),

                  //adding some space
                  SizedBox(height: mq.height * .04),

                  //update profile  Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: Size(mq.width * .5, mq.height * .06),
                        shape: const StadiumBorder()),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateProfile().then((value) => {
                              Dialogs.showSnackbar(
                                  context, "Pofile Updated Successfully !")
                            });
                      }
                    },
                    icon: const Icon(Icons.edit, size: 28, color: Colors.white),
                    label: const Text('Update',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),

        //Logout Button
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _signOut(context);
          },
          backgroundColor: Colors.red,
          icon: const Icon(Icons.logout_outlined, color: Colors.white),
          label: const Text("Logout", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
