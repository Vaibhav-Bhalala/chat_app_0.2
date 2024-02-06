import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/Helpers/Authentication_Helper/auth_helper.dart';
import '../../../../utils/Helpers/Cloud_Firestore_Helper/firestore_helper.dart';
import '../../../../utils/Stream/stream.dart';
import '../../../Chat_Screen/Model/chat_model.dart';
import '../../../Chat_Screen/Model/receiver_model.dart';

class people extends StatelessWidget {
  const people({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.withOpacity(0.20),
        actions: [],
        title: Text(
          "People",
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
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
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
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          leading: CircleAvatar(
                            radius: 30,
                            foregroundImage:
                                NetworkImage("${userData?[i]['photo']}"),
                          ),
                          trailing: Icon(Icons.mark_unread_chat_alt_outlined),
                        )),
                  );
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
