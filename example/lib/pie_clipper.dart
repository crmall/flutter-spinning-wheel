import 'package:example/clip_shadow.dart';
import 'package:flutter/widgets.dart';

enum PieAlignment {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

enum Edge { TOP, RIGHT, BOTTOM, LEFT }

enum ArcType { CONVEY, CONVEX }

class PiePart extends StatelessWidget {
  final Widget child;
  final PieAlignment alignment;
  final int part;
  final int parts;
  final List<ClipShadow> clipShadows;

  const PiePart({Key key, this.child, this.alignment = PieAlignment.topLeft, this.part = 1, this.parts = 4, this.clipShadows = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var clipper = TriangleClipper(0, 0, 0.5, Edge.BOTTOM);
    // return CustomPaint(
    //   painter: ClipShadowPainter(clipper, clipShadows),
    //   child: ClipPath(
    //     clipper: clipper,
    //     child: child,
    //   ),
    // );

    var clipper = PieClipper(PieAlignment.topLeft, 1, 4);
    return CustomPaint(
      painter: ClipShadowPainter(clipper, clipShadows),
      child: ClipPath(
        clipper: clipper,
        child: child,
      ),
    );
  }
}

class PieClipper extends CustomClipper<Path> {
  PieClipper(this.alignment, this.part, this.parts);

  final PieAlignment alignment;
  final int part;
  final int parts;

  @override
  Path getClip(Size size) {
    final side = size.width < size.height ? size.width : size.height;

    // _prevAngle = this.initialAngle * math.pi / 180;
    // for (int i = 0; i < _subParts.length; i++) {
    //   canvas.drawArc(
    //     new Rect.fromLTWH(0.0, 0.0, side, size.height),
    //     _prevAngle,
    //     (((_totalAngle) / _total) * _subParts[i]),
    //     chartType == ChartType.disc ? true : false,
    //     _paintList[i],
    //   );
    //   final radius = showChartValuesOutside ? (side / 2) + 16 : side / 3;
    //   final x = (radius) * math.cos(_prevAngle + ((((_totalAngle) / _total) * _subParts[i]) / 2));
    //   final y = (radius) * math.sin(_prevAngle + ((((_totalAngle) / _total) * _subParts[i]) / 2));
    //   if (_subParts.elementAt(i).toInt() != 0) {
    //     final value =
    //         formatChartValues != null ? formatChartValues(_subParts.elementAt(i)) : _subParts.elementAt(i).toStringAsFixed(this.decimalPlaces);
    //
    //     if (showChartValues) {
    //       final name = showValuesInPercentage ? (((_subParts.elementAt(i) / _total) * 100).toStringAsFixed(this.decimalPlaces) + '%') : value;
    //       _drawName(canvas, name, x, y, side);
    //     }
    //   }
    //   _prevAngle = _prevAngle + (((_totalAngle) / _total) * _subParts[i]);
    // }

    var path = Path();

    final height = 50.0;
    final trianglePercentLeft = 0.0;
    final trianglePercentRight = 0.0;
    final trianglePercentEdge = 0.5;

    // path.moveTo(size.width * trianglePercentLeft, 0.0);
    // path.lineTo(size.width - size.width * trianglePercentRight, 0.0);

    path.moveTo(0.0, height);
    path.quadraticBezierTo(size.width / 4, 0.0, size.width / 2, 0.0);
    path.quadraticBezierTo(size.width * 3 / 4, 0.0, size.width, height);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);

    path.lineTo(size.width * trianglePercentEdge, size.height);

    // path.moveTo(0 * size.width, 0 * size.height);
    // path.lineTo(1 * size.width, 0 * size.height);

    // path.moveTo(size.width - height, 0.0);
    // path.quadraticBezierTo(size.width, size.height / 4, size.width, size.height / 2);
    // path.quadraticBezierTo(size.width, size.height * 3 / 4, size.width - height, size.height);
    // path.lineTo(0.0, size.height);
    // path.lineTo(0.0, 0.0);

    // path.lineTo(0 * size.width, 1 * size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class TriangleClipper extends CustomClipper<Path> {
  TriangleClipper(this.trianglePercentLeft, this.trianglePercentRight, this.trianglePercentEdge, this.edge);

  final double trianglePercentLeft;
  final double trianglePercentRight;
  final double trianglePercentEdge;
  final Edge edge;

  @override
  Path getClip(Size size) {
    switch (edge) {
      case Edge.TOP:
        return _getTopPath(size);
      case Edge.RIGHT:
        return _getRightPath(size);
      case Edge.BOTTOM:
        return _getBottomPath(size);
      case Edge.LEFT:
        return _getLeftPath(size);
      default:
        return _getRightPath(size);
    }
  }

  Path _getTopPath(Size size) {
    var path = Path();
    path.moveTo(trianglePercentLeft * size.width, size.height);
    path.lineTo(size.width - trianglePercentRight * size.width, size.height);
    path.lineTo(size.width * trianglePercentEdge, 0.0);
    path.close();
    return path;
  }

