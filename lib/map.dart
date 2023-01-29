import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/location_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    context.read<MapProvider>().getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<MapProvider>().currentPosition == null) {
      return Container();
    } else {
      return Scaffold(
        body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: context.read<MapProvider>().currentPosition!,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: {
            context.read<MapProvider>().currentPositionMarker!
          },
        ),
      );
    }
  }

}