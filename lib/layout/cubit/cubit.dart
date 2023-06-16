import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carent/layout/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../models/cart_model/car_model.dart';
import '../../models/employeeModel.dart';
import '../../models/favourite_model/favourite_mode.dart';
import '../../models/menue_item/menue_item.dart';
import '../../models/process_model.dart';
import '../../models/siginup_model/users_model.dart';
import '../../modules/Offer/offer_screen.dart';
import '../../modules/cart/cart.dart';
import '../../modules/drawer/drawer_screen.dart';
import '../../modules/favoriet/favoriet_screen.dart';
import '../../modules/home/home_screen.dart';
import '../../modules/payment_page/payment_page.dart';
import '../../modules/profile/profile_screen.dart';
import '../../modules/rent/rent_screen.dart';
import '../../modules/search/search_screen.dart';
import '../../modules/signin/sign_in_screen.dart';
import '../../shared/componants/constants.dart';
import '../../shared/remot_local/cach_hilper.dart';

class MainCubit extends Cubit<MainStates> {
  MainCubit() : super(InitialState());

  static MainCubit get(context) => BlocProvider.of(context);
  MenuIteme currentItem = MenuItems.Home;
  var currentIndex = 0;
  refresh() {
    emit(ChangeColorsState());
  }

  List<Widget> screens = [
    const HomeScreen(),
    SearchScreen(),
    const FavorietScreen(),
    const OfferScreen(),
    ProfileScreen(),
  ];
  List<String> titles = [
    'Home',
    'Search',
    'Favourite',
    'Offer',
    'Profile',
  ];
  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  void changeDrawer(MenuIteme index) {
    currentItem = index;
    emit(ChangeDrawerState());
  }

  Widget getScreen() {
    switch (currentItem) {
      case MenuItems.Home:
        return const PaymentPage();
      case MenuItems.Rent:
        return const RentScreen();
      case MenuItems.cart:
        return const CartScreen();

      default:
        return const FavorietScreen();
    }
  }
//favourite

  List<FavouriteModel> favourite = [
    FavouriteModel(
      carId: 1,
      urlImage: 'assets/images/carr.png',
      description: 'The BMW X5 is a mid-size luxury SUV produced by BMW....',
      isFavourted: false,
      price: '12500',
      carName: 'Mercedes',
    ),
    FavouriteModel(
      carId: 2,
      urlImage: 'assets/images/carred.png',
      description: 'Hello world!',
      isFavourted: false,
      price: '15000',
      carName: 'Bmw',
    ),
    FavouriteModel(
      carId: 3,
      urlImage: 'assets/images/carred.png',
      description: 'The BMW X5 is a mid-size luxury SUV produced by BMW....',
      isFavourted: false,
      price: '14630',
      carName: 'Bmw',
    ),
    FavouriteModel(
      carId: 4,
      urlImage: 'assets/images/carr.png',
      description: 'Hello world!',
      isFavourted: false,
      price: '14684',
      carName: 'Mercedes',
    ),
    FavouriteModel(
      carId: 5,
      urlImage: 'assets/images/carred.png',
      description: 'The BMW X5 is a mid-size luxury SUV produced by BMW....',
      isFavourted: false,
      price: '12000',
      carName: 'Bmw',
    ),
  ];
  void changeFavourite(int index) {
    favourite[index].isFavourted = !favourite[index].isFavourted;
    emit(ChangeFavouriteState());
  }

//change brands

  List<String> segments = ['MERCEDES', 'BMW', 'TOYOTA', 'AUDI', 'FORD'];
  int isSegmentSelected = 0;
  void changeSegment(int index) {
    isSegmentSelected = index;
    emit(ChangeSegmentState());
  }
//change seats in bottom sheet

  List<String> seats = [
    '2',
    '4',
    '6',
  ];
  int isSeatSelected = 0;
  void changeSeats(int index) {
    isSeatSelected = index;
    emit(ChangeSeatsState());
  }
//change transmisson in bottom sheet

