import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/cart_model/car_model.dart';
import '../../shared/componants/constants.dart';
import '../../shared/styles/icon_brokin.dart';
import '../home/home_screen.dart';

class ViewAllCars extends StatelessWidget {
  const ViewAllCars({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            IconBroken.Arrow___Left_2,
            color: Colors.black,
            size: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('cars').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      "No Newly Added Cars",
                      style: Constants.arabicTheme.textTheme.bodyText1!
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
                                document.data()! as Map<String, dynamic>;
                            CarModel carModel = CarModel.fromJson(data);
                            bool isFavorited = false;
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(Constants.usersModel!.uId)
                                .collection('favorites')
                                .doc(carModel.carId)
                                .get()
                                .then((value) {
                              isFavorited =
                                  carModel.carId == value.data()!['carId']
                                      ? true
                                      : false;
                            });
                            return Row(
                              children: [
                                if (snapshot.data!.docs.length <= 1)
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
      ),
    );
  }
}
