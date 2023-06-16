import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/complaint_model.dart';
import '../../models/siginup_model/users_model.dart';
import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';
import '../../shared/componants/global_method.dart';
import '../../shared/componants/snackbar.dart';
import '../../shared/styles/icon_brokin.dart';
import '../edit_profile/editprofile.dart';

class ProfileScreen extends StatelessWidget {
  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  var emailController = TextEditingController();

  var contentsInfo = const TextStyle(
      fontWeight: FontWeight.normal, fontSize: 15, color: Colors.black45);

  late TextEditingController postTextController =
      TextEditingController(text: '');

  final _postFormKey = GlobalKey<FormState>();

  TextEditingController commentController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var profileImage = MainCubit.get(context).profileImage;
        UsersModel userModel = Constants.usersModel!;
        nameController.text = userModel!.name!;
        emailController.text = userModel.email!;
        phoneController.text = userModel.phone!;
        return Scaffold(
          body: ScrollConfiguration(
            behavior: MyBehavioure(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    height: size.height / 2.9,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          child: CustomPaint(
                            // ignore: sort_child_properties_last
                            child: SizedBox(
                              width: size.width,
                              height: size.height / 3,
                            ),
                            painter: HeaderCurvedContainer(),
                          ),
                        ),
                        Positioned(
                          top: size.height / 14,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            width: size.width / 2,
                            height: size.width / 2,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 5),
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: profileImage == null
                                        ? NetworkImage('${userModel.image}')
                                        : FileImage(profileImage)
                                            as ImageProvider)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              navigateTo(context, EditProfile());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Edit'),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  IconBroken.Edit,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.grey.shade100,
                      shadowColor: Colors.blue.shade200,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Uploaded by',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: Colors.deepOrange,
                                    ),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(userModel.image!),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(userModel.name!),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Submit A Complaint :',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Form(
                                      key: _postFormKey,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            maxLength: 50,
                                            controller: aboutController,
                                            style: const TextStyle(
                                              color: Colors.brown,
                                            ),
                                            keyboardType: TextInputType.text,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              errorBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.pink),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          TextFormField(
                                            maxLength: 200,
                                            controller: commentController,
                                            style: const TextStyle(
                                              color: Colors.brown,
                                            ),
                                            keyboardType: TextInputType.text,
                                            maxLines: 6,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              errorBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.pink),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value!.isEmpty ||
                                                  value.length < 7) {
                                                return 'invalid complaint';
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MaterialButton(
                                              onPressed: () async {
                                                if (commentController
                                                        .text.isEmpty ||
                                                    commentController
                                                            .text.length <
                                                        7) {
                                                  GlobalMethods.showErrorDialog(
                                                      error:
                                                          'Comment can\'t be less than 7 characters',
                                                      context: context);
                                                } else {
                                                  DocumentReference docRef =
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'complaints')
                                                          .doc();
                                                  ComplaintModel complaint =
                                                      ComplaintModel(
                                                    date: Timestamp.fromDate(
                                                        DateTime.now()),
                                                    complainerEmail:
                                                        userModel.email,
                                                    complainerNumber:
                                                        userModel.phone,
                                                    complaint: commentController
                                                        .text
                                                        .trim(),
                                                    complaintAbout:
                                                        aboutController.text
                                                            .trim(),
                                                    complaintId: docRef.id,
                                                  );
                                                  docRef
                                                      .set(complaint.toJson())
                                                      .then((value) async {
                                                    snackBar(
                                                        context: context,
                                                        contentType:
                                                            ContentType.success,
                                                        title: 'Success',
                                                        body:
                                                            'Complaint uploaded successfully');

                                                    await MainCubit.get(context)
                                                        .sendNotification(
                                                            context: context,
                                                            title: 'Complaint',
                                                            body:
                                                                'about : ${aboutController.text.trim()}',
                                                            receiver: 'admin');
                                                    commentController.clear();
                                                    MainCubit.get(context)
                                                        .currentIndex = 0;
                                                    MainCubit.get(context)
                                                        .refresh();
                                                  }).onError(
                                                          (error, stackTrace) {
                                                    print(error);
                                                    snackBar(
                                                        context: context,
                                                        contentType:
                                                            ContentType.failure,
                                                        title: 'Failure',
                                                        body:
                                                            'Complaint is not uploaded');
                                                  });
                                                }
                                              },
                                              color: Colors.blue,
                                              elevation: 10,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  side: BorderSide.none),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 14),
                                                child: Text(
                                                  'Send',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = HexColor('48C9B0');
    Path path = Path()
      ..relativeLineTo(0, 125)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 125)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

void showImageDialog(context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Please choose an option ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  MainCubit.get(context)
                      .getProfileImage(source: ImageSource.camera);
                },
                child: Row(
                  children: const [
                    Icon(
                      IconBroken.Camera,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Camera',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  MainCubit.get(context)
                      .getProfileImage(source: ImageSource.gallery);
                },
                child: Row(
                  children: const [
                    Icon(
                      IconBroken.Image_2,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Gallery',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: const [
                    Icon(
                      IconBroken.Delete,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Delete your image',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}
