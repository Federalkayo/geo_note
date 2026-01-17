import 'dart:async'; 

import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<bool> checkAndRequestPermission() async {
    try {
      // Check and request location service
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return false;
      }

      // Check and request permission
      PermissionStatus permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        if (permission != PermissionStatus.granted) return false;
      }

      // Handle permanently denied case
      if (permission == PermissionStatus.deniedForever) {
        return false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<LocationData?> getCurrentPosition() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return null;

      // Configure location settings – use a valid enum value
      await _location.changeSettings(
        accuracy: LocationAccuracy.balanced,  
        interval: 10000,                      
         distanceFilter: 0,                 
      );

      // Get location with timeout protection
      final locationData = await _location.getLocation().timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('Location request timed out'),
      );

      return locationData;
    } on TimeoutException {
      return null;
    } catch (e) {
      // log the error for debugging
       print('Location error: $e');
      return null;
    }
  }

  String getPermissionMessage(bool? hasPermission) {
    if (hasPermission == null) {
      return "Could not determine location status";
    }
    if (!hasPermission) {
      return "Location permission denied.\nPlease enable it in your device settings.";
    }
    return "";
  }
}