  Path _getRightPath(Size size) {
    var path = Path();
    path.moveTo(0.0, size.height * trianglePercentLeft);
    path.lineTo(0.0, size.height - size.height * trianglePercentRight);
    path.lineTo(size.width, size.height * trianglePercentEdge);
    path.close();
    return path;
  }

  Path _getBottomPath(Size size) {
    var path = Path();
    path.moveTo(size.width * trianglePercentLeft, 0.0);
    path.lineTo(size.width - size.width * trianglePercentRight, 0.0);
    path.lineTo(size.width * trianglePercentEdge, size.height);
    path.close();
    return path;
  }

  Path _getLeftPath(Size size) {
    var path = Path();
    path.moveTo(0.0, size.height * trianglePercentEdge);
    path.lineTo(size.width, size.height * trianglePercentLeft);
    path.lineTo(size.width, size.height - size.height * trianglePercentRight);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    TriangleClipper oldie = oldClipper as TriangleClipper;
    return trianglePercentLeft != oldie.trianglePercentLeft ||
        trianglePercentRight != oldie.trianglePercentRight ||
        trianglePercentEdge != oldie.trianglePercentEdge ||
        edge != oldie.edge;
  }
}

class ArcClipper extends CustomClipper<Path> {
  ArcClipper(this.height, this.edge, this.arcType);

  ///The height of the arc
  final double height;

  ///The edge of the widget which clipped as arc
  final Edge edge;

  ///The type of arc which can be [ArcType.CONVEX] or [ArcType.CONVEY]
  final ArcType arcType;

  @override
  Path getClip(Size size) {
    switch (edge) {
      case Edge.TOP:
        return _getTopPath(size);
      case Edge.RIGHT:
        return _getRightPath(size);
      case Edge.BOTTOM:
        return _getBottomPath(size);
      case Edge.LEFT:
        return _getLeftPath(size);
      default:
        return _getRightPath(size);
    }
  }

  Path _getBottomPath(Size size) {
    var path = Path();
    if (arcType == ArcType.CONVEX) {
      path.lineTo(0.0, size.height - height);
      //Adds a quadratic bezier segment that curves from the current point
      //to the given point (x2,y2), using the control point (x1,y1).
      path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height);
      path.quadraticBezierTo(size.width * 3 / 4, size.height, size.width, size.height - height);

      path.lineTo(size.width, 0.0);
    } else {
      path.moveTo(0.0, size.height);
      path.quadraticBezierTo(size.width / 4, size.height - height, size.width / 2, size.height - height);
      path.quadraticBezierTo(size.width * 3 / 4, size.height - height, size.width, size.height);
      path.lineTo(size.width, 0.0);
      path.lineTo(0.0, 0.0);
    }
    path.close();

    return path;
  }

  Path _getTopPath(Size size) {
    var path = Path();
    if (arcType == ArcType.CONVEX) {
      path.moveTo(0.0, height);

      path.quadraticBezierTo(size.width / 4, 0.0, size.width / 2, 0.0);
      path.quadraticBezierTo(size.width * 3 / 4, 0.0, size.width, height);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
    } else {
      path.quadraticBezierTo(size.width / 4, height, size.width / 2, height);
      path.quadraticBezierTo(size.width * 3 / 4, height, size.width, 0.0);
      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
    }
    path.close();

    return path;
  }

  Path _getLeftPath(Size size) {
    var path = Path();
    if (arcType == ArcType.CONVEX) {
      path.moveTo(height, 0.0);

      path.quadraticBezierTo(0.0, size.height / 4, 0.0, size.height / 2);
      path.quadraticBezierTo(0.0, size.height * 3 / 4, height, size.height);

      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
    } else {
      path.quadraticBezierTo(height, size.height / 4, height, size.height / 2);
      path.quadraticBezierTo(height, size.height * 3 / 4, 0.0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
    }
    path.close();

    return path;
  }

  Path _getRightPath(Size size) {
    var path = Path();
    if (arcType == ArcType.CONVEX) {
      path.moveTo(size.width - height, 0.0);

      path.quadraticBezierTo(size.width, size.height / 4, size.width, size.height / 2);
      path.quadraticBezierTo(size.width, size.height * 3 / 4, size.width - height, size.height);

      path.lineTo(0.0, size.height);
      path.lineTo(0.0, 0.0);
    } else {
      path.moveTo(size.width, 0.0);
      path.quadraticBezierTo(size.width - height, size.height / 4, size.width - height, size.height / 2);
      path.quadraticBezierTo(size.width - height, size.height * 3 / 4, size.width, size.height);
      path.lineTo(0.0, size.height);
      path.lineTo(0.0, 0.0);
    }
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    ArcClipper oldie = oldClipper as ArcClipper;
    return height != oldie.height || arcType != oldie.arcType || edge != oldie.edge;
  }
}
