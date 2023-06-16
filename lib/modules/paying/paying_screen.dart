import 'package:animate_do/animate_do.dart';
import 'package:carent/layout/cubit/cubit.dart';
import 'package:carent/layout/cubit/states.dart';
import 'package:carent/layout/main_layout.dart';
import 'package:carent/models/cart_model/car_model.dart';
import 'package:carent/models/process_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';
import '../../shared/styles/icon_brokin.dart';

class PayingScreen extends StatefulWidget {
  PayingScreen({super.key, required this.carModel});
  final CarModel carModel;
  @override
  State<PayingScreen> createState() => _PayingScreenState();
}

class _PayingScreenState extends State<PayingScreen> {
  var formKey = GlobalKey<FormState>();
  var locationController = TextEditingController(text: 'pick up a location');
  var cardNumberController = TextEditingController();
  late CarModel carModel;
  @override
  void initState() {
    // TODO: implement initState
    carModel = widget.carModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {
        if (state is ProcessUploadedSuccessfully) {
          MainCubit.get(context).currentIndex = 0;
          navigateAndFinish(context, MainLayout());
        }
      },
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text(
              'Paying',
              style: TextStyle(fontFamily: 'jannah'),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                IconBroken.Arrow___Left_2,
              ),
            ),
          ),
          body: FadeInDown(
            delay: const Duration(
              milliseconds: 60,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          SizedBox(
                            height: 75,
                            child: textFormFields(
                              valueKey: 'location',
                              controller: locationController,
                              type: TextInputType.text,
                              enabled: false,
                              function: () {
                                getCurrentLocation().then((value) {
                                  ShowTost(
                                      text: 'location done!',
                                      state: ToastState.SUCCESS);
                                  setState(() {
                                    locationController.text =
                                        '${value.latitude} N + ${value.longitude} E';
                                  });
                                });
                              },
                              maxlength: 100,
                              validation: (value) {
                                if (value!.isEmpty) {
                                  return "choose location";
                                }
                              },
                            ),
                          ),
                          Positioned(
                            top: 6,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  locationController.text =
                                      'pick up a location';
                                });
                              },
                              icon: const Icon(
                                IconBroken.Delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 75,
                        child: textFormFields(
                          valueKey: 'cardnumber',
                          label: 'Please enter the card number',
                          controller: cardNumberController,
                          type: TextInputType.number,
                          enabled: true,
                          function: () {},
                          maxlength: 16,
                          validation: (value) {
                            if (value!.isEmpty) {
                              return "invalid value";
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Car price',
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'jannah'),
                              ),
                              Text(
                                '${carModel.priceAfterOffer} \$',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'jannah',
                                    color: Colors.deepOrange),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Delivery price',
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'jannah'),
                              ),
                              Text(
                                '90 \$',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'jannah',
                                    color: Colors.deepOrange),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total price',
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'jannah'),
                              ),
                              Text(
                                '${double.parse(carModel.priceAfterOffer!) + 90} \$',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'jannah',
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      defaultButton(
                        function: () {
                          if (formKey.currentState!.validate()) {
                            ProcessModel process = ProcessModel(
                                carId: carModel.carId,
                                car: carModel.branch,
                                carImage: carModel.imageFiles![0],
                                clientEmail: Constants.usersModel!.email,
                                clientNumber: Constants.usersModel!.phone,
                                dealType: 'RequestType.BUY',
                                duration: '',
                                location: locationController.text.trim(),
                                processId: '',
                                receivingDate: '',
                                requestDate: Timestamp.fromDate(DateTime.now()),
                                requestStatus: 'RequestStatus.WAITING',
                                totalCost:
                                    '${double.parse(carModel.priceAfterOffer!) + 90}');
                            MainCubit.get(context).uploadProcess(
                                process: process, context: context);
                          }
                        },
                        text: 'Booking',
                        isUpperCase: false,
                        width: 150,
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
}
