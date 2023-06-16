import 'package:carent/models/announce_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../shared/componants/constants.dart';
import '../../shared/styles/icon_brokin.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(fontFamily: 'jannah'),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            IconBroken.Arrow___Left_2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('adminAnnounces')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text(
                  'Something is Wrong',
                  style: Constants.arabicTheme.textTheme.bodyText1!
                      .copyWith(color: Colors.black),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                );
              }

              return snapshot.data!.docs.isEmpty
                  ? SizedBox(
                      height: 250,
                      child: Center(
                          child: Text(
                        "No Announces",
                        style: Constants.arabicTheme.textTheme.bodyText1!
                            .copyWith(color: Colors.black),
                      )),
                    )
                  : ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs
                          .map(
                            (DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              AnnounceModel announceModel =
                                  AnnounceModel.fromJson(data);
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                child: NotificationCard(
                                    context: context,
                                    announceModel: announceModel),
                              );
                            },
                          )
                          .toList()
                          .cast(),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.context,
    required this.announceModel,
  });
  final AnnounceModel announceModel;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('adminAnnounces')
                            .doc(announceModel.announceId)
                            .delete();
                      },
                      icon: Icon(
                        IconBroken.Delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      child: Container(
        height: 100,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            ' About : ${announceModel.announceAbout!} ,\n\n ${announceModel.announce!}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
