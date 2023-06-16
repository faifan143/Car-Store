import 'package:animate_do/animate_do.dart';
import 'package:carent/models/cart_model/car_model.dart';
import 'package:carent/models/siginup_model/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/process_model.dart';
import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';
import '../more_paying/more_paying_screen.dart';
import '../view_all_cars/view_all-cars.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _refresh() async {
      await MainCubit.get(context).refresh();
      return Future.delayed(const Duration(seconds: 1));
    }

    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        UsersModel userModel = Constants.usersModel!;
        return WillPopScope(
          onWillPop: () => _onBackButtonPressed(context),
          child: FadeInDown(
            delay: const Duration(milliseconds: 50),
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: RefreshIndicator(
                onRefresh: _refresh,
                color: Colors.blue,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi ${userModel.name!} !",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Search your favourite car here...',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      FanCarouselImageSlider(
                        sliderWidth: double.infinity,
                        imagesLink: Constants.images,
                        initalPageIndex: 0,
                        isAssets: false,
                        sliderHeight: 300,
                        indicatorActiveColor: Colors.amber,
                        indicatorDeactiveColor: Colors.black,
                        imageFitMode: BoxFit.cover,
                        expandImageHeight: 450,
                        turns: 75,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 13.5),
                                child: Text(
                                  'Latest cars added',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 7),
                                child: TextButton(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  onPressed: () {
                                    navigateTo(context, const ViewAllCars());
                                  },
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.amber),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('cars')
                                .limit(6)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  'Something is Wrong',
                                  style: Constants
                                      .arabicTheme.textTheme.bodyText1!
                                      .copyWith(color: Colors.black),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                                        "No Newly Added Cars",
                                        style: Constants
                                            .arabicTheme.textTheme.bodyText1!
                                            .copyWith(color: Colors.black),
                                      )),
                                    )
                                  : SizedBox(
                                      height: 220.0,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: snapshot.data!.docs
                                            .map((DocumentSnapshot document) {
                                              Map<String, dynamic> data =
                                                  document.data()!
                                                      as Map<String, dynamic>;
                                              CarModel carModel =
                                                  CarModel.fromJson(data);
                                              bool isFavorited = false;
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(
                                                      Constants.usersModel!.uId)
                                                  .collection('favorites')
                                                  .doc(carModel.carId)
                                                  .get()
                                                  .then((value) {
                                                isFavorited = value.exists;
                                              });
                                              return Row(
                                                children: [
                                                  if (snapshot
                                                          .data!.docs.length <=
                                                      1)
                                                    const SizedBox(width: 30),
                                                  SizedBox(
                                                    width: 350.0,
                                                    child: CarCard(
                                                      carModel: carModel,
                                                      used: carModel.isUsed!,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              );
                                            })
                                            .toList()
                                            .cast(),
                                      ),
                                    );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'New cars',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'jannah',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('cars')
                                .where("isUsed", isEqualTo: false)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  'Something is Wrong',
                                  style: Constants
                                      .arabicTheme.textTheme.bodyText1!
                                      .copyWith(color: Colors.black),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                                        "No New Cars",
                                        style: Constants
                                            .arabicTheme.textTheme.bodyText1!
                                            .copyWith(color: Colors.black),
                                      )),
                                    )
                                  : SizedBox(
                                      height: 220.0,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: snapshot.data!.docs
                                            .map((DocumentSnapshot document) {
                                              Map<String, dynamic> data =
                                                  document.data()!
                                                      as Map<String, dynamic>;
                                              CarModel carModel =
                                                  CarModel.fromJson(data);
                                              bool isFavorited = false;
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(
                                                      Constants.usersModel!.uId)
                                                  .collection('favorites')
                                                  .doc(carModel.carId)
                                                  .get()
                                                  .then((value) {
                                                isFavorited = value.exists;
                                              });
                                              return Row(
                                                children: [
                                                  if (snapshot
                                                          .data!.docs.length <=
                                                      1)
                                                    const SizedBox(width: 30),
                                                  SizedBox(
                                                    width: 350.0,
                                                    child: CarCard(
                                                      carModel: carModel,
                                                      used: false,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              );
                                            })
                                            .toList()
                                            .cast(),
                                      ),
                                    );
                            },
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Used Cars',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'jannah',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('cars')
                                .where("isUsed", isEqualTo: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  'Something is Wrong',
                                  style: Constants
                                      .arabicTheme.textTheme.bodyText1!
                                      .copyWith(color: Colors.black),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
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
                                        "No Used Cars",
                                        style: Constants
                                            .arabicTheme.textTheme.bodyText1!
                                            .copyWith(color: Colors.black),
                                      )),
                                    )
                                  : SizedBox(
                                      height: 220.0,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: snapshot.data!.docs
                                            .map((DocumentSnapshot document) {
                                              Map<String, dynamic> data =
                                                  document.data()!
                                                      as Map<String, dynamic>;
                                              CarModel carModel =
                                                  CarModel.fromJson(data);

                                              return Row(
                                                children: [
                                                  if (snapshot
                                                          .data!.docs.length <=
                                                      1)
                                                    const SizedBox(width: 30),
                                                  SizedBox(
                                                    width: 350.0,
                                                    child: CarCard(
                                                      carModel: carModel,
                                                      used: true,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              );
                                            })
                                            .toList()
                                            .cast(),
                                      ),
                                    );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool exitApp = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Really !'),
        content: const Text('Do you want to close app'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'No',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
    return exitApp;
  }
}

class CarCard extends StatefulWidget {
  CarCard({
    super.key,
    required this.used,
    required this.carModel,
  });

  final CarModel carModel;
  bool used = false;

  @override
  State<CarCard> createState() => _CarCardState();
}

class _CarCardState extends State<CarCard> {
  bool isFavorite = false;
  late ProcessModel processModel;

  Future<void> toggleFavorite() async {
    if (isFavorite == true) {
      MainCubit.get(context).deleteFromFavorites(widget.carModel);
    } else {
      MainCubit.get(context).addToFavorites(widget.carModel);
    }
    await MainCubit.get(context)
        .checkRents(processModel: processModel, carModel: widget.carModel);
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFavoriteStatus();
  }

  Future<void> fetchFavoriteStatus() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(Constants.usersModel!.uId)
        .collection('favorites')
        .doc(widget.carModel.carId)
        .get();
    setState(() {
      isFavorite = snapshot.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 17),
      child: InkWell(
        onTap: () {
          navigateTo(
              context,
              MorePayingScreen(
                carModel: widget.carModel,
                used: widget.used,
              ));
        },
        child: Stack(
          children: [
            Container(
              height: 200,
              width: 330,
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                color: HexColor('#d28a7c'),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CarName : ${widget.carModel.branch}'
                      "-"
                      '${widget.carModel.modelYear}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Price : ${widget.carModel.price} \$',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 150,
              width: 330,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  width: 0.5,
                  color: Colors.black,
                ),
              ),
              child: Image.network(
                widget.carModel.imageFiles![0],
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 10,
              left: 270,
              child: IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.topRight,
                onPressed: () async {
                  if (isFavorite) {
                    MainCubit.get(context).deleteFromFavorites(widget.carModel);
                  } else {
                    MainCubit.get(context).addToFavorites(widget.carModel);
                  }
                },
                icon: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_outline,
                    size: 25,
                    color: isFavorite ? Colors.red : Colors.black38,
                  ),
                ),
              ),
            ),
            if (widget.carModel.carStatus == 'CarStatus.RENTED')
              Container(
                height: 200,
                width: 330,
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    'RENTED',
                    style: Constants.arabicTheme.textTheme.headline1!
                        .copyWith(color: Colors.black54),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
// Padding(
//                   padding: const EdgeInsets.only(
//                     left: 10,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'BMW  x5m car ',
//                       ),
//                       Text(
//                         'The BMW X5 is a mid-size luxury SUV produced by BMW....',
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade300,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
