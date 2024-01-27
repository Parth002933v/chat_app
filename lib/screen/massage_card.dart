import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper/my_date_ustils.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';

class MassageCard extends StatefulWidget {
  const MassageCard({super.key, required this.msg});

  final MassageModel msg;
  @override
  State<MassageCard> createState() => _MassageCardState();
}

class _MassageCardState extends State<MassageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.msg.fromID
        ? _greenMessage()
        : _blueMessage();
  }

  //sendr message or recive message
  Widget _blueMessage() {
    //update the last read msg is sender and recever are diffetent
    if (widget.msg.readTime.isEmpty) {
      APIs.updatemessageReadStatus(widget.msg);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.only(
              right: mq.width * .1,
              left: mq.width * .04,
              bottom: mq.height * .01,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: Colors.lightBlueAccent.shade100,
            ),

            //msg text
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //chat message

                SizedBox(
                  child: widget.msg.type == Type.text
                      ? Text(widget.msg.msg,
                          style: const TextStyle(fontSize: 15))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.msg.msg,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.image_outlined),
                          ),
                        ),
                ),
                const SizedBox(height: 8),

                //time
                Text(
                  MyDateUtils.getFormatedTimeInHours(widget.msg.sentTime),
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),

        //message date time
        Padding(
          padding: EdgeInsets.only(right: mq.width * .03),
          child: Text(MyDateUtils.getFormatedTimeInDate(widget.msg.sentTime),
              //MyDateUtils.getFormatedTimeInHours(context, widget.msg.readTime),
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
        ),
      ],
    );
  }

  //user message or send message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //blue tick, time
        Row(
          children: [
            SizedBox(width: mq.width * .04),

            //blue tick icon
            if (widget.msg.readTime.isNotEmpty)
              const Icon(Icons.done_all, color: Colors.lightBlue),

            //for adding some space
            SizedBox(width: mq.width * .01),

            //message date  time
            Padding(
              padding: EdgeInsets.only(right: mq.width * .03, left: 0),
              child: Text(
                MyDateUtils.getFormatedTimeInDate(widget.msg.sentTime),
                //MyDateUtils.getFormatedTime(context, widget.msg.sentTime, ''),
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),
          ],
        ),

        //message content
        Flexible(
          child: Container(
            padding: widget.msg.type == Type.image
                ? EdgeInsets.all(mq.width * .03)
                : EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.only(
              left: mq.width * .08,
              right: mq.width * .04,
              bottom: mq.height * .01,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightGreen),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              color: Colors.lightGreenAccent.shade100,
            ),

            //msg text
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // chat message

                SizedBox(
                  child: widget.msg.type == Type.text
                      ? Text(widget.msg.msg,
                          style: const TextStyle(fontSize: 15))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: widget.msg.msg,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.image_outlined),
                          ),
                        ),
                ),

                const SizedBox(height: 8),

                //time
                Text(
                  MyDateUtils.getFormatedTimeInHours(widget.msg.sentTime),
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
