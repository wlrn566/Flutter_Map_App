import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider extends ChangeNotifier {
  Position? currentPosition;
  CameraPosition? currentCameraPosition;
  Marker? currentPositionMarker;

  MapType mapType = MapType.hybrid;
  String mapTypeText = "위성";
  int mapTypeIndex = 0;

  /// 현재 위치 조회
  Future<void> getCurrentPosition() async {
    log("getCurrentPosition");

    await Geolocator.getCurrentPosition().then((value) {
      currentPosition = value;
      currentCameraPosition = CameraPosition(
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

  /// 초기 위치 조회
  Future<Position> getInitialPosition() async {
    log("getInitialPosition");
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    return await Geolocator.getCurrentPosition();
  }

  /// 지도 타입 변경
  void setMapType() {
    if (mapTypeIndex < 2) {
      mapTypeIndex ++;
    } else {
      mapTypeIndex = 0;
    }

    switch (mapTypeIndex) {
      case 0:
        mapType = MapType.normal;
        mapTypeText = "기본";
        break;
      case 1:
        mapType = MapType.terrain;
        mapTypeText = "고도";
        break;
      case 2:
        mapType = MapType.hybrid;
        mapTypeText = "위성";
        break;
    }
    notifyListeners();
  }
  
}