import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

void main() => runApp(ShapeScreenPage());

class ShapeScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShapeScreen(),
    );
  }
}

class ShapeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter custom clipper example"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          ClipPath(
            clipper: SideCutClipper(),
            child: InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              clipBehavior: Clip.hardEdge,
              child: Container(
                height: 20,
                width: 50,
                color: Colors.pink,
                child: const Center(child: Text("SideCutClipper()")),
              ),
            ),
          ),
          ClipPath(
            clipper: MultipleRoundedCurveClipper(),
            child: Container(
              height: 100,
              color: Colors.pink,
              child: Center(child: Text("MultipleRoundedCurveClipper()")),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ClipPath(
            clipper: MultiplePointedEdgeClipper(),
            child: Container(
              height: 100,
              color: Colors.green,
              child: const Center(child: Text("MultiplePointedEdgeClipper()")),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ClipPath(
            clipper: OctagonalClipper(),
            child: Container(
              height: 100,
              width: 100,
              color: Colors.purple,
              child: const Center(child: Text("OctagonalClipper()")),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ClipPath(
            clipper: HexagonalClipper(),
            child: Container(
              height: 220,
              color: Colors.blueAccent,
              child: const Center(child: Text("HexagonalClipper()")),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ClipPath(
            clipper: HexagonalClipper(reverse: true),
            child: Container(
              height: 220,
              color: Colors.orangeAccent,
              child:
                  const Center(child: Text("HexagonalClipper(reverse: true)")),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ClipPath(
            clipper: ParallelogramClipper(),
            child: Container(
              height: 220,
              color: Colors.pinkAccent,
              child: const Center(child: Text("ParallelogramClipper()")),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ClipPath(
            clipper: DiagonalPathClipperOne(),
            child: Container(
              height: 120,
              color: Colors.red,
              child: const Center(child: Text("DiagonalPathClipper()")),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ClipPath(
            clipper: DiagonalPathClipperTwo(),
            child: Container(
              height: 120,
              color: Colors.pink,
              child: const Center(child: Text("DiagonalPathClipper()")),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ClipPath(
            clipper: WaveClipperOne(),
            child: Container(
              height: 120,
              color: Colors.deepPurple,
              child: const Center(child: Text("WaveClipperOne()")),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ClipPath(
            clipper: WaveClipperOne(reverse: true),
            child: Container(
              height: 120,
              color: Colors.deepPurple,
              child: const Center(child: Text("WaveClipperOne(reverse: true)")),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              height: 120,
              color: Colors.orange,
              child: const Center(child: Text("WaveClipperTwo()")),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ClipPath(
            clipper: WaveClipperTwo(reverse: true),
            child: Container(
              height: 120,
              color: Colors.orange,
              child: const Center(child: Text("WaveClipperTwo(reverse: true)")),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ClipPath(
            clipper: RoundedDiagonalPathClipper(),
            child: Container(
              height: 320,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                color: Colors.orange,
              ),
              child: const Center(child: Text("RoundedDiagonalPathClipper()")),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          ClipPath(
            clipper: ArrowClipper(70, 80, Edge.BOTTOM),
            child: Container(
              height: 120,
              color: Colors.green,
              child: const Center(child: Text("ArrowClipper()")),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ClipPath(
            clipper: StarClipper(8),
            child: Container(
              height: 450,
              color: Colors.indigo,
              child: const Center(child: Text("Starlipper()")),
            ),
          ),
          ClipPath(
            clipper: MessageClipper(borderRadius: 16),
            child: Container(
              height: 200,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                color: Colors.red,
              ),
              child: const Center(child: Text("MessageClipper()")),
            ),
          ),
          const SizedBox(height: 20),
          ClipPath(
            clipper: WavyCircleClipper(32),
            child: Container(
              width: 400,
              height: 400,
              color: Colors.purple,
              child: const Center(child: Text("WavyCircleClipper()")),
            ),
          ),
        ],
      ),
    );
  }
}
