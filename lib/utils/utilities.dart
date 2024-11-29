import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kaamsay/models/task_ad.dart';
import 'package:kaamsay/models/task_category.dart';
import 'package:kaamsay/resources/firebase_repository.dart';
import 'package:provider/provider.dart';

import '/constants/strings.dart';
import '../models/user_model.dart';
import '../providers/task_categories_provider.dart';
import '../providers/user_location_provider.dart';

class Utils {
  static Future<Map<String, dynamic>> getAverageRatingAndCountFromQuerySnapshot(
      TaskAd taskAd) async {
    var data = await FirebaseRepository().getAllJobRatings(
      taskAd.taskId,
    );
    int counter = 0;
    double rating = 0;
    for (var element in data.docs) {
      counter++;
      rating += (element.data() as Map)['ratingForLabourer'];
    }
    return {'rating': rating, 'counter': counter};
  }

  static Future<File?> pickImage(ImageSource imageSource,
      [int quality = 85, double width = 500, double height = 500]) async {
    ImagePicker imagePicker = ImagePicker();
    var pickedFile = await (imagePicker.pickImage(
      source: imageSource,
      imageQuality: quality,
      maxHeight: height,
      maxWidth: width,
    ));
    if (pickedFile == null) return null;
    File imageFile = File(pickedFile.path);
    return await compressImage(imageFile);
  }

  static Future<File> compressImage(File imageToCompress) async {
    print('size: ${imageToCompress.statSync().size}');
    return imageToCompress;
  }

  String constructFCMPayload(String token, String body) {
    return jsonEncode({
      "to": token,
      "notification": {
        "sound": "default",
        "body": body,
        "title": "KaamSay",
        "content_available": true,
        "priority": "high"
      },
      "data": {
        "sound": "default",
        "body": "test body",
        "title": "test title",
        "content_available": true,
        "priority": "high"
      }
    });
  }

  Future<void> sendPushMessage(String? deviceToken, String body) async {
    if (deviceToken == null) {
      return;
    }

    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Authorization': 'key=$SERVER_KEY',
        'Content-Type': 'application/json',
      },
      body: constructFCMPayload(deviceToken, body),
    );
  }

  static void changeStatusBarBrightness(Brightness brightness) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarIconBrightness: brightness, statusBarBrightness: brightness));
  }

  static fetchAndSaveTaskCategories(BuildContext context) async {
    FirebaseRepository firebaseRepository = FirebaseRepository();
    List<TaskCategory> list = await firebaseRepository.getAllTaskCategories();
    var indexOfAll = list.indexWhere((element) => element.name == 'All');
    if (indexOfAll != -1) {
      var all = list.removeAt(indexOfAll);
      list.insert(0, all);
    }
    Provider.of<TaskCategoriesProvider>(context, listen: false)
        .addAllToTaskCategories(list);
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  ///
  static Future<Position> determinePosition(
    BuildContext context,
    UserModel? user, {
    bool addListener = false,
  }) async {
    FirebaseRepository firebaseRepository = FirebaseRepository();
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    if (addListener && user != null) {
      if (!Provider.of<UserLocationProvider>(context, listen: false)
          .isListenerAdded) {
        Geolocator.getPositionStream().listen((event) {
          if (Provider.of<UserLocationProvider>(context, listen: false)
                  .position !=
              null) {
            var pos = Provider.of<UserLocationProvider>(context, listen: false)
                .position!;

            if (Geolocator.distanceBetween(pos.latitude, pos.longitude,
                    event.latitude, event.longitude) >
                500) {
              Provider.of<UserLocationProvider>(context, listen: false)
                  .setPosition(event);
              firebaseRepository.updateLocation(user.uid!, event);
            }
          } else {
            Provider.of<UserLocationProvider>(context, listen: false)
                .setPosition(event);
          }
        });
        Provider.of<UserLocationProvider>(context, listen: false)
            .setListenerAdded(true);
      }
    }
    var pos = await Geolocator.getCurrentPosition();
    if (user == null) {
      Provider.of<UserLocationProvider>(context, listen: false)
          .setPosition(pos);
    }
    return pos;
  }
}
