import 'package:chat_app/api/apis.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/screen/profile_screen.dart';
import 'package:chat_app/widget/chat_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    List<ChatUserModel> list = [];

    return Scaffold(
      //appbar
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.home_outlined),
        ),
        title: const Text("We Chat"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ProfileSccreen(userProfile: APIs.me),
                ));
              },
              icon: const Icon(Icons.more_vert_outlined)),
        ],
      ),

      //floatingActionButton to add chat
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_comment),
      ),

      //body that contains chats
      body: StreamBuilder(
        stream: APIs.getAllusers(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            //if data is loadung
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator());

            // if  some or all data is loaded then show
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;

              list =
                  data?.map((e) => ChatUserModel.fromJson(e.data())).toList() ??
                      [];

              if (list.isNotEmpty) {
                return ListView.builder(
                  padding: EdgeInsets.only(top: mq.height * .01),
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ChatCard(user: list[index]);
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'No user Found !',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
