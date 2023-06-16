import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../shared/componants/componants.dart';
import '../signin/sign_in_screen.dart';
import '../signup/sign_up_screen.dart';

class FristScreen extends StatelessWidget {
  const FristScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height,
              child: Image.asset(
                'assets/images/page1.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: size.height * 0.2,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: 'jannah'),
                    ),
                    const Text(
                      'Get started by', //creating your account
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        //fontFamily: 'jannah',
                      ),
                    ),
                    const Text(
                      'creating your account', //
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        //fontFamily: 'jannah',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 380,
              left: 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  defaultTextButton(
                    onTap: () {
                      navigateTo(context, SignUpScreen());
                    },
                    label: 'Sign Up',
                    height: size.height * 0.08,
                    width: size.width * 0.9,
                    color: HexColor('252527'),
                    context: context,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: size.height * 0.08,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: HexColor('252527'),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/google.png'),
                          const SizedBox(
                            width: 25,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Continue with Google',
                              style: TextStyle(
                                  color: HexColor('C9C6CE'),
                                  fontSize: 18,
                                  fontFamily: 'jannah'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: size.height * 0.08,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: HexColor('252527'),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/facebook.png'),
                          const SizedBox(
                            width: 25,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Continue with facebook',
                              style: TextStyle(
                                  color: HexColor('C9C6CE'),
                                  fontSize: 18,
                                  fontFamily: 'jannah'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  defaultTextButton(
                      onTap: () {
                        navigateTo(context, SignInScreen());
                      },
                      label: 'Sign In',
                      height: size.height * 0.08,
                      width: size.width * 0.9,
                      color: Colors.blueAccent,
                      context: context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
