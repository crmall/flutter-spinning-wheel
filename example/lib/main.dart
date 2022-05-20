import 'dart:async';
import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinning_wheel/flutter_spinning_wheel.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: Color(0xffB0F9D2),
              child: InkWell(
                  child: Center(child: Text('B A S I C')),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Basic()),
                    );
                  }),
            ),
          ),
          Expanded(
            child: Container(
              color: Color(0xffDDC3FF),
              child: InkWell(
                  child: Center(child: Text('R O U L E T T E')),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Roulette()),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavigationButton({String text, Function onPressedFn}) {
    return FlatButton(
      color: Color.fromRGBO(255, 255, 255, 0.3),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      onPressed: onPressedFn,
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
    );
  }
}

enum CircleAlignment {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class QuarterCircle extends StatelessWidget {
  final CircleAlignment circleAlignment;
  final Color color;

  const QuarterCircle({
    this.color = Colors.grey,
    this.circleAlignment = CircleAlignment.topLeft,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRect(
        child: CustomPaint(
          painter: QuarterCirclePainter(
            circleAlignment: circleAlignment,
            color: color,
          ),
        ),
      ),
    );
  }
}

class QuarterCirclePainter extends CustomPainter {
  final CircleAlignment circleAlignment;
  final Color color;

  const QuarterCirclePainter({this.circleAlignment, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.height, size.width);
    final offset = circleAlignment == CircleAlignment.topLeft
        ? Offset(.0, .0)
        : circleAlignment == CircleAlignment.topRight
            ? Offset(size.width, .0)
            : circleAlignment == CircleAlignment.bottomLeft
                ? Offset(.0, size.height)
                : Offset(size.width, size.height);
    canvas.drawCircle(offset, radius, Paint()..color = color);
  }

  @override
  bool shouldRepaint(QuarterCirclePainter oldDelegate) {
    return color == oldDelegate.color && circleAlignment == oldDelegate.circleAlignment;
  }
}

class Basic extends StatelessWidget {
  final StreamController _dividerController = StreamController<int>();
  final SpinningWheelController _spinController = SpinningWheelController();

  dispose() {
    _dividerController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xffB0F9D2), elevation: 0.0),
      backgroundColor: Color(0xffB0F9D2),
      body: GestureDetector(
        onTap: () => _spinController.spin(4000),
        child: Center(
          child: Container(
            width: 310,
            height: 310,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinningWheel.custom(
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: 110,
                      height: 110,
                      color: Color.fromRGBO(math.Random().nextInt(255), math.Random().nextInt(255), math.Random().nextInt(255), 1),
                      child: Text(
                        (index + 1).toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30, backgroundColor: Colors.white),
                      ),
                    ),
                  ),
                  controller: _spinController,
                  width: 310,
                  height: 310,
                  // initialSpinAngle: _generateRandomAngle(),
                  spinResistance: 0.2,
                  onUpdate: _dividerController.add,
                  onEnd: _dividerController.add,
                ),
                // SpinningWheel(
                //   child: Image.asset('assets/images/wheel-6-300.png'),
                //   width: 310,
                //   height: 310,
                //   // initialSpinAngle: _generateRandomAngle(),
                //   spinResistance: 0.2,
                //   dividers: 6,
                //   onUpdate: _dividerController.add,
                //   onEnd: _dividerController.add,
                // ),
                StreamBuilder(
                  stream: _dividerController.stream,
                  builder: (context, snapshot) => snapshot.hasData ? BasicScore(snapshot.data) : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BasicScore extends StatelessWidget {
  final int selected;

  final Map<int, String> labels = {
    1: 'Purple',
    2: 'Magenta',
    3: 'Red',
    4: 'Dark Orange',
    5: 'Light Orange',
    6: 'Yellow',
  };

  BasicScore(this.selected);

  @override
  Widget build(BuildContext context) {
    // return Text('${selected.toString()}', style: TextStyle(fontStyle: FontStyle.italic));
    return Text('${selected.toString()} - ${labels[selected]}', style: TextStyle(fontStyle: FontStyle.italic));
  }
}

class Roulette extends StatelessWidget {
  final StreamController _dividerController = StreamController<int>();
  final SpinningWheelController _spinController = SpinningWheelController();

  dispose() {
    _dividerController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xffDDC3FF), elevation: 0.0),
      backgroundColor: Color(0xffDDC3FF),
      body: Center(
        child: Container(
          width: 310,
          height: 310,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinningWheel(
                child: Image.asset('assets/images/roulette-8-300.png'),
                width: 310,
                height: 310,
                initialSpinAngle: _generateRandomAngle(),
                spinResistance: 0.6,
                canInteractWhileSpinning: false,
                dividers: 8,
                onUpdate: _dividerController.add,
                onEnd: _dividerController.add,
                secondaryImage: Image.asset('assets/images/roulette-center-300.png'),
                secondaryImageHeight: 110,
                secondaryImageWidth: 110,
                controller: _spinController,
              ),
              SizedBox(height: 30),
              StreamBuilder(
                stream: _dividerController.stream,
                builder: (context, snapshot) => snapshot.hasData ? RouletteScore(snapshot.data) : Container(),
              ),
              SizedBox(height: 30),
              new RaisedButton(
                child: new Text("Start"),
                onPressed: () => _spinController.spin(_generateRandomVelocity()),
              )
            ],
          ),
        ),
      ),
    );
  }

  double _generateRandomVelocity() => (Random().nextDouble() * 6000) + 2000;

  double _generateRandomAngle() => Random().nextDouble() * pi * 2;
}

class RouletteScore extends StatelessWidget {
  final int selected;

  final Map<int, String> labels = {
    1: '1000\$',
    2: '400\$',
    3: '800\$',
    4: '7000\$',
    5: '5000\$',
    6: '300\$',
    7: '2000\$',
    8: '100\$',
  };

  RouletteScore(this.selected);

  @override
  Widget build(BuildContext context) {
    return Text('${labels[selected]}', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24.0));
  }
}
