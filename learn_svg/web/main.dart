import 'dart:html' hide Node;
import 'package:learn_svg/src/node.dart';

///Exemple de code
///https://codepen.io/xgundam05/pen/KjqJn

///dnd : drag and drop dart library
///http://code.makery.ch/library/dart-drag-and-drop/

void main() {
  // Node 1
  Node node1 = new Node('Node 1');
  node1.addOutput('Value 1');
  node1.addOutput('Value 2');
  node1.position = new Point<int>(20, 100);

  // Node 2
  Node node2 = new Node('Node 2');
  node2.addOutput('Value1');
  node2.addOutput('Value2');
  node2.addOutput('Value3');
  node2.addInput('inputValue 1');
  node2.addInput('inputValue 2');
  node2.addInput('inputValue 3');
  node2.position = new Point<int>(200, 20);

  // Node 3
  Node node3 = new Node('Node 3');
  node3.addOutput('Position');
  node3.addOutput('Scale');
  node3.addOutput('Color4');
  node3.addInput('inputValue 1');
  node3.addInput('inputValue 2');
  node3.addInput('inputValue 3');
  node3.position = new Point<int>(390, 150);

  // Node 4
  Node node4 = new Node('Node 4');
  node4.addInput('inputValue');
  node4.position = new Point<int>(692, 181);

  // Connect Nodes
  node1.outputs[0].connectTo(node2, 3);
  node1.outputs[1].connectTo(node3, 4);
  node2.outputs[0].connectTo(node3, 3);
  node3.outputs[0].connectTo(node4, 0);
}
