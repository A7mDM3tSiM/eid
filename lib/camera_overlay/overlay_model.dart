enum OverlayOrientation { landscape, portrait }

abstract class OverlayModel {
  ///ratio between maximum allowable lengths of shortest and longest sides
  double? ratio;

  ///ratio between maximum allowable radius and maximum allowable length of shortest side
  double? cornerRadius;

  ///natural orientation for overlay
  OverlayOrientation? orientation;
}

class CardOverlay implements OverlayModel {
  CardOverlay(
      {this.ratio = 1.5,
      this.cornerRadius = 0.66,
      this.orientation = OverlayOrientation.landscape});

  @override
  double? ratio;
  @override
  double? cornerRadius;
  @override
  OverlayOrientation? orientation;

  static byFormat() {
    return CardOverlay(ratio: 1.42, cornerRadius: 0.057);
  }
}
