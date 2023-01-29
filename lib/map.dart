import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/map_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late GoogleMapController _mapController;
  CameraPosition? initialCameraPosition;
  Marker? initialPositionMarker;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   initialCameraPosition = const CameraPosition(
    //     target: LatLng(37.43263980495858, -122.09192861197333),
    //     zoom: 14.4746,
    //   );
    //   initialPositionMarker = const Marker(
    //     markerId:  MarkerId("current"),
    //     position: LatLng(37.43263980495858, -122.09192861197333),
    //   );
    // });
    context.read<MapProvider>().getInitialPosition().then((value) {
      initialCameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14.4746,
      );
      initialPositionMarker = Marker(
        markerId:  MarkerId("current"),
        position: LatLng(value.latitude, value.longitude),
      );
      log("initial position : $value");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MapProvider>(
        builder: (BuildContext context, _, Widget? child) {
          return Stack(
            children: [
              GoogleMap(
                mapType: _.mapType,
                initialCameraPosition: initialCameraPosition!,
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    _mapController = controller;
                  });
                },
                markers: {
                  initialPositionMarker!
                },
              ),
              Positioned(
                top: 30,
                right: 10,
                child: ElevatedButton(
                  onPressed: () {
                    _.setMapType();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // 주색상
                    fixedSize: Size(50, 30),
                  ),
                  child: Text(_.mapTypeText),
                )
              ),
              Positioned(
                bottom: 30,
                left: 10,
                child: FloatingActionButton(
                  onPressed: () {
                    _mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(_.currentPosition!.latitude, _.currentPosition!.longitude),
                          zoom: 15
                        )
                      )
                    );
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.gps_fixed, color: Colors.black, size: 30),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}