  bool isManualSelected = true;
  void changeTransmisson({required bool isManualSelected}) {
    this.isManualSelected = isManualSelected;
    emit(ChangeTranmissonState());
  }

//change Fuel
  List<String> fuelType = ['All', 'Fuel', 'Diesel'];
  int isFuelSelected = 0;
  void changeFuel(int index) {
    isFuelSelected = index;
    emit(ChangeFuelState());
  }

//brands icons

  List<String> brandsIcons = [
    'https://www.svgrepo.com/show/303249/mercedes-benz-9-logo.svg',
    'https://www.svgrepo.com/show/303249/mercedes-benz-9-logo.svg',
    'https://www.svgrepo.com/show/303277/bmw-logo-logo.svg',
    'https://www.svgrepo.com/show/452113/tayota.svg',
    'https://www.svgrepo.com/show/446947/chevrolet.svg',
    'https://www.svgrepo.com/show/452160/audi.svg',
    'https://www.svgrepo.com/show/303349/ford-1-logo.svg',
  ];
  List<String> brandsLabel = [
    'All Cars',
    'MERCEDES',
    'BMW',
    'TOYOTA',
    'CHEVORLET',
    'AUDI',
    'FORD',
  ];
  int isBrandIconSelected = 0;
  void changeBrandsIcons(int index) {
    isBrandIconSelected = index;
    emit(ChangeBrandIconState());
  }

//change color in fillter
  List<Color> colorItem = [
    Colors.black,
    Colors.red,
    Colors.yellow,
    Colors.white,
    Colors.blue,
    Colors.grey,
  ];

  List<String> colorMap = [
    'black',
    'red',
    'yellow',
    'white',
    'blue',
    'grey',
  ];

  int isSelectedColor = 0;
  void changeColors(int index) {
    isSelectedColor = index;
    emit(ChangeColorsState());
  }

  RangeValues values = const RangeValues(3000, 30000);

  void changeSlider(newValue) {
    values = newValue;
    emit(ChangeRangeSliderState());
  }

  bool isBottomSheetShown = false;
  void changeBottomSheetState({
    required bool isShow,
  }) {
    isBottomSheetShown = isShow;
    emit(ChangeBottomSheetState());
  }

  DateTimeRange select = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  void changeCalenderState({
    DateTimeRange? dateTimeRange,
    required TextEditingController calenderController,
  }) {
    select = dateTimeRange!;
    calenderController.text =
        '${select.start.day}-${select.start.month}-${select.start.year} To ${select.end.day}-${select.end.month}-${select.end.year}';
    emit(ChangeCalenderState());
  }

  void changeTimeState({
    required TextEditingController startTimeController,
    TimeOfDay? value,
    context,
  }) {
    startTimeController.text = value!.format(context);
    emit(ChangeStartTimeState());
  }

  int activeIndex = 0;
  void changecarouseloption(int? index) {
    activeIndex = index!;
    emit(ChangeCarouselOptionState());
  }

  void changeDeleteCalenderState({TextEditingController? calenderController}) {
    calenderController!.text = 'pick up a date';
    emit(ChangeCalenderState());
  }

  late int price;
  late int totalrice;
  int changePrice() {
    return price = select.duration.inDays * 10;
  }

  int totalPrice() {
    return totalrice = price + 10;
  }

  void changeLocationState({
    Position? value,
    TextEditingController? locationController,
  }) {
    locationController!.text = '${value!.latitude} N + ${value.longitude} E';
    emit(ChangeLocationState());
  }

  void changeDeleteLocationState({
    TextEditingController? locationController,
  }) {
    locationController!.text = 'pick up a location';
    emit(ChangeLocationState());
  }

  var picker = ImagePicker();
  File? profileImage;
  Future getProfileImage({required ImageSource source}) async {
    final pickedFile = await picker.pickImage(
      source: source,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      print('No image selected');
      emit(ProfileImagePickedErrorState());
    }
  }

