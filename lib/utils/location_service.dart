import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/app_color.dart';
import '../utils/app_extension_method.dart';
import '../utils/helper.dart';

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
          Position position = await Geolocator.getCurrentPosition();
          var placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
          if (placemark.isNotEmpty) {
            var local = placemark[1];
            String address = '';
            if (!(local.subLocality ?? '').isBlank) {
              address = local.subLocality!;
            }
            if (!(local.locality ?? '').isBlank) {
              address = address.isBlank ? local.locality! : '$address, ${local.locality}';
            }
            if (!(local.postalCode ?? '').isBlank) {
              address = address.isBlank 
              ? local.postalCode!
              : (local.locality ?? '').isBlank
                ? '$address, ${local.postalCode}'
                : '$address - ${local.postalCode}';
            }
            if (!(local.administrativeArea ?? '').isBlank) {
              address = address.isBlank ? local.administrativeArea! : '$address, ${local.administrativeArea}';
            }
            if (!(local.country ?? '').isBlank) {
              address = address.isBlank ? local.country! : '$address, ${local.country}';
            }
            return address;
          }
          return '';
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