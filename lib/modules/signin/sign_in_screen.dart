import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../layout/main_layout.dart';
import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';
import '../../shared/remot_local/cach_hilper.dart';
import '../../shared/styles/icon_brokin.dart';
import '../signup/sign_up_screen.dart';
import 'cubitsignin/cubit.dart';
import 'cubitsignin/states.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => SignInCubit(),
      child: BlocConsumer<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state is SignInErorrState) {
            ShowTost(text: state.error, state: ToastState.ERROR);
          }
          if (state is SignInSacsessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              navigateAndFinish(context, const MainLayout());
            });
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              // backgroundColor: HexColor('C4C4C4'),
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
                                  padding:
                                      const EdgeInsets.only(top: 20, right: 7),
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
                                    'Sign In',
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
                                    height: 400,
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
                                            height: 20,
                                          ),
                                          const Text(
                                            'Your Email',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'jannah.ttf',
                                              //fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          defaultFormField(
                                            hint: 'name@gmail.com',
                                            controller: emailController,
                                            type: TextInputType.emailAddress,
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return 'Email must not be empty';
                                              }
                                              final emailRegex = RegExp(
                                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                              if (!emailRegex.hasMatch(value)) {
                                                return 'Please enter a valid email address';
                                              }
                                            },
                                            prefix: IconBroken.Message,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            'Your Password',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'jannah.ttf',
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          defaultFormField(
                                            controller: passwordController,
                                            hint: '* * * * * * * *',
                                            type: TextInputType.visiblePassword,
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
                                                SignInCubit.get(context).suffix,
                                            suffixPressed: () {
                                              SignInCubit.get(context)
                                                  .changePasswordVisibitlity();
                                            },
                                            isPassword: SignInCubit.get(context)
                                                .isPassword,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          ConditionalBuilder(
                                              condition:
                                                  state is! SignInLodingState,
                                              builder: (BuildContext context) {
                                                return InkWell(
                                                  onTap: () async {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      SignInCubit.get(context)
                                                          .userLogin(
                                                              context: context,
                                                              email:
                                                                  emailController
                                                                      .text,
                                                              password:
                                                                  passwordController
                                                                      .text);
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
                                                            'Sign In',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontFamily:
                                                                    'jannah'),
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
                                              fallback: (BuildContext
                                                      context) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    color: Colors.amber,
                                                  ))),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Don\'t have an account?',
                                                style: TextStyle(
                                                    color: HexColor('1A1A1A')),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  navigateTo(
                                                      context, SignUpScreen());
                                                },
                                                child: Text(
                                                  'Sign Up Now',
                                                  style: TextStyle(
                                                      color: HexColor('252527'),
                                                      fontWeight:
                                                          FontWeight.bold),
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
      ),
    );
  }
}