  String profileImageUrl = "";
  void uploadProfileImage({
    required String name,
    required String phone,
  }) async {
    emit(UpLoadImagLodingState());
    if (profileImage == null) {
      UapdateUserdata(name: name, phone: phone);
    } else {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
          .putFile(profileImage!)
          .then((value) {
        // ignore: avoid_print
        //emit(UpdateImagSacseesState());

        value.ref.getDownloadURL().then((value) {
          profileImageUrl = value;
          UapdateUserdata(name: name, phone: phone, image: value);
          //emit(UpdateImagSacseesState());
        }).catchError((onError) {
          emit(UpLoadImagErrorState());
        });
      }).catchError((onError) {});
    }
  }

  UapdateUserdata({
    required String name,
    required String phone,
    String? image,
  }) {
    emit(UpdateImagLodingState());
    UsersModel newmodel = UsersModel(
      email: Constants.usersModel!.email,
      name: name,
      phone: phone,
      uId: Constants.usersModel!.uId,
      image: image ?? Constants.usersModel!.image,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update(newmodel.tomap())
        .then((value) {
      Constants.getUserData();
      currentIndex = 0;
      emit(UpdateImagSacseesState());
    }).catchError((onError) {
      emit(UpdateImagErrorState());
    });
  }

  void logoutAndNavigateToSignInScreen(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Set uId to null or any desired value indicating user is logged out
      uId = null;
      CacheHelper.removData(key: "uId").then((value) {
        CacheHelper.removData(key: "userJobType").then((value) async {
          await FirebaseMessaging.instance
              .unsubscribeFromTopic(Constants.usersModel!.phone!);
          Constants.usersModel = null;
          await FirebaseMessaging.instance.unsubscribeFromTopic('users');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
            (route) => true,
          );
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error logging out. Please try again.');
      print(e);
    }
  }

  Future<void> uploadProcess(
      {required BuildContext context, required ProcessModel process}) async {
    try {
      // Get a reference to the Firestore collection
      final DocumentReference processesDocument =
          FirebaseFirestore.instance.collection('processes').doc();

      process.processId = processesDocument.id;
      // Convert the ProcessModel object to a JSON map
      final Map<String, dynamic> processData = process.toJson();

      // Add the process document to the collection
      await processesDocument.set(processData).then((value) async {
        print('Process uploaded successfully!');
        await sendNotification(
            context: context,
            title: 'Open Up',
            body: 'New Process',
            receiver: 'admin');
        await sendNotification(
            context: context,
            title: 'Open Up',
            body: 'New Process',
            receiver: 'employee');
        emit(ProcessUploadedSuccessfully());
      });
    } catch (error) {
      print('Error uploading process: $error');
      emit(ProcessUploadingFailed());
    }
  }

  CarModel? variableCarModel;
  Future<void> getCarData(String carId) async {
    try {
      print("c1");
      // Get a reference to the Firestore collection
      final CollectionReference carsCollection =
          FirebaseFirestore.instance.collection('cars');
      print("c2 \n $carId");

      // Query the cars collection based on the carId
      QuerySnapshot querySnapshot =
          await carsCollection.where('carId', isEqualTo: carId).get();
      print("c3 \n ${querySnapshot.docs.length}");

      if (querySnapshot.docs.isNotEmpty) {
        print("c4");
        // Get the first document from the query results
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        print("c5");

        // Convert the document data to a CarModel object
        variableCarModel =
            CarModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        print("c6");
      } else {}
    } catch (error) {
      print('Error retrieving car data: $error');
      return null;
    }
  }

  EmployeeModel? employeeModel;
  Future<void> getEmployeeData(String empId) async {
    try {
      // Get a reference to the Firestore collection
      final CollectionReference carsCollection =
          FirebaseFirestore.instance.collection('companyUsers');

      // Query the cars collection based on the carId
      QuerySnapshot querySnapshot =
          await carsCollection.where('uId', isEqualTo: empId).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document from the query results
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];

        // Convert the document data to a CarModel object
        employeeModel = EmployeeModel.fromJson(
            documentSnapshot.data() as Map<String, dynamic>);
      } else {}
    } catch (error) {
      print('Error retrieving employee data: $error');
      return null;
    }
  }

  initializeDeliveryCubit(BuildContext context) async {
    print(123456798);
    await getProcessData();
    print(2);
    await getCarData(processModel!.carId!);
    print(3);
    reportController = TextEditingController();
    print(4);
    await getCurrentLocation();
    print(5);
  }

  late TextEditingController reportController;
  String reportField = "";

// Function to listen to the 'location' field in a document in the 'processes' collection
  void listenToLocation() {
    FirebaseFirestore.instance
        .collection('processes')
        .doc('${processModel!.processId}')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        if (data != null && data.containsKey('location')) {
          Map<String, dynamic> locationData = data['location'];
          currentPosition = Position(
            latitude: locationData['latitude'],
            longitude: locationData['longitude'],
            accuracy: locationData['accuracy'],
            speed: locationData['speed'],
            altitude: locationData['altitude'],
            heading: locationData['heading'],
            speedAccuracy: locationData['speedAccuracy'],
            timestamp: DateTime.now(),
            floor: locationData['floor'],
            isMocked: locationData['isMocked'],
          );
          // Do something with the currentLocation
          // e.g., update UI, perform calculations, etc.
        }
      }
    });
  }

  Position currentPosition = Position(
    latitude: 36.16571412472137,
    longitude: 37.1262037238395,
    accuracy: 10.0,
    speed: 0.0,
    altitude: 0.0,
    heading: 0.0,
    speedAccuracy: 0.0,
    timestamp: DateTime.now(),
    floor: null,
    isMocked: false,
  );

  Completer<GoogleMapController> gmapsController = Completer();

  Future<void> getCurrentLocation() async {
    try {
      Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      currentPosition = newPosition;
      print('Current Location: $currentPosition');

      final Query<Map<String, dynamic>> tripDocRef = FirebaseFirestore.instance
          .collection('companyUsers')
          .where('email', isEqualTo: employeeModel!.email)
          .where('userType', isEqualTo: "JobTypes.DELIVERY");

      QuerySnapshot<Map<String, dynamic>> tripSnapshot = await tripDocRef.get();
      if (tripSnapshot.docs.isNotEmpty) {
        final List<DocumentSnapshot<Map<String, dynamic>>> trips =
            tripSnapshot.docs;
        for (final trip in trips) {
          final tripDocRef = trip.reference;
          await tripDocRef.update({'locationData': '$currentPosition'});
        }
      } else {
        // Handle empty case
      }
    } catch (e) {
      print("Catch Error : $e");
    }

    GoogleMapController googleMapController = await gmapsController.future;
    Geolocator.getPositionStream().listen((newPosition) {
      currentPosition = newPosition;
      print('Location Update: $currentPosition');
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(newPosition.latitude, newPosition.longitude),
            zoom: 13.5,
          ),
        ),
      );
      emit(UpdatingCurrentLocation());
    });
  }

  bool isLoading = false;
  changeLoadingState() {
    isLoading = !isLoading;
    emit(UpdatingCurrentLocation());
  }

  double latitude = 0;
  double longitude = 0;
  void extractCoordinates(String input) {
    final regex = RegExp(
        r'(-?\d+(?:\.\d+)?)'); // Regular expression pattern to match decimal numbers
    final matches = regex.allMatches(input);
    if (matches.length >= 2) {
      latitude = double.tryParse(matches.elementAt(0).group(0) ?? '')!;
      longitude = double.tryParse(matches.elementAt(1).group(0) ?? '')!;
    }

    print('Latitude: $latitude');
    print('Longitude: $longitude');
  }

  ProcessModel? processModel;
  Future<void> getProcessData() async {
    print('p1');
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('processes')
            // .doc(employeeModel!.assignedProcessId)
            .doc()
            .get();
    print('p2');

    if (snapshot.exists) {
      print('p3');
      Map<String, dynamic> data = snapshot.data()!;
      processModel = ProcessModel.fromJson(data);
      print('p4');

      DateTime specifiedDate = DateTime.parse(processModel!.receivingDate!);
      DateTime now = DateTime.now();
      Duration difference = now.difference(specifiedDate);

      int differenceInDays = difference.inDays;

      print('p5');
      if (differenceInDays > int.parse(processModel!.duration!)) {
        print('p6');
        variableCarModel!.carStatus = 'CarStatus.AVAILABLE';
        FirebaseFirestore.instance
            .collection('cars')
            .doc(variableCarModel!.carId)
            .update(variableCarModel!.toJson());
        print('p7');
      }
      print('p8');
      emit(UpdatingCurrentLocation());
    }
  }

  Future<void> addToFavorites(CarModel carModel) async {
    try {
      // Get the reference to the user document
      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(Constants.usersModel!.uId)
          .collection('favorites')
          .doc(carModel.carId);

      // Update the favorites array field using FieldValue.arrayUnion
      await userRef.set(carModel.toJson());
      print('Car model added to favorites successfully!');
      emit(ChangeColorsState());
    } catch (e) {
      print('Error adding car model to favorites: $e');
    }
  }

  Future<void> deleteFromFavorites(CarModel carModel) async {
    try {
      // Get the reference to the user document
      DocumentReference userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(Constants.usersModel!.uId)
          .collection('favorites')
          .doc(carModel.carId);

      // Delete the car's document from the favorites collection
      await userRef.delete();
      print('Car model deleted from favorites successfully!');
      emit(ChangeColorsState());
    } catch (e) {
      print('Error deleting car model from favorites: $e');
    }
  }

  Future<bool> isCarFavorited(CarModel carModel) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(Constants.usersModel!.uId)
          .collection('favorites')
          .doc(carModel.carId)
          .get();

      return snapshot.exists;
    } catch (e) {
      print('Error checking car favorite status: $e');
      return false;
    }
  }

  Future<void> sendNotification({
    required BuildContext context,
    required String title,
    required String body,
    required String receiver,
  }) async {
    await http
        .post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAaAxG8lQ:APA91bFdB2jlnFxENfRE230BV6qU42tVn7jevPN_6ie3a_scggfB3homZXn-bZ7pt6tysec94Ug3SOFqPsatIy4ZwmVzU2MtENtgWtFFvxy_wT7ClXSueyFOK7_QrFzh5ZzDR5JioWra',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'data': {},
          'to': "/topics/$receiver",
        },
      ),
    )
        .then((value) async {
      print(value.statusCode);
      print("=========done=========");
      if (value.statusCode == 200) {
        print("=========notification send=========");
      } else {
        print("=========notification failed=========");
        print("=========false=========");
      }
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<ProcessModel?> fetchProcessModel(String carId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('processes')
          .where('carId', isEqualTo: carId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        final Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        return ProcessModel.fromJson(data);
      }
    } catch (e) {
      print('Error fetching ProcessModel: $e');
    }

    return null;
  }

  checkRents(
      {required CarModel carModel, required ProcessModel processModel}) async {
    await fetchProcessModel(carModel.carId!);
    if (processModel.requestDate!
            .compareTo(Timestamp.fromDate(DateTime.now())) >
        int.parse(processModel.duration!)) {
      carModel.carStatus = 'CarStatus.AVAILABLE';
      FirebaseFirestore.instance
          .collection('cars')
          .doc(carModel.carId)
          .update(carModel.toJson());
    }
  }
}
