import 'package:animate_do/animate_do.dart';
import 'package:carent/models/cart_model/car_model.dart';
import 'package:carent/models/siginup_model/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';
import '../more_paying/more_paying_screen.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'New Offered cars',
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
                                .where("isOffered", isEqualTo: true)
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
                                        "No New offered Cars",
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
                                  'Used Offered Cars',
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
                                .where("isOffered", isEqualTo: true)
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
                                        "No Used Offered Cars",
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

  Future<void> _refresh() {
    return Future.delayed(const Duration(seconds: 1));
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
  Future<void> toggleFavorite() async {
    MainCubit.get(context).addToFavorites(widget.carModel);
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
          ],
        ),
      ),
    );
  }
}
