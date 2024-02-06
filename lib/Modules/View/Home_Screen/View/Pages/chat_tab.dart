import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../utils/Helpers/Authentication_Helper/auth_helper.dart';
import '../../../../utils/Helpers/Cloud_Firestore_Helper/firestore_helper.dart';
import '../../../../utils/Stream/stream.dart';
import '../../../Chat_Screen/Model/chat_model.dart';
import '../../../Chat_Screen/Model/receiver_model.dart';

class chats extends StatelessWidget {
  chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent.withOpacity(0.20),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Auth_helper.auth_helper.signOut();

                  Get.offNamedUntil('/', (route) => false);
                },
                icon: const Icon(Icons.logout_outlined)),
          )
        ],
        title: (Auth_helper.auth_helper.firebaseAuth.currentUser?.displayName ==
                null)
            ? (Auth_helper.auth_helper.firebaseAuth.currentUser?.email == null)
                ? Text(
                    "John Doe",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                : Text(
                    "${Auth_helper.auth_helper.firebaseAuth.currentUser?.email?.split("@")[0]}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
            : Text(
                "${Auth_helper.auth_helper.firebaseAuth.currentUser?.displayName}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: Firestore_Helper.firestore_helper.fetchUser(),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>>? querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot<Map<String, dynamic>>>? userData =
                querySnapshot?.docs;

            return ListView.builder(
                itemCount: userData?.length,
                itemBuilder: (ctx, i) {
                  return Card(
                      elevation: 4,
                      child: ListTile(
                        tileColor: Colors.white,
                        onTap: () async {
                          Receiver receiver = Receiver(
                              name: userData?[i]['name'],
                              uid: userData?[i]['uid'],
                              photo: userData?[i]['photo']);

                          ChatDetails chatdata = ChatDetails(
                              receiverUid: receiver.uid,
                              senderUid: Auth_helper
                                  .auth_helper.firebaseAuth.currentUser!.uid,
                              message: "");

                          Get.toNamed("/chat", arguments: receiver);
                        },
                        title: Text(
                          "${userData?[i]['name']}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("${userData?[i]['email']}"),
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.purpleAccent,
                          child: CircleAvatar(
                            radius: 30,
                            foregroundImage:
                                NetworkImage("${userData?[i]['photo']}"),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Firestore_Helper.firestore_helper.deleteUser(
                                deleteData: "${userData?[i]['uid']}");
                          },
                          icon: Icon(Icons.delete_outline),
                        ),
                      ));
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
