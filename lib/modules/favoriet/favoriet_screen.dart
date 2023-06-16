import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/cart_model/car_model.dart';
import '../../shared/componants/constants.dart';
import '../Offer/offer_screen.dart';

class FavorietScreen extends StatelessWidget {
  const FavorietScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: AnimationLimiter(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cubit.favourite.length,
                    itemBuilder: (context, index) {
                      if (cubit.favourite[index].isFavourted) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 1000),
                          child: SlideAnimation(
                            horizontalOffset: 300.0,
                            child: FadeInAnimation(
                              child: buildFavoriteItem(context, index),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
              Column(
                children: [
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
                        .collection('users')
                        .doc(Constants.usersModel!.uId)
                        .collection('favorites')
                        .where("isUsed", isEqualTo: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text(
                          'Something is Wrong',
                          style: Constants.arabicTheme.textTheme.bodyText1!
                              .copyWith(color: Colors.black),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                      Map<String, dynamic> data = document
                                          .data()! as Map<String, dynamic>;
                                      CarModel carModel =
                                          CarModel.fromJson(data);

                                      return Row(
                                        children: [
                                          if (snapshot.data!.docs.length <= 1)
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
                        .collection('users')
                        .doc(Constants.usersModel!.uId)
                        .collection('favorites')
                        .where("isUsed", isEqualTo: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text(
                          'Something is Wrong',
                          style: Constants.arabicTheme.textTheme.bodyText1!
                              .copyWith(color: Colors.black),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                      Map<String, dynamic> data = document
                                          .data()! as Map<String, dynamic>;
                                      CarModel carModel =
                                          CarModel.fromJson(data);

                                      return Row(
                                        children: [
                                          if (snapshot.data!.docs.length <= 1)
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
            ],
          ),
        );
      },
    );
  }

  Widget buildFavoriteItem(BuildContext context, int index) {
    var cubit = MainCubit.get(context);
    var favorite = cubit.favourite[index];
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 17),
      child: InkWell(
        onTap: () {
          // Navigate to the desired screen when tapping on the favorite item
          // navigateTo(context, MorePayingScreen());
        },
        child: Stack(
          children: [
            Container(
              height: 200,
              width: 330,
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Car Name: ${favorite.carName}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Price: ${favorite.price} \$',
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
              child: Image.asset(
                favorite.urlImage,
                fit: BoxFit.contain,
              ),
            ),
            // Positioned(
            //   top: 10,
            //   left: 270,
            //   child: IconButton(
            //     padding: EdgeInsets.zero,
            //     alignment: Alignment.topRight,
            //     onPressed: () {
            //       cubit.changeFavorite(index);
            //     },
            //     icon: CircleAvatar(
            //       radius: 18,
            //       backgroundColor: Colors.grey.shade300,
            //       child: Icon(
            //         favorite.isFavourted ? Icons.favorite : Icons.favorite_outline,
            //         size: 25,
            //         color: favorite.isFavourted ? Colors.red : Colors.black38,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
