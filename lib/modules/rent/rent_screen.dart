import 'package:carent/models/process_model.dart';
import 'package:carent/shared/componants/build_cart_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/siginup_model/users_model.dart';
import '../../shared/componants/constants.dart';

class RentScreen extends StatelessWidget {
  const RentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        UsersModel userModel = Constants.usersModel!;
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('processes')
                    .where("dealType", isEqualTo: 'RequestType.RENT')
                    .where('clientEmail', isEqualTo: userModel.email)
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
                      children: const [
                        Center(
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
                            "No Rented Cars",
                            style: Constants.arabicTheme.textTheme.bodyText1!
                                .copyWith(color: Colors.black),
                          )),
                        )
                      : SizedBox(
                          height: 800.0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  ProcessModel processModel =
                                      ProcessModel.fromJson(data);
                                  cubit.getEmployeeData(
                                      processModel.deliveryId!);
                                  cubit.getCarData(processModel.carId!);
                                  return cubit.variableCarModel != null
                                      ? Row(
                                          children: [
                                            SizedBox(
                                              width: 500,
                                              child: CartCard(
                                                processModel: processModel,
                                                carModel:
                                                    cubit.variableCarModel!,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container();
                                })
                                .toList()
                                .cast(),
                          ),
                        );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
