import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/cart_model/car_model.dart';
import '../../shared/componants/componants.dart';
import '../../shared/componants/constants.dart';
import '../../shared/styles/icon_brokin.dart';
import '../more_paying/more_paying_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);

        return Scaffold(
          key: scaffoldKey,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 275,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade100),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) => cubit.refresh(),
                          decoration: const InputDecoration(
                            hintText: 'Search Products',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 13),
                            prefixIcon: Icon(
                              IconBroken.Search,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.black,
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor:
                                  const Color.fromARGB(255, 180, 208, 255),
                              builder: (context) => Container(
                                height: size.height * 0.7,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 180, 208, 255),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 5,
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) =>
                                              InkWell(
                                            onTap: () =>
                                                cubit.changeSeats(index),
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 45,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: cubit.isSeatSelected ==
                                                        index
                                                    ? Colors.amber.shade200
                                                    : Colors.grey.shade100,
                                              ),
                                              child: Text(
                                                '${cubit.seats[index]} seats',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          separatorBuilder: (context, index) =>
                                              Container(
                                            width: 10,
                                          ),
                                          itemCount: cubit.seats.length,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Transmission',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  cubit.changeTransmisson(
                                                      isManualSelected: true);
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 45,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: cubit
                                                            .isManualSelected
                                                        ? Colors.amber.shade200
                                                        : Colors.grey.shade100,
                                                  ),
                                                  child: const Text(
                                                    'Manual',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  cubit.changeTransmisson(
                                                      isManualSelected: false);
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 45,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: !cubit
                                                            .isManualSelected
                                                        ? Colors.amber.shade200
                                                        : Colors.grey.shade100,
                                                  ),
                                                  child: const Text(
                                                    'Automatic',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Fuel Type',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          SizedBox(
                                            height: 50,
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              itemBuilder: (context, index) =>
                                                  InkWell(
                                                onTap: () =>
                                                    cubit.changeFuel(index),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 45,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color:
                                                        cubit.isFuelSelected ==
                                                                index
                                                            ? Colors
                                                                .amber.shade200
                                                            : Colors
                                                                .grey.shade100,
                                                  ),
                                                  child: Text(
                                                    cubit.fuelType[index],
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              separatorBuilder:
                                                  (context, index) => Container(
                                                width: 5,
                                              ),
                                              itemCount: cubit.fuelType.length,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Popular colors',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          SizedBox(
                                            height: 50,
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) =>
                                                  InkWell(
                                                onTap: () =>
                                                    cubit.changeColors(index),
                                                child: buildColorItem(
                                                    context, index),
                                              ),
                                              separatorBuilder:
                                                  (context, index) => Container(
                                                width: 5,
                                              ),
                                              itemCount: cubit.colorItem.length,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          const Text(
                                            'Chose range price',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          RangeSlider(
                                            min: 3000.0,
                                            max: 300000.0,
                                            values: cubit.values,
                                            divisions: 30,
                                            activeColor: Colors.orange,
                                            onChanged: (newValue) {
                                              cubit.changeSlider(newValue);
                                            },
                                            labels: RangeLabels(
                                              '${cubit.values.start}',
                                              '${cubit.values.end}',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            IconBroken.Filter,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Searched Cars',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (searchController.text.trim().isEmpty ||
                            searchController == null)
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('cars')
                                .where("seats",
                                    isEqualTo:
                                        cubit.seats[cubit.isSeatSelected])
                                .where("isManual",
                                    isEqualTo: cubit.isManualSelected)
                                .where("isDiesel",
                                    isEqualTo:
                                        cubit.fuelType[cubit.isFuelSelected] ==
                                                'Diesel'
                                            ? true
                                            : false)
                                .where("color",
                                    isEqualTo:
                                        cubit.colorMap[cubit.isSelectedColor])
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
                                        "No Searched Cars",
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
                                              if (double.parse(
                                                          carModel.price!) >
                                                      cubit.values.start &&
                                                  double.parse(
                                                          carModel.price!) <
                                                      cubit.values.end) {
                                                return Row(
                                                  children: [
                                                    if (snapshot.data!.docs
                                                            .length <=
                                                        1)
                                                      const SizedBox(width: 30),
                                                    SizedBox(
                                                      width: 350.0,
                                                      child: SearchCarCard(
                                                        carModel: carModel,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                  ],
                                                );
                                              } else {
                                                return Container();
                                              }
                                            })
                                            .toList()
                                            .cast(),
                                      ),
                                    );
                            },
                          ),
                        if (searchController.text.trim().isNotEmpty &&
                            searchController != null)
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('cars')
                                .where('branch',
                                    isGreaterThanOrEqualTo:
                                        searchController.text.trim())
                                .where('branch',
                                    isLessThan:
                                        searchController.text.trim() + 'z')
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
                                        "No Searched Cars",
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
                                                    child: SearchCarCard(
                                                      carModel: carModel,
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
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildColorItem(context, index) {
    var cubit = MainCubit.get(context);
    return CircleAvatar(
      backgroundColor: cubit.colorItem[index],
      radius: 22,
      child: Icon(cubit.isSelectedColor == index ? Icons.check : null,
          color: cubit.isSelectedColor == 3 ? Colors.black : Colors.white),
    );
  }
}

Widget buildBrands(context, index) {
  var cubit = MainCubit.get(context);
  return SizedBox(
    height: 100,
    width: 100,
    child: Card(
      color: cubit.isBrandIconSelected == index
          ? Colors.amber.shade200
          : Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 3,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            width: 50,
            child: SvgPicture.network(
              cubit.brandsIcons[index],
              fit: BoxFit.fill,
              color: Colors.cyan,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(cubit.brandsLabel[index]),
        ],
      ),
    ),
  );
}

Widget buildTopCars(context, index) {
  var cubit = MainCubit.get(context);
  return Padding(
    padding: const EdgeInsets.only(top: 10, right: 17),
    child: InkWell(
      onTap: () {
        // navigateTo(context, MorePayingScreen());
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
                    'CarName : ${cubit.favourite[index].carName}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Price : ${cubit.favourite[index].price} \$',
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
              cubit.favourite[index].urlImage,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 10,
            left: 270,
            child: IconButton(
              padding: EdgeInsets.zero,
              alignment: Alignment.topRight,
              onPressed: () {
                cubit.changeFavourite(index);
              },
              icon: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade300,
                child: Icon(
                  cubit.favourite[index].isFavourted
                      ? Icons.favorite
                      : Icons.favorite_outline,
                  size: 25,
                  color: cubit.favourite[index].isFavourted
                      ? Colors.red
                      : Colors.black38,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class SearchCarCard extends StatefulWidget {
  const SearchCarCard({
    Key? key,
    required this.carModel,
  }) : super(key: key);

  final CarModel carModel;

  @override
  _SearchCarCardState createState() => _SearchCarCardState();
}

class _SearchCarCardState extends State<SearchCarCard> {
  bool isFavorite = false;
  Future<void> toggleFavorite() async {
    if (isFavorite == true) {
      MainCubit.get(context).deleteFromFavorites(widget.carModel);
    } else {
      MainCubit.get(context).addToFavorites(widget.carModel);
    }
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
              used: widget.carModel.isUsed!,
            ),
          );
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
                onPressed: toggleFavorite,
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
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: widget.carModel.isOffered == true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price: ${widget.carModel.price!} \$",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Offer: ${widget.carModel.priceAfterOffer!} \$",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        "Price: ${widget.carModel.price!} \$",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
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
