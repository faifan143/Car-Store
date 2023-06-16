import 'package:animate_do/animate_do.dart';
import 'package:carent/layout/main_layout.dart';
import 'package:carent/models/cart_model/car_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/process_model.dart';
import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';
import '../../shared/styles/icon_brokin.dart';

class BookingScreen extends StatefulWidget {
  BookingScreen({super.key, required this.carModel});
  final CarModel carModel;
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime(2025);
  DateTime? picked;
  TimeOfDay? timeOfDay;
  String? bookin1day;
  late String bookingfordays;
  late double totalPrice;
  var calenderController = TextEditingController(text: 'pick up a date');
  var locationController = TextEditingController(text: 'pick up a location');
  var cardNumberController = TextEditingController();
  var bookingprice = TextEditingController();
  var startTimeController = TextEditingController(text: 'start time');
  var endTimeController = TextEditingController(text: 'end time');
  final dateTimeKey = GlobalKey<FormState>();
  late CarModel carModel;
  @override
  void initState() {
    // TODO: implement initState
    carModel = widget.carModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTimeRange? dateTimeRange;

    bool isDateRangeEqualOrGreater(DateTime startDate, DateTime endDate) {
      // Calculate the difference between the start and end dates in days
      Duration difference = endDate.difference(startDate);
      int numberOfDays = difference.inDays;

      // Check if the number of days is equal to or greater than 12
      return numberOfDays >= 12;
    }

    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {
        if (state is ProcessUploadedSuccessfully) {
          MainCubit.get(context).currentIndex = 0;
          navigateAndFinish(context, const MainLayout());
        }
      },
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text('Date & time'),
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
                  key: dateTimeKey,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          SizedBox(
                            height: 75,
                            child: textFormFields(
                              valueKey: 'calender',
                              controller: calenderController,
                              type: TextInputType.datetime,
                              enabled: false,
                              validation: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter a date';
                                }
                                return null;
                              },
                              function: () async {
                                dateTimeRange = await showDateRangePicker(
                                  initialEntryMode: DatePickerEntryMode.input,
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 100)),
                                );
                                if (dateTimeRange != null) {
                                  cubit.changeCalenderState(
                                    dateTimeRange: dateTimeRange,
                                    calenderController: calenderController,
                                  );
                                }

                                // showCustomDateRangePicker(
                                //   context,
                                //   dismissible: false,
                                //   minimumDate: DateTime.now(),
                                //   maximumDate:
                                //       DateTime.now().add(const Duration(days: 100)),
                                //   onApplyClick: (start, end) {
                                //     setState(() {
                                //       startDate = start;
                                //       endDate = end;
                                //     });
                                //     if (startDate != null) {
                                //       setState(() {
                                //         calenderController.text =
                                //             '${start.day}-${start.month}-${start.year} To ${end.day}-${end.month}-${end.year}';
                                //       });
                                //     }
                                //   },
                                //   onCancelClick: () {

                                //   },
                                //   backgroundColor: Colors.white,
                                //   primaryColor: Colors.black87,
                                // );
                              },
                              maxlength: 100,
                            ),
                          ),
                          Positioned(
                            top: 6,
                            child: IconButton(
                              onPressed: () {
                                cubit.changeDeleteCalenderState(
                                  calenderController: calenderController,
                                );
                              },
                              icon: const Icon(
                                IconBroken.Delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          SizedBox(
                            height: 75,
                            child: textFormFields(
                              valueKey: 'location',
                              controller: locationController,
                              type: TextInputType.text,
                              validation: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter a date';
                                }
                                return null;
                              },
                              enabled: false,
                              function: () {
                                getCurrentLocation().then((value) {
                                  ShowTost(
                                      text: 'location done!',
                                      state: ToastState.SUCCESS);
                                  cubit.changeLocationState(
                                      locationController: locationController,
                                      value: value);
                                });
                              },
                              maxlength: 100,
                            ),
                          ),
                          Positioned(
                            top: 6,
                            child: IconButton(
                              onPressed: () {
                                cubit.changeDeleteLocationState(
                                  locationController: locationController,
                                );
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
                          validation: (value) {
                            if (value!.isEmpty) {
                              return 'please enter a date';
                            }
                            return null;
                          },
                          function: () {},
                          maxlength: 16,
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
                              const Text(
                                'Booking price for 1 day',
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'jannah'),
                              ),
                              Text(
                                '${bookin1day = (double.parse(carModel.price!) * 0.03).toStringAsFixed(2)} \$',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'jannah',
                                    color: Colors.deepOrange),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Booking price for your days',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'jannah',
                                ),
                              ),
                              Text(
                                '${bookingfordays = dateTimeRange != null ? (isDateRangeEqualOrGreater(dateTimeRange!.start, dateTimeRange!.end) ? (double.parse(carModel.priceAfterOffer!) * 0.01).toStringAsFixed(2) : (double.parse(carModel.priceAfterOffer!) * 0.03).toStringAsFixed(2)) : bookin1day!} \$',
                                // '${bookinfordays = select.duration.inDays * bookin1day} \$',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'jannah',
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total price',
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'jannah'),
                              ),
                              if (bookingfordays != 0)
                                Text(
                                  '${totalPrice = double.parse(bookingfordays) + 10} \$',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'jannah',
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              if (bookingfordays == 0)
                                const Text(
                                  '0 \$',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'jannah',
                                      color: Colors.deepOrange),
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
                          if (dateTimeKey.currentState!.validate()) {
                            print('please enter all refoired');
                            Duration difference = dateTimeRange!.end
                                .difference(dateTimeRange!.start);
                            int numberOfDays = difference.inDays;
                            ProcessModel process = ProcessModel(
                                carId: carModel.carId,
                                car: carModel.branch,
                                carImage: carModel.imageFiles![0],
                                clientEmail: Constants.usersModel!.email,
                                clientNumber: Constants.usersModel!.phone,
                                dealType: 'RequestType.RENT',
                                duration: '$numberOfDays',
                                location: locationController.text.trim(),
                                processId: '',
                                deliveryId: '',
                                receivingDate: '',
                                requestDate: Timestamp.fromDate(DateTime.now()),
                                requestStatus: 'RequestStatus.WAITING',
                                totalCost: bookingfordays);
                            MainCubit.get(context).uploadProcess(
                                context: context, process: process);
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

  Widget textsWidget({String? label}) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          label!,
          style: TextStyle(
              fontSize: 18,
              color: Colors.pink.shade800,
              fontWeight: FontWeight.bold),
        ),
      );
}
