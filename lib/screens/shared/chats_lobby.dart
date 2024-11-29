/*

Chat System, credits to Furqan (furqan-ahm) 
https://github.com/furqan-ahm

*/

import 'package:flutter/material.dart';
import 'package:kaamsay/components/loading_widgets.dart';

import '../../models/chatroom.dart';
import '/models/message.dart';
import '/models/user_model.dart';
import '/resources/firebase_repository.dart';
import '/style/images.dart';
import '/style/styling.dart';
import '../../utils/storage_service.dart';
import 'chat_screen.dart';

class ChatsHomeScreen extends StatefulWidget {
  static const String routeName = '/chats-home-screen';

  const ChatsHomeScreen({super.key});
  @override
  _ChatsHomeScreenState createState() => _ChatsHomeScreenState();
}

class _ChatsHomeScreenState extends State<ChatsHomeScreen> {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  UserModel? _currentUser;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    if (_firebaseRepository.getCurrentUser() != null) {
      StorageService.readUser().then((UserModel? user) {
        setState(() {
          _currentUser = user;
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Styling.navyBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {},
        ),
        title: const Text(
          'Inbox',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgress(
                color: Theme.of(context).primaryColor,
              ),
            )
          : StreamBuilder<List<ChatRoom>>(
              stream: _firebaseRepository.getChatRooms(_currentUser!.uid!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  print('Stacktrace: ${(snapshot.error as Error).stackTrace}');
                }

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgress(
                        color: Theme.of(context).primaryColor,
                      ),
                    );

                  default:
                    List<ChatRoom> rooms =
                        snapshot.hasData ? snapshot.data! : [];

                    return ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (BuildContext context, int index) {
                        Message? lastMessage = rooms[index].lastMessage!;

                        bool isSentByMe =
                            lastMessage.sender!.uid == _currentUser!.uid;

                        UserModel targetUser = isSentByMe
                            ? lastMessage.reciever!
                            : lastMessage.sender!;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  chatRoom: rooms[index],
                                  otherUser: targetUser,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 0,
                            ),
                            child: Column(
                              children: [
                                (index == 0)
                                    ? const SizedBox(
                                        height: 24,
                                      )
                                    : const SizedBox.shrink(),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.all(2),
                                      // ignore: unnecessary_null_comparison
                                      decoration: (lastMessage != null
                                              ? lastMessage.unread! &&
                                                  !isSentByMe
                                              : false)
                                          ? BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                  Radius.circular(40)),
                                              border: Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              // shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                ),
                                              ],
                                            )
                                          : BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                ),
                                              ],
                                            ),
                                      child: const CircleAvatar(
                                        radius: 35,
                                        backgroundImage:
                                            //AssetImage(targetUser.profileImage),
                                            AssetImage(Images.avatar),
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Text(
                                                      targetUser.name!,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    lastMessage.unread! &&
                                                            !isSentByMe
                                                        ? Container(
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 5),
                                                            width: 7,
                                                            height: 7,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                            ),
                                                          )
                                                        : Container()
                                                  ],
                                                ),
                                                Text(
                                                  // ignore: unnecessary_null_comparison
                                                  lastMessage != null
                                                      ? '${lastMessage.time!.hour}:${lastMessage
                                                              .time!.minute}'
                                                      : '00:00',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                // ignore: unnecessary_null_comparison
                                                (lastMessage != null
                                                    ? lastMessage.text!
                                                    : ''),
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54,
                                                    fontWeight: lastMessage
                                                                .unread! &&
                                                            !isSentByMe
                                                        ? FontWeight.w800
                                                        : FontWeight.normal),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 0.5,
                                  color: Theme.of(context).primaryColor,
                                  height: 24,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                }
              },
            ),
    );
  }
}
