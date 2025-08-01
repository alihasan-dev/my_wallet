import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_wallet/constants/app_color.dart';
import 'package:my_wallet/utils/helper.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService with Helper {

  final BuildContext context;
  
  LocationService(this.context);
  
  Future<LocationPermission> _checkLocationPermission() async {
    if (kIsWeb) {
      return await Geolocator.checkPermission();
    } else if (Platform.isAndroid) {
      var status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return LocationPermission.whileInUse;
      } 
      return LocationPermission.denied;
    } else if (Platform.isIOS) {
      throw Exception('Not yet implemented');
    } else {
      throw Exception('Unsupported platform');
    }
  }

  Future<String> getCurrentAddress() async {
    try {
      final LocationPermission permission = await _checkLocationPermission();
      switch (permission) {
        case LocationPermission.whileInUse:
          final LocationSettings locationSettings = LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 100
          );
          Position position = await Geolocator.getCurrentPosition();
          var placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
          if (placemark.isNotEmpty) {
            var local = placemark[1];
            var address = '${local.subLocality}, ${local.locality} - ${local.postalCode}, ${local.administrativeArea}, ${local.country}';
            return address;
          }
          return 'N/A';
        default:
          throw Exception('Permission denied to access the location');
      }
      
    } catch(e) {
      final message = e.toString();
      showSnackBar(context: context, title: message.replaceAll('Exception: ', ''), color: AppColors.red);
      return '';
    }
  }
}