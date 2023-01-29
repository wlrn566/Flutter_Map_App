import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider extends ChangeNotifier {

  CameraPosition? currentPosition;
  Marker? currentPositionMarker;

  /// 현재 위치 조회
  Future<void> getCurrentPosition() async {
    log("getCurrentPosition");
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    await Geolocator.getCurrentPosition().then((value) {
      log(value.toString());
      currentPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14.4746,
      );
      currentPositionMarker = Marker(
        markerId: const MarkerId("current"),
        position: LatLng(value.latitude, value.longitude),
      );
    });
    
    notifyListeners();
  }
  
}