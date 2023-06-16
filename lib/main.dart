import 'package:carent/shared/componants/constants.dart';
import 'package:carent/shared/remot_local/cach_hilper.dart';
import 'package:carent/shared/styles/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_observer.dart';
import 'layout/cubit/cubit.dart';
import 'layout/cubit/states.dart';
import 'layout/main_layout.dart';
import 'modules/signin/sign_in_screen.dart';
import 'modules/splash_screen/splash_screen.dart';

Future<void> backgroundMessage(RemoteMessage event) async {
  print('Handling a background message ${event.messageId}');
  // Handle your background message here
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundMessage);
  // Handle when the app is opened from a terminated state
  FirebaseMessaging.instance.getInitialMessage().then((message) {});
  // Handle when the app is opened from a background state
  FirebaseMessaging.onMessageOpenedApp.listen((message) {});
  await FirebaseMessaging.instance.subscribeToTopic('users');
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool? ssplash = CacheHelper.getData(s: '-splash');
  uId = CacheHelper.getUId(key: 'uId');
  print(uId.toString());
  print(ssplash.toString());
  Widget wadgt;
  if (ssplash != null) {
    if (uId != null) {
      await Constants.getUserData();
      await Constants.getRandomCarImagesLinks();
      wadgt = const MainLayout();
    } else {
      wadgt = SignInScreen();
    }
  } else {
    wadgt = SplashScreen();
  }

  runApp(MyApp(
    startWidget: wadgt,
    splash: ssplash,
  ));
}

class MyApp extends StatelessWidget {
  final bool? splash;
  final Widget startWidget;
  const MyApp({
    Key? key,
    this.splash,
    required this.startWidget,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MainCubit(),
        ),
      ],
      child: BlocConsumer<MainCubit, MainStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            home: startWidget,
          );
        },
      ),
    );
  }
}
