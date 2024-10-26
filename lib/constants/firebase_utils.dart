import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:lexyom/extensions/num_extensions.dart';

import '../controllers/home_controllers.dart';
import 'ApiEndPoint.dart';
class FirebaseUtils {
  static Future<String> uploadImage(
      String filePath, String firebasePathWithFilename,
      {Function(String url)? onSuccess,
      Function(String error)? onError,
      Function(double progress)? onProgress}) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child(firebasePathWithFilename);
    final UploadTask uploadTask = storageReference.putFile(File(filePath));

    uploadTask.snapshotEvents.listen((event) {
      double progress =
          event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      if (onProgress != null) {
        onProgress(progress.roundToNum(2));
      }
    }).onError((error) {
      // do something to handle error
      if (onError != null) {
        onError(error.toString());
      }
    });

    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = await downloadUrl.ref.getDownloadURL();
    if (onSuccess != null) {
      print(url);
      onSuccess(url);
    }
    return url;
  }

  static Future<List<String>> uploadMultipleImage(
      List<String> imagesPaths, String firebasePathWithFilenameWithoutExtension,
      {Function(int which, double progress)? onProgress,
      required String extension}) async {
    if (imagesPaths.isEmpty) {
      return [];
    }

    List<String> urls = [];

    await Future.forEach(imagesPaths, (String path) async {
      int index = imagesPaths.indexOf(path);
      var url = await uploadImage(path,
          "${firebasePathWithFilenameWithoutExtension}_${index}.$extension",
          onProgress: (progress) {
        if (onProgress != null) {
          onProgress(index, progress);
        }
      });
      urls.add(url);
    });

    return urls;
  }

  static String get myId =>
      Get.find<ControllerHome>().user.value!.user.information.id.toString();

  static int get myIntId =>
      Get.find<ControllerHome>().user.value!.user.information.id;

  static String get myName =>
      Get.find<ControllerHome>().user.value!.user.information.name.toString();

  static String get myToken => Get.find<ControllerHome>()
      .user
      .value!
      .user
      .information
      .deviceToken
      .toString();

  static String get myImage =>
      "${AppEndPoint.userProfile}${Get.find<ControllerHome>().user.value!.user.information.profile}";

  static int get newId => DateTime.now().millisecondsSinceEpoch;
}
