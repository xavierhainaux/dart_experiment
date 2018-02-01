import 'dart:html';
import 'dart:svg' hide Point;

import 'package:learn_svg/src/node_editor.dart';

import 'node_output.dart';

class Offset {
  int x, y;
  int top, left;

  @override
  String toString() {
    return 'Offset{x: $x, y: $y, top: $top, left: $left}';
  }
}

class Connection {
  NodeOutput output;
}




