import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../shared/componants/componants.dart';
import '../../shared/remot_local/cach_hilper.dart';
import '../signin/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool isLast = false;
  void submit() {
    CacheHelper.savebool(key: '-splash', value: true).then((value) {
      if (value) {
        navigateAndFinish(context, SignInScreen());
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Lottie.asset(
        'assets/images/carrental.json',
        controller: _controller,
        onLoaded: (composition) {
          setState(() {
            isLast = !isLast;
          });
          _controller
            ..duration = composition.duration
            ..forward().whenComplete(() {
              if (isLast) {
                submit();
              }
            });
        },
      ),
    );
  }
}
