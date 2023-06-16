import 'package:carent/layout/cubit/cubit.dart';
import 'package:carent/layout/main_layout.dart';
import 'package:carent/models/cart_model/car_model.dart';
import 'package:carent/models/process_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../modules/map_tracking/map_tracking.dart';
import 'componants.dart';
import 'constants.dart';

class CartCard extends StatefulWidget {
  const CartCard({
    super.key,
    required this.processModel,
    required this.carModel,
  });
  final ProcessModel processModel;
  final CarModel carModel;
  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    CarModel carModel = widget.carModel;
    var cubit = MainCubit.get(context);
    cubit.initializeDeliveryCubit(context);

    return Container(
      height: widget.processModel.requestStatus != 'RequestStatus.DELIVERED'
          ? 500
          : 400,
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: HexColor('48C9B0'),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.network(
                    widget.processModel.carImage!,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Car name',
                      style: TextStyle(fontSize: 16, fontFamily: 'jannah'),
                    ),
                    Text(
                      '${carModel.branch} - ${carModel.modelYear}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'jannah',
                          color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Order status',
                      style: TextStyle(fontSize: 16, fontFamily: 'jannah'),
                    ),
                    Text(
                      widget.processModel.requestStatus!.split('.')[1],
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'jannah',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Admin phone number',
                      style: TextStyle(fontSize: 16, fontFamily: 'jannah'),
                    ),
                    Text(
                      Constants.adminNumber ?? '',
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'jannah',
                          color: Colors.white),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delivery Number',
                      style: TextStyle(fontSize: 16, fontFamily: 'jannah'),
                    ),
                    Text(
                      cubit.employeeModel == null
                          ? 'Not Available Yet'
                          : cubit.employeeModel!.phone!,
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'jannah',
                          color: Colors.white),
                    ),
                  ],
                ),
                if (widget.processModel.requestStatus !=
                    'RequestStatus.DELIVERED')
                  Container(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () async {
                          if (cubit.employeeModel != null) {
                            navigateTo(context, const MapTracking());
                            await cubit.initializeDeliveryCubit(context);
                          }
                        },
                        child: const Text(
                          "Show Delivery Location",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
              ],
            ),
          ),
          if (widget.processModel.requestStatus != 'RequestStatus.DELIVERED')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: OutlinedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.redAccent)),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('processes')
                        .doc(widget.processModel.processId)
                        .delete()
                        .then((value) async {
                      await cubit.sendNotification(
                          context: context,
                          title: 'Cancelation',
                          body:
                              'Process ${widget.processModel.processId} is Canceled',
                          receiver: 'admin');
                      await cubit.sendNotification(
                          context: context,
                          title: 'Cancelation',
                          body:
                              'Process ${widget.processModel.processId} is Canceled',
                          receiver: 'employee');
                      await cubit.sendNotification(
                          context: context,
                          title: 'Cancelation',
                          body:
                              'Process ${widget.processModel.processId} is Canceled',
                          receiver: cubit.employeeModel!.uId!);
                      navigateAndFinish(context, const MainLayout());
                    });
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
        ],
      ),
    );
  }
}
