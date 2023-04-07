import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class VibeBar extends StatefulWidget {
  const VibeBar({super.key});

  @override
  State<VibeBar> createState() => _VibeBarState();
}

class _VibeBarState extends State<VibeBar> {
  bool toggle = false;

  void addVibe() {
    setState(() {
      toggle ? toggle = false : toggle = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      width: width - 10,
      height: height,
      bottom: toggle ? -height / 4 : 0,
      left: 5,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: width * 0.24,
                child: Stack(children: <Widget>[
                  Positioned(
                    bottom: height * .014,
                    left: width / 2 - width / 9,
                    child: ClipOval(
                        // TODO: Make this have cool blur effect in background
                        child: Container(
                          width: width / 5,
                          height: width / 5,
                          color: Colors.white.withOpacity(.7),
                          child: IconButton(
                            onPressed: addVibe,
                            // TODO: Figure out how to smoothly animate
                            icon: Transform.rotate(
                              angle: toggle ? 0 : math.pi / 4,
                              child: CustomPaint(
                                size: Size(width / 6, width / 6),
                                painter: AddVibeIcon(),
                          ),
                            )),
                    )),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: width * 0.24,
                    child: IgnorePointer(
                      ignoring: true,
                      child: CustomPaint(
                        painter: BottomBarShape(),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
          Container(
              height: height / 4,
              width: width - 10,
              color: Colors.white,
              child: Stack(children: <Widget>[
                Positioned(
                  left: width * .05 - 5,
                  width: width * .9,
                  height: height / 4 - 20,
                  child: Material(
                    child: TextField(
                      // TODO: make this have a cool blur effect in the background
                      decoration: InputDecoration(
                        hintText: "Share your message with the world!",
                        filled: true,
                        fillColor: const Color(0xF8F8F8FF),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide( width: 0.0, color: Colors.white ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide( width: 0.0, color: Colors.white ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide( width: 0.0, color: Colors.white ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide( width: 0.0, color: Colors.white ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      minLines: 7,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                )
              ]))
        ],
      ),
    );
  }
}

class BottomBarShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.0002347418, size.height * 0.9990741);
    path_0.cubicTo(
        size.width * 0.006338028,
        size.height * 0.9185185,
        size.width * 0.02276995,
        size.height * 0.8527778,
        size.width * 0.04413146,
        size.height * 0.8296296);
    path_0.lineTo(size.width * 0.3122066, size.height * 0.5388889);
    path_0.arcToPoint(Offset(size.width * 0.3946009, size.height * 0.2657407),
        radius:
            Radius.elliptical(size.width * 0.1286385, size.height * 0.5074074),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.arcToPoint(Offset(size.width * 0.6061033, size.height * 0.2657407),
        radius:
            Radius.elliptical(size.width * 0.1169014, size.height * 0.4611111),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.arcToPoint(Offset(size.width * 0.6884977, size.height * 0.5379630),
        radius:
            Radius.elliptical(size.width * 0.1286385, size.height * 0.5074074),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.9462441, size.height * 0.8157407);
    path_0.arcToPoint(Offset(size.width * 0.9997653, size.height * 0.9990741),
        radius:
            Radius.elliptical(size.width * 0.08169014, size.height * 0.3222222),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.lineTo(size.width * 0.0002347418, size.height * 0.9990741);
    path_0.close();
    path_0.moveTo(size.width * 0.5002347, size.height * 0.06944444);
    path_0.arcToPoint(Offset(size.width * 0.5002347, size.height * 0.8537037),
        radius:
            Radius.elliptical(size.width * 0.09929577, size.height * 0.3916667),
        rotation: 0,
        largeArc: true,
        clockwise: false);
    path_0.arcToPoint(Offset(size.width * 0.5002347, size.height * 0.06944444),
        radius:
            Radius.elliptical(size.width * 0.09929577, size.height * 0.3916667),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffffffff).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AddVibeIcon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.6991279, size.height * 0.4702467);
    path_0.arcToPoint(Offset(size.width * 0.6991279, size.height * 0.5297533),
        radius: Radius.elliptical(
            size.width * 0.02906977, size.height * 0.02902758),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.lineTo(size.width * 0.5566860, size.height * 0.5297533);
    path_0.cubicTo(
        size.width * 0.5494186,
        size.height * 0.5297533,
        size.width * 0.5421512,
        size.height * 0.5268505,
        size.width * 0.5363372,
        size.height * 0.5210450);
    path_0.lineTo(size.width * 0.4796512, size.height * 0.4644412);
    path_0.cubicTo(
        size.width * 0.4738372,
        size.height * 0.4586357,
        size.width * 0.4709302,
        size.height * 0.4513788,
        size.width * 0.4709302,
        size.height * 0.4426705);
    path_0.lineTo(size.width * 0.4709302, size.height * 0.3004354);
    path_0.arcToPoint(Offset(size.width * 0.5290698, size.height * 0.3004354),
        radius: Radius.elliptical(
            size.width * 0.02906977, size.height * 0.02902758),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.lineTo(size.width * 0.5290698, size.height * 0.4281567);
    path_0.lineTo(size.width * 0.5319767, size.height * 0.4325109);
    path_0.lineTo(size.width * 0.5683140, size.height * 0.4687954);
    path_0.lineTo(size.width * 0.5726744, size.height * 0.4702467);
    path_0.lineTo(size.width * 0.6991279, size.height * 0.4702467);
    path_0.close();
    path_0.moveTo(size.width * 0.05232558, size.height * 0.6197388);
    path_0.arcToPoint(Offset(size.width * 0.05232558, size.height * 0.3802612),
        radius:
            Radius.elliptical(size.width * 0.1627907, size.height * 0.1625544),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.lineTo(size.width * 0.05377907, size.height * 0.3831640);
    path_0.lineTo(size.width * 0.06540698, size.height * 0.4194485);
    path_0.lineTo(size.width * 0.07412791, size.height * 0.4484761);
    path_0.arcToPoint(Offset(size.width * 0.09447674, size.height * 0.5776488),
        radius:
            Radius.elliptical(size.width * 0.1031977, size.height * 0.1030479),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.1235465, size.height * 0.6023222);
    path_0.cubicTo(
        size.width * 0.1744186,
        size.height * 0.6473149,
        size.width * 0.2093023,
        size.height * 0.7082729,
        size.width * 0.2223837,
        size.height * 0.7750363);
    path_0.lineTo(size.width * 0.2238372, size.height * 0.7764877);
    path_0.lineTo(size.width * 0.1875000, size.height * 0.7692308);
    path_0.cubicTo(
        size.width * 0.1773256,
        size.height * 0.7677794,
        size.width * 0.1656977,
        size.height * 0.7634253,
        size.width * 0.1569767,
        size.height * 0.7576197);
    path_0.arcToPoint(Offset(size.width * 0.08430233, size.height * 0.6473149),
        radius:
            Radius.elliptical(size.width * 0.2543605, size.height * 0.2539913),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.05523256, size.height * 0.6226415);
    path_0.lineTo(size.width * 0.05232558, size.height * 0.6197388);
    path_0.close();
    path_0.moveTo(size.width * 0.1729651, size.height * 0.1727141);
    path_0.arcToPoint(Offset(size.width * 0.3808140, size.height * 0.05370102),
        radius:
            Radius.elliptical(size.width * 0.1627907, size.height * 0.1625544),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.lineTo(size.width * 0.3779070, size.height * 0.05660377);
    path_0.lineTo(size.width * 0.3531977, size.height * 0.08417997);
    path_0.lineTo(size.width * 0.3313953, size.height * 0.1059507);
    path_0.arcToPoint(Offset(size.width * 0.2311047, size.height * 0.1886792),
        radius:
            Radius.elliptical(size.width * 0.1031977, size.height * 0.1030479),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.2223837, size.height * 0.2264151);
    path_0.cubicTo(
        size.width * 0.2093023,
        size.height * 0.2917271,
        size.width * 0.1744186,
        size.height * 0.3526851,
        size.width * 0.1235465,
        size.height * 0.3976778);
    path_0.lineTo(size.width * 0.1220930, size.height * 0.3991292);
    path_0.lineTo(size.width * 0.1104651, size.height * 0.3642961);
    path_0.cubicTo(
        size.width * 0.1075581,
        size.height * 0.3541364,
        size.width * 0.1046512,
        size.height * 0.3425254,
        size.width * 0.1046512,
        size.height * 0.3323657);
    path_0.arcToPoint(Offset(size.width * 0.1642442, size.height * 0.2133527),
        radius:
            Radius.elliptical(size.width * 0.2558140, size.height * 0.2554427),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.1715116, size.height * 0.1770682);
    path_0.lineTo(size.width * 0.1729651, size.height * 0.1727141);
    path_0.close();
    path_0.moveTo(size.width * 0.6206395, size.height * 0.05370102);
    path_0.arcToPoint(Offset(size.width * 0.8270349, size.height * 0.1727141),
        radius:
            Radius.elliptical(size.width * 0.1627907, size.height * 0.1625544),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.lineTo(size.width * 0.8241279, size.height * 0.1727141);
    path_0.lineTo(size.width * 0.7863372, size.height * 0.1654572);
    path_0.lineTo(size.width * 0.7572674, size.height * 0.1567489);
    path_0.arcToPoint(Offset(size.width * 0.6351744, size.height * 0.1117562),
        radius:
            Radius.elliptical(size.width * 0.1031977, size.height * 0.1030479),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.5988372, size.height * 0.1233672);
    path_0.cubicTo(
        size.width * 0.5348837,
        size.height * 0.1451379,
        size.width * 0.4651163,
        size.height * 0.1451379,
        size.width * 0.4011628,
        size.height * 0.1233672);
    path_0.lineTo(size.width * 0.3982558, size.height * 0.1219158);
    path_0.lineTo(size.width * 0.4229651, size.height * 0.09579100);
    path_0.cubicTo(
        size.width * 0.4302326,
        size.height * 0.08708273,
        size.width * 0.4389535,
        size.height * 0.07982583,
        size.width * 0.4491279,
        size.height * 0.07402032);
    path_0.arcToPoint(Offset(size.width * 0.5799419, size.height * 0.06676343),
        radius:
            Radius.elliptical(size.width * 0.2558140, size.height * 0.2554427),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.6162791, size.height * 0.05515239);
    path_0.lineTo(size.width * 0.6206395, size.height * 0.05370102);
    path_0.close();
    path_0.moveTo(size.width * 0.9476744, size.height * 0.3802612);
    path_0.arcToPoint(Offset(size.width * 0.9476744, size.height * 0.6197388),
        radius:
            Radius.elliptical(size.width * 0.1627907, size.height * 0.1625544),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.lineTo(size.width * 0.9462209, size.height * 0.6168360);
    path_0.lineTo(size.width * 0.9345930, size.height * 0.5805515);
    path_0.lineTo(size.width * 0.9258721, size.height * 0.5515239);
    path_0.arcToPoint(Offset(size.width * 0.9055233, size.height * 0.4223512),
        radius:
            Radius.elliptical(size.width * 0.1031977, size.height * 0.1030479),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.8764535, size.height * 0.3976778);
    path_0.cubicTo(
        size.width * 0.8255814,
        size.height * 0.3526851,
        size.width * 0.7906977,
        size.height * 0.2917271,
        size.width * 0.7776163,
        size.height * 0.2264151);
    path_0.lineTo(size.width * 0.7776163, size.height * 0.2235123);
    path_0.lineTo(size.width * 0.8125000, size.height * 0.2307692);
    path_0.cubicTo(
        size.width * 0.8226744,
        size.height * 0.2336720,
        size.width * 0.8343023,
        size.height * 0.2365747,
        size.width * 0.8430233,
        size.height * 0.2423803);
    path_0.arcToPoint(Offset(size.width * 0.9156977, size.height * 0.3526851),
        radius:
            Radius.elliptical(size.width * 0.2558140, size.height * 0.2554427),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.9447674, size.height * 0.3788099);
    path_0.lineTo(size.width * 0.9476744, size.height * 0.3802612);
    path_0.close();
    path_0.moveTo(size.width * 0.8270349, size.height * 0.8272859);
    path_0.arcToPoint(Offset(size.width * 0.6206395, size.height * 0.9462990),
        radius:
            Radius.elliptical(size.width * 0.1627907, size.height * 0.1625544),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.lineTo(size.width * 0.6220930, size.height * 0.9448476);
    path_0.lineTo(size.width * 0.6468023, size.height * 0.9158200);
    path_0.lineTo(size.width * 0.6686047, size.height * 0.8940493);
    path_0.arcToPoint(Offset(size.width * 0.7703488, size.height * 0.8113208),
        radius:
            Radius.elliptical(size.width * 0.1031977, size.height * 0.1030479),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.7776163, size.height * 0.7750363);
    path_0.cubicTo(
        size.width * 0.7906977,
        size.height * 0.7082729,
        size.width * 0.8255814,
        size.height * 0.6473149,
        size.width * 0.8764535,
        size.height * 0.6023222);
    path_0.lineTo(size.width * 0.8779070, size.height * 0.6008708);
    path_0.lineTo(size.width * 0.8895349, size.height * 0.6357039);
    path_0.cubicTo(
        size.width * 0.8938953,
        size.height * 0.6458636,
        size.width * 0.8953488,
        size.height * 0.6574746,
        size.width * 0.8953488,
        size.height * 0.6690856);
    path_0.arcToPoint(Offset(size.width * 0.8357558, size.height * 0.7866473),
        radius:
            Radius.elliptical(size.width * 0.2558140, size.height * 0.2554427),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.8284884, size.height * 0.8243832);
    path_0.lineTo(size.width * 0.8270349, size.height * 0.8272859);
    path_0.close();
    path_0.moveTo(size.width * 0.3808140, size.height * 0.9462990);
    path_0.arcToPoint(Offset(size.width * 0.1729651, size.height * 0.8272859),
        radius:
            Radius.elliptical(size.width * 0.1627907, size.height * 0.1625544),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.lineTo(size.width * 0.1758721, size.height * 0.8272859);
    path_0.lineTo(size.width * 0.2136628, size.height * 0.8359942);
    path_0.lineTo(size.width * 0.2427326, size.height * 0.8432511);
    path_0.arcToPoint(Offset(size.width * 0.3648256, size.height * 0.8896952),
        radius:
            Radius.elliptical(size.width * 0.1031977, size.height * 0.1030479),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.4011628, size.height * 0.8766328);
    path_0.cubicTo(
        size.width * 0.4651163,
        size.height * 0.8563135,
        size.width * 0.5348837,
        size.height * 0.8563135,
        size.width * 0.5988372,
        size.height * 0.8766328);
    path_0.lineTo(size.width * 0.6017442, size.height * 0.8780842);
    path_0.lineTo(size.width * 0.5770349, size.height * 0.9042090);
    path_0.cubicTo(
        size.width * 0.5697674,
        size.height * 0.9129173,
        size.width * 0.5610465,
        size.height * 0.9201742,
        size.width * 0.5508721,
        size.height * 0.9259797);
    path_0.arcToPoint(Offset(size.width * 0.4200581, size.height * 0.9332366),
        radius:
            Radius.elliptical(size.width * 0.2558140, size.height * 0.2554427),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.lineTo(size.width * 0.3837209, size.height * 0.9462990);
    path_0.lineTo(size.width * 0.3808140, size.height * 0.9462990);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xff00ffa2).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.3008721, size.height * 0.5297533);
    path_1.arcToPoint(Offset(size.width * 0.3008721, size.height * 0.4702467),
        radius: Radius.elliptical(
            size.width * 0.02906977, size.height * 0.02902758),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_1.lineTo(size.width * 0.4433140, size.height * 0.4702467);
    path_1.cubicTo(
        size.width * 0.4505814,
        size.height * 0.4702467,
        size.width * 0.4578488,
        size.height * 0.4746009,
        size.width * 0.4636628,
        size.height * 0.4789550);
    path_1.lineTo(size.width * 0.5203488, size.height * 0.5370102);
    path_1.cubicTo(
        size.width * 0.5261628,
        size.height * 0.5413643,
        size.width * 0.5290698,
        size.height * 0.5500726,
        size.width * 0.5290698,
        size.height * 0.5573295);
    path_1.lineTo(size.width * 0.5290698, size.height * 0.6995646);
    path_1.arcToPoint(Offset(size.width * 0.4709302, size.height * 0.6995646),
        radius: Radius.elliptical(
            size.width * 0.02906977, size.height * 0.02902758),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_1.lineTo(size.width * 0.4709302, size.height * 0.5718433);
    path_1.lineTo(size.width * 0.4694767, size.height * 0.5674891);
    path_1.lineTo(size.width * 0.4331395, size.height * 0.5312046);
    path_1.lineTo(size.width * 0.4287791, size.height * 0.5297533);
    path_1.lineTo(size.width * 0.3008721, size.height * 0.5297533);
    path_1.close();
    path_1.moveTo(size.width * 0.05232558, size.height * 0.3802612);
    path_1.arcToPoint(Offset(size.width * 0.1729651, size.height * 0.1727141),
        radius:
            Radius.elliptical(size.width * 0.1627907, size.height * 0.1625544),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_1.lineTo(size.width * 0.1715116, size.height * 0.1770682);
    path_1.lineTo(size.width * 0.1642442, size.height * 0.2133527);
    path_1.lineTo(size.width * 0.1569767, size.height * 0.2423803);
    path_1.arcToPoint(Offset(size.width * 0.1104651, size.height * 0.3642961),
        radius:
            Radius.elliptical(size.width * 0.1031977, size.height * 0.1030479),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_1.lineTo(size.width * 0.1220930, size.height * 0.4005806);
    path_1.cubicTo(
        size.width * 0.1438953,
        size.height * 0.4658926,
        size.width * 0.1438953,
        size.height * 0.5355588,
        size.width * 0.1220930,
        size.height * 0.5994194);
    path_1.lineTo(size.width * 0.1220930, size.height * 0.6008708);
    path_1.lineTo(size.width * 0.09447674, size.height * 0.5776488);
    path_1.cubicTo(
        size.width * 0.08720930,
        size.height * 0.5703919,
        size.width * 0.07994186,
        size.height * 0.5616836,
        size.width * 0.07412791,
        size.height * 0.5515239);
    path_1.arcToPoint(Offset(size.width * 0.06540698, size.height * 0.4194485),
        radius:
            Radius.elliptical(size.width * 0.2543605, size.height * 0.2539913),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_1.lineTo(size.width * 0.05377907, size.height * 0.3831640);
    path_1.lineTo(size.width * 0.05232558, size.height * 0.3802612);
    path_1.close();
    path_1.moveTo(size.width * 0.3808140, size.height * 0.05370102);
    path_1.arcToPoint(Offset(size.width * 0.6206395, size.height * 0.05370102),
        radius:
            Radius.elliptical(size.width * 0.1627907, size.height * 0.1625544),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_1.lineTo(size.width * 0.6162791, size.height * 0.05515239);
    path_1.lineTo(size.width * 0.5799419, size.height * 0.06676343);
    path_1.lineTo(size.width * 0.5508721, size.height * 0.07402032);
    path_1.arcToPoint(Offset(size.width * 0.4229651, size.height * 0.09579100),
        radius:
            Radius.elliptical(size.width * 0.1031977, size.height * 0.1030479),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_1.lineTo(size.width * 0.3968023, size.height * 0.1248186);
    path_1.cubicTo(
        size.width * 0.3517442,
        size.height * 0.1741655,
        size.width * 0.2921512,
        size.height * 0.2089985,
        size.width * 0.2252907,
        size.height * 0.2235123);
    path_1.lineTo(size.width * 0.2238372, size.height * 0.2235123);
    path_1.lineTo(size.width * 0.2311047, size.height * 0.1886792);
    path_1.cubicTo(
        size.width * 0.2325581,
        size.height * 0.1770682,
        size.width * 0.2369186,
        size.height * 0.1669086,
        size.width * 0.2427326,
        size.height * 0.1567489);
    path_1.arcToPoint(Offset(size.width * 0.3531977, size.height * 0.08417997),
        radius:
            Radius.elliptical(size.width * 0.2543605, size.height * 0.2539913),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_1.lineTo(size.width * 0.3779070, size.height * 0.05660377);
    path_1.lineTo(size.width * 0.3808140, size.height * 0.05370102);
    path_1.close();
    path_1.moveTo(size.width * 0.8270349, size.height * 0.1727141);
    path_1.arcToPoint(Offset(size.width * 0.9476744, size.height * 0.3802612),
        radius:
            Radius.elliptical(size.width * 0.1627907, size.height * 0.1625544),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_1.lineTo(size.width * 0.9447674, size.height * 0.3788099);
    path_1.lineTo(size.width * 0.9156977, size.height * 0.3526851);
    path_1.lineTo(size.width * 0.8953488, size.height * 0.3323657);
    path_1.arcToPoint(Offset(size.width * 0.8125000, size.height * 0.2307692),
        radius:
            Radius.elliptical(size.width * 0.1031977, size.height * 0.1030479),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_1.lineTo(size.width * 0.7747093, size.height * 0.2235123);
    path_1.cubicTo(
        size.width * 0.7078488,
        size.height * 0.2089985,
        size.width * 0.6482558,
        size.height * 0.1741655,
        size.width * 0.6031977,
        size.height * 0.1248186);
    path_1.lineTo(size.width * 0.6017442, size.height * 0.1219158);
    path_1.lineTo(size.width * 0.6351744, size.height * 0.1117562);
    path_1.cubicTo(
        size.width * 0.6468023,
        size.height * 0.1074020,
        size.width * 0.6569767,
        size.height * 0.1059507,
        size.width * 0.6686047,
        size.height * 0.1059507);
    path_1.arcToPoint(Offset(size.width * 0.7863372, size.height * 0.1654572),
        radius:
            Radius.elliptical(size.width * 0.2543605, size.height * 0.2539913),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_1.lineTo(size.width * 0.8241279, size.height * 0.1727141);
    path_1.lineTo(size.width * 0.8270349, size.height * 0.1727141);
    path_1.close();
    path_1.moveTo(size.width * 0.9476744, size.height * 0.6197388);
    path_1.arcToPoint(Offset(size.width * 0.8270349, size.height * 0.8272859),
        radius:
            Radius.elliptical(size.width * 0.1627907, size.height * 0.1625544),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_1.lineTo(size.width * 0.8284884, size.height * 0.8243832);
    path_1.lineTo(size.width * 0.8357558, size.height * 0.7866473);
    path_1.lineTo(size.width * 0.8430233, size.height * 0.7576197);
    path_1.arcToPoint(Offset(size.width * 0.8895349, size.height * 0.6357039),
        radius:
            Radius.elliptical(size.width * 0.1031977, size.height * 0.1030479),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_1.lineTo(size.width * 0.8779070, size.height * 0.5994194);
    path_1.cubicTo(
        size.width * 0.8561047,
        size.height * 0.5355588,
        size.width * 0.8561047,
        size.height * 0.4658926,
        size.width * 0.8779070,
        size.height * 0.4005806);
    path_1.lineTo(size.width * 0.8779070, size.height * 0.3991292);
    path_1.lineTo(size.width * 0.9055233, size.height * 0.4223512);
    path_1.cubicTo(
        size.width * 0.9142442,
        size.height * 0.4296081,
        size.width * 0.9215116,
        size.height * 0.4397678,
        size.width * 0.9258721,
        size.height * 0.4484761);
    path_1.arcToPoint(Offset(size.width * 0.9345930, size.height * 0.5805515),
        radius:
            Radius.elliptical(size.width * 0.2558140, size.height * 0.2554427),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_1.lineTo(size.width * 0.9462209, size.height * 0.6168360);
    path_1.lineTo(size.width * 0.9476744, size.height * 0.6197388);
    path_1.close();
    path_1.moveTo(size.width * 0.6206395, size.height * 0.9462990);
    path_1.arcToPoint(Offset(size.width * 0.3808140, size.height * 0.9462990),
        radius:
            Radius.elliptical(size.width * 0.1627907, size.height * 0.1625544),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_1.lineTo(size.width * 0.3837209, size.height * 0.9462990);
    path_1.lineTo(size.width * 0.4200581, size.height * 0.9332366);
    path_1.lineTo(size.width * 0.4491279, size.height * 0.9259797);
    path_1.arcToPoint(Offset(size.width * 0.5770349, size.height * 0.9042090),
        radius:
            Radius.elliptical(size.width * 0.1031977, size.height * 0.1030479),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_1.lineTo(size.width * 0.6031977, size.height * 0.8766328);
    path_1.cubicTo(
        size.width * 0.6482558,
        size.height * 0.8258345,
        size.width * 0.7078488,
        size.height * 0.7910015,
        size.width * 0.7747093,
        size.height * 0.7764877);
    path_1.lineTo(size.width * 0.7776163, size.height * 0.7764877);
    path_1.lineTo(size.width * 0.7703488, size.height * 0.8113208);
    path_1.cubicTo(
        size.width * 0.7674419,
        size.height * 0.8229318,
        size.width * 0.7630814,
        size.height * 0.8330914,
        size.width * 0.7572674,
        size.height * 0.8432511);
    path_1.arcToPoint(Offset(size.width * 0.6468023, size.height * 0.9158200),
        radius:
            Radius.elliptical(size.width * 0.2558140, size.height * 0.2554427),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_1.lineTo(size.width * 0.6220930, size.height * 0.9448476);
    path_1.lineTo(size.width * 0.6206395, size.height * 0.9462990);
    path_1.close();
    path_1.moveTo(size.width * 0.1729651, size.height * 0.8272859);
    path_1.arcToPoint(Offset(size.width * 0.05232558, size.height * 0.6197388),
        radius:
            Radius.elliptical(size.width * 0.1627907, size.height * 0.1625544),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_1.lineTo(size.width * 0.05523256, size.height * 0.6226415);
    path_1.lineTo(size.width * 0.08430233, size.height * 0.6473149);
    path_1.cubicTo(
        size.width * 0.09156977,
        size.height * 0.6545718,
        size.width * 0.09883721,
        size.height * 0.6603774,
        size.width * 0.1046512,
        size.height * 0.6690856);
    path_1.arcToPoint(Offset(size.width * 0.1875000, size.height * 0.7692308),
        radius:
            Radius.elliptical(size.width * 0.1031977, size.height * 0.1030479),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_1.lineTo(size.width * 0.2252907, size.height * 0.7764877);
    path_1.cubicTo(
        size.width * 0.2921512,
        size.height * 0.7910015,
        size.width * 0.3517442,
        size.height * 0.8258345,
        size.width * 0.3968023,
        size.height * 0.8766328);
    path_1.lineTo(size.width * 0.3982558, size.height * 0.8780842);
    path_1.lineTo(size.width * 0.3648256, size.height * 0.8896952);
    path_1.cubicTo(
        size.width * 0.3531977,
        size.height * 0.8925980,
        size.width * 0.3430233,
        size.height * 0.8940493,
        size.width * 0.3313953,
        size.height * 0.8940493);
    path_1.arcToPoint(Offset(size.width * 0.2136628, size.height * 0.8359942),
        radius:
            Radius.elliptical(size.width * 0.2558140, size.height * 0.2554427),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_1.lineTo(size.width * 0.1758721, size.height * 0.8272859);
    path_1.lineTo(size.width * 0.1729651, size.height * 0.8272859);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff00a0ff).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
