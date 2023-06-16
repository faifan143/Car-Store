import 'package:carent/models/siginup_model/users_model.dart';
import 'package:carent/shared/componants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/styles/icon_brokin.dart';

class RetScreen extends StatelessWidget {
  RetScreen({super.key});

  var contentsInfo = const TextStyle(
      fontWeight: FontWeight.normal, fontSize: 15, color: Colors.black45);

  late TextEditingController postTextController =
      TextEditingController(text: '');

  final _postFormKey = GlobalKey<FormState>();

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        UsersModel userModel = Constants.usersModel!;
        return Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0,
              title: IconButton(
                onPressed: () {
                  ZoomDrawer.of(context)!.toggle();
                },
                icon: const Icon(
                  IconBroken.Arrow___Left_2,
                  color: Colors.black,
                  size: 25,
                ),
              )),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 75,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
