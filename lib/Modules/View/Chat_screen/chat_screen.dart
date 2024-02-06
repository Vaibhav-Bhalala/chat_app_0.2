import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/Helpers/Authentication_Helper/auth_helper.dart';
import '../../utils/Helpers/Cloud_Firestore_Helper/firestore_helper.dart';
import '../../utils/Stream/stream.dart';
import 'Model/chat_model.dart';
import 'Model/receiver_model.dart';

class Chat_Screen extends StatelessWidget {
  Chat_Screen({super.key});

  TextEditingController messageController = TextEditingController();
  String? message;

  @override
  Widget build(BuildContext context) {
    Receiver receiver = ModalRoute.of(context)!.settings.arguments as Receiver;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.withOpacity(0.20),
        leadingWidth: 95,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_sharp,
                color: Colors.black,
              ),
            ),
          ],
        ),
        title: GestureDetector(
          onTap: () {
            Get.toNamed('/reciever', arguments: receiver);
          },
          child: Text(
            "${receiver.name}",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.video_camera_front_rounded,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.call,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.format_list_bulleted,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "lib/Modules/Assets/Images/chat_background.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: messageData,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("${snapshot.error}"));
                    } else if (snapshot.hasData) {
                      QuerySnapshot? querysnapshot = snapshot.data;
                      List<QueryDocumentSnapshot>? chats = querysnapshot?.docs;
                      return (chats!.isEmpty == true)
                          ? Center(
                              child: Column(
                                children: [
                                  Container(
                                    height: 300,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "https://cdn.dribbble.com/users/2812251/screenshots/6533993/bild_conversation.gif"),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "No Chat Yet....",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purpleAccent,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              reverse: true,
                              itemCount: chats.length,
                              itemBuilder: (ctx, i) {
                                return Row(
                                  mainAxisAlignment: (Auth_helper.auth_helper
                                              .firebaseAuth.currentUser?.uid ==
                                          chats[i]['sentby'])
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Chip(
                                            label: Text(
                                          "${chats[i]['message']}",
                                          selectionColor: Colors.purpleAccent,
                                        )),
                                        (chats[i]['timestamp'] == null)
                                            ? const Text(" ")
                                            : Text(
                                                "${chats[i]['timestamp'].toDate().toString().split(" ")[1].split(":")[0]}:"
                                                "${chats[i]['timestamp'].toDate().toString().split(" ")[1].split(":")[1]}")
                                      ],
                                    ),
                                  ],
                                );
                              });
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              TextFormField(
                controller: messageController,
                onChanged: (val) {
                  message = val;
                },
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (ctx) {
                          return Container(
                            height: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.camera_alt,
                                      size: 35,
                                    )),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.photo,
                                    size: 35,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.add,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    onPressed: () {
                      ChatDetails chatdetails = ChatDetails(
                        receiverUid: receiver.uid,
                        senderUid: Auth_helper
                            .auth_helper.firebaseAuth.currentUser!.uid,
                        message: message!,
                      );

                      Firestore_Helper.firestore_helper
                          .sendMessage(chatDetails: chatdetails);

                      messageController.clear();
                    },
                    icon: const Icon(Icons.send),
                  ),
                  hintText: "send message.....",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
