import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Pie extends StatelessWidget {
  final List<Widget> children;

  const Pie({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, consts) {
      final emptyPie = (children?.length ?? 0) == 0;
      final hasPieces = (children?.length ?? 0) > 1;
      final size = math.min(consts.maxWidth, consts.maxHeight);
      return Center(
        child: Container(
          width: size,
          height: size,
          clipBehavior: hasPieces ? Clip.none : Clip.antiAlias,
          decoration: hasPieces ? null : BoxDecoration(shape: BoxShape.circle),
          child: hasPieces
              ? Stack(
                  overflow: Overflow.visible,
                  children: [
                    for (var i = 0; i < children.length; i++)
                      Transform.rotate(
                        angle: (360 / children.length * (i + 0.5)) * math.pi / 180,
                        origin: Offset.fromDirection(math.pi / 2, consts.maxWidth / 4),
                        child: AspectRatio(
                          aspectRatio: 2 / 1,
                          child: PiePiece(
                            pieces: children.length,
                            child: children[i],
                          ),
                        ),
                      ),
                  ],
                )
              : emptyPie
                  ? null
                  : children[0],
        ),
      );
    });
  }
}

class PiePiece extends StatelessWidget {
  final Widget child;
  final int pieces;

  const PiePiece({
    Key key,
    this.child,
    this.pieces = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var clipper = PieClipper(pieces);
    return ClipPath(
      clipper: clipper,
      child: child,
    );
  }
}

class PieClipper extends CustomClipper<Path> {
  PieClipper(this.pieces);

  final int pieces;

  @override
  Path getClip(Size size) {
    final radius = size.width / 2;

    var pathArc = Path();
    pathArc.moveTo(.0, size.height);
    pathArc.arcToPoint(Offset(size.width, size.height), radius: Radius.circular(radius));
    pathArc.lineTo(0, size.height);
    pathArc.close();

    if (pieces > 2) {
      var pathTriangle = Path();
      final radians = (2 * math.pi) / pieces;
      final distanceFromCenter = radius * math.tan(radians / 2);
      pathTriangle.moveTo(radius - distanceFromCenter, size.height - radius);
      pathTriangle.lineTo(radius + distanceFromCenter, size.height - radius);
      pathTriangle.lineTo(size.width * 0.5, size.height);
      pathTriangle.close();

      return Path.combine(PathOperation.intersect, pathArc, pathTriangle);
    }

    return pathArc;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    final oldie = oldClipper as PieClipper;
    return pieces != oldie.pieces;
  }
}
