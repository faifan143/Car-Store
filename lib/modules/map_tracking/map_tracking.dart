import 'package:carent/layout/cubit/cubit.dart';
import 'package:carent/layout/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MapTracking extends StatelessWidget {
  const MapTracking({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = MainCubit.get(context);
        return ModalProgressHUD(
          inAsyncCall: cubit.isLoading,
          child: Scaffold(
            body: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(cubit.currentPosition.latitude!,
                        cubit.currentPosition.longitude!),
                    zoom: 13.5,
                  ),
                  onMapCreated: (mapController) {
                    cubit.gmapsController.complete(mapController);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
