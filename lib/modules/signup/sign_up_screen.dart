import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:carent/shared/componants/snackbar.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';
import '../../shared/remot_local/cach_hilper.dart';
import '../../shared/styles/icon_brokin.dart';
import '../signin/sign_in_screen.dart';
import 'cubitsignup/cubit.dart';
import 'cubitsignup/states.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
        create: (BuildContext context) => SigningUpCubit(),
        child: BlocConsumer<SigningUpCubit, SiginUpState>(
          listener: (context, state) {
            if (state is SiginUpCreetSacsessState) {
              CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
                navigateAndFinish(context, SignInScreen());
              }).onError((error, stackTrace) {});
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Scaffold(
                //backgroundColor: HexColor('C4C4C4'),
                body: Form(
                  key: formKey,
                  child: PageView(
                    children: [
                      ScrollConfiguration(
                        behavior: MyBehavioure(),
                        child: SingleChildScrollView(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Image.asset(
                                      'assets/images/background.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, right: 7),
                                    child: SizedBox(
                                      height: 270,
                                      width: 60,
                                      child: Image.asset(
                                        'assets/images/black.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 210,
                                    left: 10,
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 50,
                                        fontFamily: 'jannah.ttf',
                                        fontWeight: FontWeight.bold,
                                        color: HexColor('ffffff'),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 290,
                                    left: 10,
                                    child: Text(
                                      'Find and rental car\nin easy steps..!',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: HexColor('ffffff'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // ignore: avoid_unnecessary_containers
                                    Container(
                                      child: Image.asset(
                                        'assets/images/loginwavee.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      //height: 500,
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 0, right: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            defaultFormField(
                                              hint: 'Your Name',
                                              controller: nameController,
                                              type: TextInputType.text,
                                              validate: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your name';
                                                }
                                                final RegExp nameExp = RegExp(
                                                    r'^[a-zA-Z\u0600-\u06FF\s]+$');

                                                if (!nameExp.hasMatch(value)) {
                                                  return 'Please enter a valid name';
                                                }
                                              },
                                              prefix: IconBroken.Profile,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            defaultFormField(
                                              controller: emailController,
                                              hint: 'Your Email address',
                                              type: TextInputType.emailAddress,
                                              validate: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Email must not be empty';
                                                }
                                                final emailRegex = RegExp(
                                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                                if (!emailRegex
                                                    .hasMatch(value)) {
                                                  return 'Please enter a valid email address';
                                                }
                                              },
                                              prefix: IconBroken.Message,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            defaultFormField(
                                              controller: passwordController,
                                              hint: '* * * * * * * *',
                                              type:
                                                  TextInputType.visiblePassword,
                                              validate: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Password must not be empty';
                                                }
                                                // Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character
                                                final RegExp regex = RegExp(
                                                    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&\*~]).{8,}$');
                                                if (!regex.hasMatch(value)) {
                                                  return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character and be at least 8 characters long';
                                                }
                                              },
                                              prefix: IconBroken.Password,
                                              suffix:
                                                  SigningUpCubit.get(context)
                                                      .suffix,
                                              suffixPressed: () {
                                                SigningUpCubit.get(context)
                                                    .changePasswordVisibility();
                                              },
                                              isPassword:
                                                  SigningUpCubit.get(context)
                                                      .isPassword,
                                            ),

                                            const SizedBox(
                                              height: 10,
                                            ),
                                            IntlPhoneField(
                                              initialCountryCode: 'SY',
                                              decoration: const InputDecoration(
                                                  hintText: 'Phone number',
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide())),
                                              onChanged: (value) {
                                                phoneController.text =
                                                    "${value.number}";
                                              },
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            ConditionalBuilder(
                                              condition:
                                                  state is! SiginUpLodingState,
                                              builder: (BuildContext context) {
                                                return InkWell(
                                                  onTap: () {
                                                    final RegExp
                                                        phoneNumberRegex =
                                                        RegExp(r'^09\d{8}$');
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      if (phoneNumberRegex
                                                          .hasMatch(
                                                              phoneController
                                                                  .text
                                                                  .trim())) {
                                                        SigningUpCubit.get(
                                                                context)
                                                            .userSigningUp(
                                                          name: nameController
                                                              .text,
                                                          phone: phoneController
                                                              .text,
                                                          email: emailController
                                                              .text,
                                                          password:
                                                              passwordController
                                                                  .text,
                                                          context: context,
                                                        );
                                                      } else {
                                                        snackBar(
                                                            context: context,
                                                            contentType:
                                                                ContentType
                                                                    .warning,
                                                            title:
                                                                'Watch out !!',
                                                            body:
                                                                '${phoneController.text.trim()} is not a valid phone number');
                                                      }
                                                    }
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      height: 45,
                                                      width: 216,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: HexColor(
                                                                    'd83131')
                                                                .withOpacity(
                                                                    0.25),
                                                            blurRadius: 20,
                                                            spreadRadius: 1,
                                                            offset:
                                                                const Offset(
                                                                    0, 8),
                                                          ),
                                                        ],
                                                        color: HexColor(
                                                          '252527',
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: const [
                                                          Text(
                                                            'Sign Up',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontFamily:
                                                                  'jannah',
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Icon(
                                                            IconBroken
                                                                .Arrow___Right_2,
                                                            size: 19,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              fallback:
                                                  (BuildContext context) =>
                                                      const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Colors.amber),
                                              ),
                                            ),
                                            // const SizedBox(
                                            //   height: 10,
                                            // ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Do have an account?',
                                                  style: TextStyle(
                                                    color: HexColor('1A1A1A'),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    navigateTo(context,
                                                        SignInScreen());
                                                  },
                                                  child: Text(
                                                    'Sign In Now',
                                                    style: TextStyle(
                                                      color: HexColor('252527'),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
