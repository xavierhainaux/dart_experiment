import 'dart:html' hide Node;
import 'package:learn_svg/src/node.dart';
import 'package:learn_svg/src/node_editor.dart';
import 'package:vector_math/vector_math.dart';

///Exemple de code
///https://codepen.io/xgundam05/pen/KjqJn

///dnd : drag and drop dart library
///http://code.makery.ch/library/dart-drag-and-drop/

void main() {
//  simpleExemple();
  fullExemple();
}

void simpleExemple(){
  // Node 1
  Node node1 = new Node('Node 1');
  node1.addOutput<int>('output 0', 10);
  node1.addOutput<int>('output 1', 20);
  node1.position = new Point<int>(20, 20);

  // Node 2
  Node node2 = new Node('Node 2');
  node2.addInput<int>('input 0', 0);
  node2.addInput<int>('input 1', 0);
  node2.addInput<int>('input 2', 0);
  node2.position = new Point<int>(400, 20);

  node1.outputs[0].connectTo(node2, 0);
}

void fullExemple() {

  Element button = new ButtonElement()
  ..text = 'Evaluate'
  ..onClick.listen((MouseEvent event){
    NodeEditor.editor.update();
  });
  document.body.children.add(button);

  // Node 1
  Node node1 = new Node('Node 1');
  node1.addOutput<int>('Value 1', 10);
  node1.addOutput<int>('Value 2', 20);
  node1.position = new Point<int>(20, 160);

  // Node 2
  Node node2 = new Node('Node 2');
  node2.addOutput<int>('Value', 15);
  node2.addOutput<double>('Value', 0.5);
  node2.addOutput<String>('Value', 'Test');
  node2.addOutput<Vector3>('Position', new Vector3(1.0, 1.0, 0.5));
  node2.addInput<int>('inputValue 1', 0);
  node2.addInput<int>('inputValue 2', 0);
  node2.addInput<int>('inputValue 3', 0);
  node2.position = new Point<int>(200, 20);

  // Node 3
  Node node3 = new Node('Add');
  node3.addOutput<int>('Result', 0);
  node3.addInput<int>('inputValue 1', 0);
  node3.addInput<int>('inputValue 2', 0);
  node3.position = new Point<int>(500, 200);
  node3.evaluationFunction = (Node node) {
    node.outputs[0].value = node.inputs[0].value + node.inputs[1].value;
    return node.outputs[0].value;
  };

  // Node 4
  Node node4 = new Node('Log');
  node4.addInput<String>('value', "default value");
  node4.position = new Point<int>(740, 210);
  node4.evaluationFunction = (Node node) => print(node.evaluate());
  node4.launcher = true;

  // Connect Nodes
  node1.outputs[0].connectTo(node2, 4);
  node1.outputs[1].connectTo(node3, 2);
  node2.outputs[0].connectTo(node3, 1);
  node3.outputs[0].connectTo(node4, 0);

  // Evaluate one first time ? why ?
  NodeEditor.editor.update();
}
