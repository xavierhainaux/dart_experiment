import 'dart:html' hide Node;
import 'package:learn_svg/src/nodes/node.dart';

///Exemple de code
///https://codepen.io/xgundam05/pen/KjqJn

///dnd : drag and drop dart library
///http://code.makery.ch/library/dart-drag-and-drop/

void main() {
//  simpleExemple();
//  simpleExemple2();

  fullExemple();
}

void simpleExemple() {
  // Node 1
  Node node01 = new Node('Node 1');
  node01.addOutputField<int>('output 0', 10);
  node01.addOutputField<int>('output 1', 20);
  node01.position = new Point<int>(20, 20);

  // Node 2
  Node node02 = new Node('Node 2');
  node02.addInputField<int>('input 0', 0);
  node02.addInputField<int>('input 1', 0);
  node02.addInputField<int>('input 2', 0);
  node02.position = new Point<int>(400, 20);

  node01.outputFields[0].connectTo(node02.inputFields[0]);
}

void simpleExemple2() {
  Node node01 = new Node('Node 01');
  node01.addOutputField('01 output 01', 5);
  node01.position = new Point<int>(20, 40);

  Node node02 = new Node('Node 02');
  node02.addOutputField('02 output 01', 9);
  node02.addInputField('02 input 01', 3);
  node02.position = new Point<int>(300, 40);
  node02.evaluationFunction = (Node node) {
    node.outputFields[0].value = node.inputFields[0].value;
  };

  Node node03 = new Node('Node 03');
  node03.isLauncher = true;
  node03.addInputField('03 input 01', 7);
  node03.position = new Point<int>(600, 40);

  node01.outputFields.first.connectTo(node02.inputFields[0]);
  node02.outputFields.first.connectTo(node03.inputFields[0]);
}

void fullExemple() {
  Node nodeInt01 = new NodeInt(2)..position = new Point<int>(20, 160);
  Node nodeInt02 = new NodeInt(3)..position = new Point<int>(20, 240);
  Node nodeInt03 = new NodeInt(4)..position = new Point<int>(420, 360);
  Node nodeDivide = new NodeDivide()..position = new Point<int>(250, 120);
  Node nodeAdd = new NodeAdd()..position = new Point<int>(480, 200);
  Node nodeMultiply = new NodeMultiply()..position = new Point<int>(690, 280);
  Node nodeLog = new NodeLog()..position = new Point<int>(900, 300);

  // Connect Nodes
  nodeInt01.outputFields[0].connectTo(nodeDivide.inputFields[0]);
  nodeInt02.outputFields[0].connectTo(nodeAdd.inputFields[1]);
  nodeInt02.outputFields[0].connectTo(nodeDivide.inputFields[1]);
  nodeDivide.outputFields[0].connectTo(nodeAdd.inputFields[0]);
  nodeAdd.outputFields[0].connectTo(nodeMultiply.inputFields[0]);
  nodeInt03.outputFields[0].connectTo(nodeMultiply.inputFields[1]);
  nodeMultiply.outputFields[0].connectTo(nodeLog.inputFields[0]);

  // Evaluate one first time ? why ?
//  NodeEditor.editor.update();
}
