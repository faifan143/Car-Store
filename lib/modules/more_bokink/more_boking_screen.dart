import 'package:animate_do/animate_do.dart';
import 'package:carent/models/cart_model/car_model.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';
import '../../shared/styles/icon_brokin.dart';
import '../booking/booking_screen.dart';

class MoreBokingScreen extends StatelessWidget {
  const MoreBokingScreen({super.key, required this.carModel});
  final CarModel carModel;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              scrolledUnderElevation: 0,
              elevation: 0,
              backgroundColor: HexColor(
                '252527',
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  IconBroken.Arrow___Left_2,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            body: FadeInDown(
              delay: const Duration(microseconds: 60),
              child: ScrollConfiguration(
                behavior: MyBehavioure(),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: size.width,
                              height: size.height * 0.48,
                              decoration: BoxDecoration(
                                color: HexColor('D6F4DC'),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: size.height * 0.4,
                                  decoration: BoxDecoration(
                                    color: HexColor(
                                      '252527',
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(50),
                                      bottomLeft: Radius.circular(50),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        // top: size.height * 0.1,
                                        // right: size.width * 0.1,
                                        // left: size.width * 0.1,
                                        // bottom: size.height * 0,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 70),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: CarouselSlider.builder(
                                                  carouselController:
                                                      controller,
                                                  itemCount: urlImages.length,
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                    realIndex,
                                                  ) {
                                                    final urlImage =
                                                        urlImages[index];
                                                    return buildImage(
                                                      urlImage,
                                                      index,
                                                    );
                                                  },
                                                  options: CarouselOptions(
                                                      autoPlay: false,
                                                      enableInfiniteScroll:
                                                          true,
                                                      enlargeCenterPage: true,
                                                      onPageChanged:
                                                          (index, reason) {
                                                        cubit
                                                            .changecarouseloption(
                                                                index);
                                                      }),
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              buildIndicator(
                                                  context, urlImages.length),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        left: 0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  15, 0, 18, 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10,
                                                        vertical: 12),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10,
                                                        horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.white,
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 7,
                                                            spreadRadius: 0.5)
                                                      ],
                                                    ),
                                                    child: Image.asset(
                                                      "assets/images/bmw.png",
                                                      width: 25,
                                                      height: 25,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      // ignore: prefer_const_literals_to_create_immutables
                                                      children: [
                                                        const Text(
                                                          "BMW Model S",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Jannah',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        const Text(
                                                          "2021",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Jannah',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 5, left: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        'To communicate !',
                                        style: TextStyle(
                                          fontFamily: 'Jannah',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: HexColor(
                                            '252527',
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () async {
                                          makePhoneCall('0946 177 050');
                                        },
                                        icon: const Icon(IconBroken.Call),
                                        iconSize: 35,
                                        color: Colors.blue,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: IconButton(
                                          onPressed: () {
                                            makeChatWhatsApp();
                                          },
                                          icon: const Icon(
                                              Icons.mark_chat_unread_outlined),
                                          iconSize: 35,
                                          color: Colors.green,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 4, 0, 4),
                          child: Text(
                            "Specifications",
                            style: TextStyle(
                              fontFamily: 'Jannah',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: HexColor(
                                '252527',
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  carDetailsItem(
                                    context,
                                    const AssetImage(
                                      'assets/images/speed.png',
                                    ),
                                    '200 km/h',
                                  ),
                                  carDetailsItem(
                                      context,
                                      const AssetImage(
                                        'assets/images/cardoor.png',
                                      ),
                                      '4 Doors'),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  carDetailsItem(
                                      context,
                                      const AssetImage(
                                        'assets/images/seat.png',
                                      ),
                                      '4 Seats'),
                                  carDetailsItem(
                                      context,
                                      const AssetImage(
                                        'assets/images/tank.png',
                                      ),
                                      '50 Liters'),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: ReadMoreText(
                                'BMW has been around for over a century, and it never stops innovating. This is clear when you look at the new 2021 BMW lineup. Every coupe, Gran Coupe, convertible, and Sports Activity Vehicle available for the 2021 model year continues to build on what came before it. With their stunning luxury, incredible capability, and pulse-pounding performance, the 2021 BMW models earn the title of Ultimate Driving Machine.',
                                trimLines: 2,
                                //colorClickableText: Colors.blue,
                                trimMode: TrimMode.Line,
                                style: TextStyle(color: Colors.grey),
                                trimCollapsedText: 'Show more',
                                lessStyle: TextStyle(color: Colors.red),
                                trimExpandedText: 'Show less',
                                moreStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  height: 2,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            InkWell(
                              onTap: () {
                                navigateTo(
                                    context,
                                    BookingScreen(
                                      carModel: carModel,
                                    ));
                              },
                              child: Container(
                                width: size.width * 0.6,
                                height: size.height * 0.06,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    bottomRight: Radius.circular(25),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Booking Now',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  carDetailsItem(BuildContext context, AssetImage image, String text) {
    Size size = MediaQuery.of(context).size;
    return Expanded(
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                height: size.height * 0.075,
                width: size.width * 0.45,
                // ignore: sort_child_properties_last
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SizedBox(
                            height: 35,
                            width: 35,
                            child: Image(
                              image: image,
                              fit: BoxFit.cover,
                            ))),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: size.height * 0.05,
                      width: 2,
                      color: Colors.amber,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      text,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: HexColor('D6F4DC'),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

Future<void> makeChatWhatsApp() async {
  final Uri whatsApp = Uri.parse('whatsapp://send?phone=+963 981 681 916');
  if (await canLaunchUrl(whatsApp)) {
    await launchUrl(whatsApp);
  } else {
    throw 'Error occured coulnd\'t open link';
  }
}
