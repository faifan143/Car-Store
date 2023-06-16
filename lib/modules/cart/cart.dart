import 'package:carent/modules/search/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../models/cart_model/car_model.dart';
import '../../shared/componants/constants.dart';
import '../../shared/styles/icon_brokin.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'My cart',
          style: TextStyle(fontFamily: 'jannah'),
        ),
        leading: IconButton(
          onPressed: () {
            ZoomDrawer.of(context)!.toggle();
          },
          icon: const Icon(
            IconBroken.Arrow___Left_2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(Constants.usersModel!.uId)
              .collection('cart')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> carSnapshot) {
            if (carSnapshot.hasError) {
              return Text(
                'Something is Wrong',
                style: Constants.arabicTheme.textTheme.bodyText1!
                    .copyWith(color: Colors.black),
              );
            }

            if (carSnapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }

            if (carSnapshot.data!.docs.isEmpty) {
              return SizedBox(
                height: 250,
                child: Center(
                  child: Text(
                    "No Cars in the cart",
                    style: Constants.arabicTheme.textTheme.bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                ),
              );
            }

            return SizedBox(
              height: 220.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                    carSnapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  CarModel carModel = CarModel.fromJson(data);
                  return Row(
                    children: [
                      if (carSnapshot.data!.docs.length <= 1)
                        const SizedBox(width: 30),
                      SizedBox(
                        width: 350.0,
                        child: SearchCarCard(carModel: carModel),
                      ),
                      const SizedBox(width: 10),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}
