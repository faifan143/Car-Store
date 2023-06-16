import 'package:carent/models/siginup_model/users_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';
import '../../shared/styles/icon_brokin.dart';
import '../profile/profile_screen.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var phoneController = TextEditingController();

  var nameController = TextEditingController();

  var emailController = TextEditingController();
  late UsersModel userModel;
  var profileImage;
  @override
  void initState() {
    // TODO: implement initState
    profileImage = MainCubit.get(context).profileImage;
    userModel = Constants.usersModel!;
    nameController.text = userModel!.name!;
    emailController.text = userModel.email!;
    phoneController.text = userModel.phone!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<MainCubit, MainStates>(listener: (context, state) {
      if (state is UpdateImagSacseesState) {
        MainCubit.get(context).currentIndex = 0;
        MainCubit.get(context).refresh();
      }
      if (state is ProfileImagePickedSuccessState) {
        Navigator.of(context).pop();
      }
    }, builder: (context, state) {
      return Scaffold(
          appBar: defultAppBar(
            context: context,
            titel: 'Edit Profile',
          ),
          body: ScrollConfiguration(
              behavior: MyBehavioure(),
              child: SingleChildScrollView(
                child: Column(children: [
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
                        // Positioned(
                        //   top: size.height / 90,
                        //   left: size.width / 20,
                        //   // child: const Text(
                        //   //   "My profile",
                        //   //   style: TextStyle(
                        //   //     fontSize: 30,
                        //   //     color: Colors.black,
                        //   //     fontWeight: FontWeight.w600,
                        //   //     fontFamily: 'Jannah',
                        //   //   ),
                        //   // ),
                        // ),
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

                        Positioned(
                          top: size.height * 0.1,
                          left: size.width / 1.72,
                          child: InkWell(
                            onTap: () {
                              showImageDialog(context);
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.deepOrange.shade400,
                              child: const Icon(
                                IconBroken.Camera,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Name';
                        }
                      },
                      prefix: IconBroken.User,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: defaultFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Phone';
                        }
                      },
                      prefix: IconBroken.Call,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      MainCubit.get(context).uploadProfileImage(
                          name: nameController.text,
                          phone: phoneController.text);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: size.height * 0.06,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black,
                        ),
                        child: const Center(
                          child: Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Jannah',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              )));
    });
  }
}
