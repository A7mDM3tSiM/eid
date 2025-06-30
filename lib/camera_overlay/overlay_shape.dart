import 'package:flutter/material.dart';

import 'overlay_model.dart';

class OverlayShape extends StatelessWidget {
  const OverlayShape(this.model, {Key? key}) : super(key: key);

  final OverlayModel model;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context);
    var size = media.size;
    double width = media.orientation == Orientation.portrait
        ? size.shortestSide * .9
        : size.longestSide * .5;

    double ratio = model.ratio as double;
    double height = width / ratio;
    double radius =
        model.cornerRadius == null ? 0 : model.cornerRadius! * height;
    if (media.orientation == Orientation.portrait) {}
    return cameraOverlay(
        color: Colors.black54, aspectRatio: ratio, padding: 20, radius: radius);
  }
}

Widget cameraOverlay(
    {required double padding,
    required double aspectRatio,
    required double radius,
    required Color color}) {
  return LayoutBuilder(builder: (context, constraints) {
    double parentAspectRatio = constraints.maxWidth / constraints.maxHeight;
    double horizontalPadding;
    double verticalPadding;

    if (parentAspectRatio < aspectRatio) {
      horizontalPadding = padding;
      verticalPadding = (constraints.maxHeight -
              ((constraints.maxWidth - 2 * padding) / aspectRatio)) /
          2;
    } else {
      verticalPadding = padding;
      horizontalPadding = (constraints.maxWidth -
              ((constraints.maxHeight - 2 * padding) * aspectRatio)) /
          2;
    }
    return Stack(fit: StackFit.expand, children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: horizontalPadding,
            decoration: BoxDecoration(
              color: color,
            ),
          )),
      Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: horizontalPadding,
            decoration: BoxDecoration(
              color: color,
            ),
          )),
      Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(
                left: horizontalPadding, right: horizontalPadding),
            height: verticalPadding,
            decoration: BoxDecoration(
              color: color,
            ),
          )),
      Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(
                left: horizontalPadding, right: horizontalPadding),
            height: verticalPadding,
            decoration: BoxDecoration(
              color: color,
            ),
          )),
      ColorFiltered(
          colorFilter: ColorFilter.mode(color, BlendMode.srcOut),
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(width: 20, color: Colors.greenAccent)),
          ))
    ]);
  });
}
