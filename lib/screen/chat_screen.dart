import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/screen/massage_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum FromImage { gallery, capture }

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key, required this.userInfo});

  final ChatUserModel userInfo;

  List<MassageModel> _list = [];

  //var _isuplode = false;
  ValueNotifier<bool> _isuplode = ValueNotifier<bool>(false);

  // input controller
  final TextEditingController _textController = TextEditingController();

  // if Emoji picker is showing or not
  bool _emojiShowing = false;

  //appbar Widget
  Widget _appbar(BuildContext context) {
    return Row(
      children: [
        //back button
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_outlined)),

        //user profile picture
        ClipRRect(
          borderRadius: BorderRadius.circular(mq.height * .3),
          child: CachedNetworkImage(
            width: mq.height * .05,
            height: mq.height * .05,
            fit: BoxFit.cover,
            imageUrl: userInfo.image.toString(),
            errorWidget: (context, url, error) =>
                const CircleAvatar(child: Icon(Icons.person)),
          ),
        ),

        //adding some space
        SizedBox(width: mq.width * .03),

        //user info like name and last seen
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //user name
            Text(
              userInfo.name.toString(),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),

            //online status
            Text(
              'Last Seen not awailable',
              style: TextStyle(color: Colors.black.withOpacity(0.8)),
            )
          ],
        )
      ],
    );
  }

  //button & chat input field
  StatefulBuilder _chatFieldAndEmoji() {
    return StatefulBuilder(
      builder: (context, newState) => WillPopScope(
        // when press back button Emojo picker will Disappear
        onWillPop: () {
          if (_emojiShowing) {
            newState(() {
              _emojiShowing = !_emojiShowing;
            });
            return Future.value(false);
          }

          return Future.value(true);
        },
        child: Column(
          children: [
            //input field
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: mq.height * .01, horizontal: mq.width * .025),
              child: Row(
                children: [
                  //massage field
                  Expanded(
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          //emoji button
                          IconButton(
                              splashRadius: 25,
                              style: const ButtonStyle(
                                  shape:
                                      MaterialStatePropertyAll(CircleBorder())),
                              onPressed: () {
                                // to remove focus when we tap emoji
                                FocusScope.of(context).unfocus();

                                newState(() {
                                  //change bool value of emoji
                                  _emojiShowing = !_emojiShowing;
                                });
                              },
                              icon: const Icon(Icons.emoji_emotions_outlined)),

                          //input field
                          Expanded(
                            child: TextFormField(
                              onTap: () {
                                newState(() {
                                  // change bool value of emoji
                                  if (_emojiShowing == true) {
                                    _emojiShowing = !_emojiShowing;
                                  }
                                });
                              },
                              onFieldSubmitted: (value) {
                                if (_textController.text.isNotEmpty &&
                                    _textController.text.trim().isNotEmpty) {
                                  APIs.sendMesages(userInfo,
                                      _textController.text, Type.text);
                                  _textController.clear();
                                }
                              },
                              controller: _textController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                hintText: 'Message',
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          //image picker button
                          IconButton(
                              onPressed: () {
                                selectImagePicker(FromImage.gallery);
                              },
                              splashRadius: 25,
                              style: const ButtonStyle(
                                  shape:
                                      MaterialStatePropertyAll(CircleBorder())),
                              icon: const Icon(Icons.image_outlined)),

                          //camera button
                          IconButton(
                              onPressed: () {
                                selectImagePicker(FromImage.capture);
                              },
                              splashRadius: 25,
                              style: const ButtonStyle(
                                  shape:
                                      MaterialStatePropertyAll(CircleBorder())),
                              icon: const Icon(Icons.camera_alt_outlined))
                        ],
                      ),
                    ),
                  ),

                  // Send Button
                  MaterialButton(
                    minWidth: 0,
                    padding: const EdgeInsets.all(10),
                    onPressed: () {
                      if (_textController.text.isNotEmpty &&
                          _textController.text.trim().isNotEmpty) {
                        APIs.sendMesages(
                          userInfo,
                          _textController.text.trimLeft().trimRight(),
                          Type.text,
                        );
                        _textController.clear();
                      }
                    },
                    shape: const CircleBorder(),
                    color: Colors.red,
                    child: const Icon(Icons.send, color: Colors.white),
                  )
                ],
              ),
            ),

            // Emoji picker
            Offstage(
              offstage: !_emojiShowing,
              child: SizedBox(
                height: mq.height * .35,
                child: EmojiPicker(
                  textEditingController: _textController,
                  onBackspacePressed: _onBackspacePressed,
                  config: Config(
                    columns: 8,
                    emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    initCategory: Category.RECENT,
                    bgColor: const Color(0xFFF2F2F2),
                    indicatorColor: Colors.blue,
                    iconColor: Colors.grey,
                    iconColorSelected: Colors.blue,
                    backspaceColor: Colors.blue,
                    skinToneDialogBgColor: Colors.white,
                    skinToneIndicatorColor: Colors.grey,
                    enableSkinTones: true,
                    recentTabBehavior: RecentTabBehavior.RECENT,
                    recentsLimit: 28,
                    replaceEmojiOnLimitExceed: false,
                    noRecents: const Text(
                      'No Recents',
                      style: TextStyle(fontSize: 20, color: Colors.black26),
                      textAlign: TextAlign.center,
                    ),
                    loadingIndicator: const SizedBox.shrink(),
                    tabIndicatorAnimDuration: kTabScrollDuration,
                    categoryIcons: const CategoryIcons(),
                    buttonMode: ButtonMode.CUPERTINO,
                    checkPlatformCompatibility: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //where to pick image
  Future<void> selectImagePicker(
    FromImage fromImage,
  ) async {
    //creating object
    final ImagePicker picker = ImagePicker();

    final XFile? image;

    //where to take image gallery of camera?
    //pick from gallery
    if (fromImage == FromImage.gallery) {
      log("come in gallery");

      // Pick an image.
      image =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    }
    //pick from camera
    else if (fromImage == FromImage.capture) {
      log("come in capture");

      // Capture a photo.
      image =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    }
    //if both option is incorrect
    else {
      image = null;
    }

    //check if image picked or not
    if (image != null) {
      //show circular indicator
      _isuplode.value = true;

      //for updating image in firestore
      APIs.storeChatImages(userInfo, File(image.path))
          .then((value) => _isuplode.value = false); //when uplode complete the
      //circular indicator will remove
    }
  }

  //Backspace button logic in Emoji picker
  _onBackspacePressed() {
    _textController
      ..text = _textController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _textController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appbar(context),
        ),
        body: Column(
          children: [
            // Contain all conversation chats
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllusersMassages(userInfo),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    //if data is loadung
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: SizedBox());

                    // if  some or all data is loaded then show
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;

                      _list = data
                              ?.map((e) => MassageModel.fromJson(e.data()))
                              .toList() ??
                          [];
                      if (_list.isNotEmpty) {
                        // here to start messages from bottom side we first
                        // ordering msg according to read time in APIS.getAllusersMassages
                        // after we reverse the order in ListView.builder
                        return ListView.builder(
                          reverse: true,
                          padding: EdgeInsets.only(top: mq.height * .01),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            return MassageCard(msg: _list[index]);
                          },
                        );
                      } else {
                        return const Center(
                            child: Text(
                          'Say Hii! 👋',
                          style: TextStyle(fontSize: 20),
                        ));
                      }
                  }
                },
              ),
            ),

            // show if image is being uplode
            ValueListenableBuilder(
              valueListenable: _isuplode,
              builder: (context, value, child) => Offstage(
                offstage: !_isuplode.value,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: CircularProgressIndicator()),
                ),
              ),
            ),

            //Text Field and Emoji viwer
            _chatFieldAndEmoji()
          ],
        ),
      ),
    );
  }
}
