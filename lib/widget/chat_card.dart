import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/my_date_ustils.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/screen/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  const ChatCard({super.key, required this.user});

  final ChatUserModel user;
  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  MassageModel? _massageModel;
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(
            horizontal: mq.width * .04, vertical: mq.height * .01),
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: StreamBuilder(
          stream: APIs.getLastusersMassages(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;

            final list =
                data?.map((e) => MassageModel.fromJson(e.data())).toList() ??
                    [];
            if (list.isNotEmpty) {
              _massageModel = list[0];
            }

//            log("the chat card data is : $data");

            return ListTile(
              //Navigate to chat screen of Specific persion
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatScreen(userInfo: widget.user),
                ));
              },

              // User profile
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .3),
                child: CachedNetworkImage(
                  width: mq.height * .060,
                  height: mq.height * .060,
                  fit: BoxFit.cover,
                  imageUrl: widget.user.image.toString(),
                  errorWidget: (context, url, error) =>
                      const CircleAvatar(child: Icon(Icons.person)),
                ),
              ),

              // User name
              title: Text(widget.user.name.toString()),

              // Last message
              subtitle: _massageModel != null // message is not null
                  ? _massageModel!.type ==
                          Type.image //check if last msg is image

                      ? const Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 17,
                              ),
                              Text(' Image')
                            ],
                          ),
                        )
                      : Text(_massageModel!.msg,
                          maxLines: 1) // if text then print it

                  //Message is null then print about
                  : Text(
                      widget.user.about.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

              // Last message time
              trailing: _massageModel == null
                  ? null //show nothing when no message is sent
                  : _massageModel!.readTime.isEmpty &&
                          _massageModel!.fromID != APIs.user.uid

                      //show unread message
                      ? Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )

                      // message send time
                      : Text(
                          MyDateUtils.getFormatedTimeInDate(
                              _massageModel!.sentTime),
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 12),
                        ),
            );
          },
        ));
  }
}
