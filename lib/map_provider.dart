import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider extends ChangeNotifier {

  MapType mapType = MapType.hybrid;
  String mapTypeText = "위성";
  int mapTypeIndex = 0;

  /// 현재 위치 조회
  Future<Position> getCurrentPosition() async {
    log("getCurrentPosition");
    return await Geolocator.getCurrentPosition();
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

  void addMarker(List<Marker> markers, Marker addMarker) {
    markers.add(addMarker);
    notifyListeners();
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