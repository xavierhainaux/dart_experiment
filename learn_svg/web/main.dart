import 'dart:html' hide Node;
import 'package:learn_svg/src/node.dart';

///Exemple de code
///https://codepen.io/xgundam05/pen/KjqJn

///dnd : drag and drop dart library
///http://code.makery.ch/library/dart-drag-and-drop/

void main() {
  // Node 1
  Node node = new Node('Node 1');
  node.addOutput('Value1');
  node.addOutput('Value2');
  node.addOutput('Value3');

  // Node 2
  Node node2 = new Node('Node 2');
  node2.addOutput('Text In');
  node2.addOutput('Value 5');

  // Node 3
  Node node3 = new Node('Node 3');
  node3.addOutput('Color4');
  node3.addOutput('Position');
  node3.addOutput('Noise Octaves');

  // Connect Nodes
  node.outputs[0].connectTo(node3);
  node2.outputs[0].connectTo(node);
  node2.outputs[1].connectTo(node3);

  // Move to initial positions
  node.position = new Point<int>(150, 20);
  node2.position = new Point<int>(20, 50);
  node3.position = new Point<int>(300, 150);
}
