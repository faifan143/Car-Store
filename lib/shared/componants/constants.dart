import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../layout/cubit/cubit.dart';
import '../../models/siginup_model/users_model.dart';
import '../../modules/signin/sign_in_screen.dart';
import '../remot_local/cach_hilper.dart';
import 'componants.dart';

class MyBehavioure extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

Future<Position> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return ShowTost(
        text: 'Location services are disabled.', state: ToastState.ERROR);
  }
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return ShowTost(
          text: 'Location permissinons are denied.', state: ToastState.ERROR);
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return ShowTost(
      text:
          'Location permissions are premanetly denied ,  we can\'t request permissions',
      state: ToastState.ERROR,
    );
  }
  return await Geolocator.getCurrentPosition();
}

class Constants {
  // Define the English theme
  static ThemeData englishTheme = ThemeData(
    // Set the font family to Nunito
    // Define the text styles for the different typography elements
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.black,
      ),
      headline2: TextStyle(fontSize: 26, color: Colors.black),
      bodyText1: TextStyle(
        height: 2,
        fontWeight: FontWeight.bold,
        fontSize: 17,
        color: Colors.black,
      ),
    ),
  );

// Define the Arabic theme
  static ThemeData arabicTheme = ThemeData(
    // Set the font family to Cairo
    // Define the text styles for the different typography elements
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 26,
        color: Colors.white,
      ),
      headline2: TextStyle(fontSize: 20, color: Colors.white),
      bodyText1: TextStyle(
        height: 2,
        fontSize: 17,
        color: Colors.white,
      ),
    ),
  );

  static UsersModel? usersModel;
  static String? adminNumber;
  static Future<void> getUserData() async {
    await FirebaseMessaging.instance.subscribeToTopic('users');
    print("==============================================================4564");
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection("users").doc(uId).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()!;
      usersModel = UsersModel.fromJson(data);
      await FirebaseMessaging.instance.subscribeToTopic(usersModel!.phone!);
      adminNumber = await getAdminPhone();
    } else {}
  }

  static List<String> images = [];

  static Future<void> getRandomCarImagesLinks() async {
    final QuerySnapshot<Map<String, dynamic>> carsSnapshot =
        await FirebaseFirestore.instance.collection('cars').limit(5).get();

    final List<String> imageLinks = [];

    final Random random = Random();

    for (final DocumentSnapshot<Map<String, dynamic>> carDoc
        in carsSnapshot.docs) {
      final Map<String, dynamic>? carData = carDoc.data();
      final dynamic imagesData = carData!['imageFiles'];

      if (imagesData is Map<String, dynamic>) {
        final Map<String, dynamic> images = imagesData;
        final String randomImageUrl =
            images.values.elementAt(random.nextInt(images.length));
        imageLinks.add(randomImageUrl);
      } else if (imagesData is List<dynamic>) {
        final List<dynamic> imagesList = imagesData;
        final String randomImageUrl =
            imagesList[random.nextInt(imagesList.length)];
        imageLinks.add(randomImageUrl);
      }
    }

    images = imageLinks;
  }
}

final List<Color> colors = [
  Colors.amber,
  Colors.pink,
  Colors.orange,
  Colors.purple,
  Colors.brown,
  Colors.blue,
];
final urlImages = [
  'assets/images/carr.png',
  'assets/images/carred.png',
  'assets/images/carred.png',
  'assets/images/carr.png',
  'assets/images/carred.png',
];

final controller = CarouselController();

enum RequestType { RENT, BUY }

enum RequestStatus { WAITING, REJECTED, APPROVED, ONTHEWAY, DELIVERED }

enum CarStatus { RENTED, SOLD, AVAILABLE }

Widget buildIndicator(context, int length) => AnimatedSmoothIndicator(
      onDotClicked: animateToSlide,
      effect: const ExpandingDotsEffect(
        dotColor: Colors.white,
        dotWidth: 10,
        activeDotColor: Colors.amber,
        dotHeight: 8,
      ),
      activeIndex: MainCubit.get(context).activeIndex,
      count: length,
    );

void animateToSlide(int index) => controller.animateToPage(index);

Widget buildImage(String urlImage, int index) =>
    Image.network(urlImage, fit: BoxFit.cover);
String? uId = '';
void logOut(context) {
  CacheHelper.removData(key: 'uId').then((value) {
    if (value) {
      navigateAndFinish(context, SignInScreen());
    }
  });
}

Future<String?> getAdminPhone() async {
  // Get a reference to the Firestore collection
  final CollectionReference companyUsersCollection =
      FirebaseFirestore.instance.collection('companyUsers');

  // Create a query to filter documents where userType equals to JobTypes.ADMIN
  final QuerySnapshot<Map<String, dynamic>> snapshot =
      await companyUsersCollection
          .where('userType', isEqualTo: 'JobTypes.ADMIN')
          .limit(1)
          .get() as QuerySnapshot<Map<String, dynamic>>;

  // Check if any documents match the query
  if (snapshot.docs.isNotEmpty) {
    // Retrieve the phone field from the first matching document
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        snapshot.docs.first;
    final String? phone = documentSnapshot.data()!['phone'] as String?;
    return phone;
  }

  return null; // Return null if no matching document is found
}
