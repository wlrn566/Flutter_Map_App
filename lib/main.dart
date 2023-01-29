import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/location_provider.dart';
import 'package:flutter_map/map.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MapProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Map'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                if (await checkLocationPermission()) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MapSample())); 
                } else {
                  openAppSettings();
                }
              }, 
              child: Text('map')
            )
          ],
        ),
      ),
    );
  }

  /// 위치 권한 체크
  Future<bool> checkLocationPermission() async {
    var requestStatus = await Permission.location.request(); // 권한 요청
    var status = await Permission.location.status; // 권한 상태

    log("requestStatus ${requestStatus.name}");
    log("status ${status.name}");

    if (status.isGranted) {
      log("isGranted");
      return true;

    } else if (status.isLimited) {
      log("isLimited");
      return true;

    } else if (requestStatus.isPermanentlyDenied || status.isPermanentlyDenied) {
      log("isPermanentlyDenied");
      
      return false;

    } else if (status.isRestricted) {
      log("isRestricted");
      return false;

    } else if (status.isDenied) {
      // 권한 요청 거절
      log("isDenied");
      return false;
      
    } else {
      return false;
    }
  }
}
