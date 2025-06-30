import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'overlay_model.dart';

Future<File> cropImage(XFile file, OverlayModel model) async {
  final img.Image capturedImage = img.decodeImage(await file.readAsBytes())!;
  final OverlayModel overlayModel = model;

  final double aspectRatio = overlayModel.ratio!;
  final double width =
      min(capturedImage.width.toDouble(), capturedImage.height / aspectRatio);
  final double height = width / aspectRatio;
  final int originX = ((capturedImage.width - width) / 2).round();
  final int originY = ((capturedImage.height - height) / 2).round();
  final img.Image croppedImage = img.copyCrop(capturedImage,
      x: originX, y: originY, width: width.round(), height: height.round());
  final Directory directory = await getApplicationDocumentsDirectory();
  final String fileName =
      'cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';
  final String filePath = '${directory.path}/$fileName';
  final File newImageFile = File(filePath)
    ..writeAsBytesSync(img.encodeJpg(croppedImage));

  return newImageFile;
}
