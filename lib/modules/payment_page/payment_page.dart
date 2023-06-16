import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocConsumer;
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/componants/componants.dart';
import '../../shared/styles/icon_brokin.dart';
import '../notification/notification_screen.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = MainCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    ZoomDrawer.of(context)!.toggle();
                  },
                  icon: const Icon(
                    IconBroken.Category,
                  ),
                ),
                centerTitle: true,
                elevation: 0.0,
                backgroundColor: Colors.white,
                title: Text(cubit.titles[cubit.currentIndex]),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        navigateTo(context, const NotificationScreen());
                      },
                      icon: const Icon(
                        IconBroken.Notification,
                      ),
                    ),
                  )
                ],
              ),
              body: cubit.screens[cubit.currentIndex],
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GNav(
                    onTabChange: (index) {
                      cubit.changeBottomNavBar(index);
                    },
                    selectedIndex: cubit.currentIndex,
                    gap: 8,
                    padding: const EdgeInsets.all(8),
                    activeColor: Colors.white,
                    tabBackgroundColor: Colors.black,
                    tabs: const [
                      GButton(
                        icon: IconBroken.Home,
                        text: 'Home',
                      ),
                      GButton(
                        icon: IconBroken.Search,
                        text: 'Search',
                      ),
                      GButton(
                        icon: IconBroken.Heart,
                        text: 'Favorites',
                      ),
                      GButton(
                        icon: IconBroken.Chart,
                        text: 'Offers',
                      ),
                      GButton(
                        icon: IconBroken.Profile,
                        text: 'Profile',
                      )
                    ]),
              ));
        });
  }
}
