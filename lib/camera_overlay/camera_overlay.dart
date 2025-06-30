import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'overlay_model.dart';
import 'overlay_shape.dart';
import 'utils.dart';

class CameraOverlay extends StatefulWidget {
  final CameraDescription camera;
  final OverlayModel model;
  final bool flash;
  final void Function(XFile file) onCapture;
  final String? label;
  final String? info;
  final Widget? loadingWidget;
  final EdgeInsets? infoMargin;

  const CameraOverlay({
    required this.onCapture,
    required this.camera,
    required this.model,
    this.flash = false,
    this.label,
    Key? key,
    this.info,
    this.loadingWidget,
    this.infoMargin,
  }) : super(key: key);

  @override
  CameraOverlayState createState() => CameraOverlayState();
}

class CameraOverlayState extends State<CameraOverlay> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<XFile> takePicture() async {
    await _initializeControllerFuture;
    if (!_controller.value.isTakingPicture) {
      return _controller.takePicture();
    }
    throw Exception('A picture is already being captured.');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(color: Colors.black),
              CameraPreview(_controller),
              OverlayShape(widget.model),
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FloatingActionButton(
                    backgroundColor: const Color(0xFF2084d9),
                    child: const Icon(Icons.camera_alt_rounded),
                    onPressed: () async {
                      try {
                        HapticFeedback.vibrate();
                        final XFile picture = await takePicture();
                        final File croppedFile =
                            await cropImage(picture, widget.model);
                        widget.onCapture(XFile(croppedFile.path));
                      } catch (e) {
                        throw ("Image Invalid!");
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(
              child: CircularProgressIndicator()); // Loading spinner
        }
      },
    );
  }
}
