import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motors_app/core/env.dart';
import 'package:motors_app/core/utils/images_util/image_utils.dart';

class ImagePickerService extends ChangeNotifier {
  final List<File> _listImages = [];

  List<File> get listImages => _listImages;

  Future<void> pickImages() async {
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      for (var element in images) {
        _listImages.add(File(element.path));
      }
    }

    notifyListeners();
  }

  Future<void> deleteImage(File path) async {
    _listImages.remove(path);

    notifyListeners();
  }

  Future<void> openCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      _listImages.add(File(photo.path));
    }

    notifyListeners();
  }

  Future<void> addImageNetworkToList(value) async {
    final file = await urlToFile(value);

    _listImages.add(file);

    notifyListeners();
  }

  void clearImages() {
    _listImages.clear();
    notifyListeners();
  }
}
