import 'dart:html';
import 'package:dnd/dnd.dart';
import 'node_editor.dart';
import 'node_input.dart';
import 'node_field.dart';
import 'node_utils.dart';

class Node {
  final String name;
  Element domElement;

  List<NodeField> inputs = new List();
  List<Connection> inputConnections = new List();

  List<NodeField> outputs = new List();

  bool connected = false;
  Draggable draggable;
  bool isDragging = false;

  Node(this.name) {
    // DOM Element creation
    domElement = document.createElement('div');
    domElement.classes.add('node');
    domElement.style.position = 'absolute';
    domElement.setAttribute('title', name);
    document.body.children.add(domElement);
    draggable = new Draggable(domElement,
        avatarHandler: new AvatarHandler.original())
      ..onDrag.listen(_onDrag)
      ..onDragEnd.listen(_onDragEnd);
  }

  Point<int> getInputPoint() {
    return inputs[0].getConnectionPoint();
  }

  NodeField addInput(String name) {
    NodeField input = new NodeField.input(name);
    input.onClick.listen((e) {
      if (NodeEditor.editor.currentOutput != null && !outputs.contains(NodeEditor.editor.currentOutput)) {
        NodeField tmp = NodeEditor.editor.currentOutput;
        NodeEditor.editor.currentOutput = null;
        tmp.connectTo(this);
      }
      e.stopPropagation();
    });

    inputs.add(input);
    domElement.children.add(input.domElement);
    return input;
  }

  NodeField addOutput(String name) {
    NodeField output = new NodeField.output(name);

    output.onClick.listen((e) {
      //if an output in already active
      if (NodeEditor.editor.currentOutput != null) {
        if (NodeEditor.editor.currentOutput.hasPath) {
          NodeEditor.editor.currentOutput.deletePath();
        }
        if (NodeEditor.editor.currentOutput.toNode != null) {
          NodeEditor.editor.currentOutput.toNode.detachOutput(NodeEditor.editor.currentOutput);
          NodeEditor.editor.currentOutput.toNode = null;
        }
      }

      //make this output active
      NodeEditor.editor.currentOutput = output;

      if (output.toNode != null) {
        output.toNode.detachOutput(output);
        domElement.classes.remove('filled');
        domElement.classes.add('empty');
      }
      e.stopPropagation();
    });

    outputs.add(output);
    domElement.children.add(output.domElement);
    return output;
  }

  void detachOutput(NodeField output) {
    int index = -1;
    for (int i = 0; i < inputConnections.length; i++) {
      if (inputConnections[i].output == output) index = i;
    }

    if (index >= 0) {
      inputConnections[index].output.deletePath();
      inputConnections[index].output.toNode = null;
      inputConnections.removeAt(index);
    }

    if (inputConnections.length <= 0) {
      domElement.classes.remove('connected');
    }
  }

  void updatePosition() {

    for (int i = 0; i < inputConnections.length; i++) {
      Point<int> fromPoint = inputConnections[i].output.getConnectionPoint();
      Point<int> toPoint = getInputPoint();
      inputConnections[i].output.setPath(fromPoint, toPoint);
    }

    for (int j = 0; j < outputs.length; j++) {
      if (outputs[j].toNode != null) {
        Point<int> fromPoint = outputs[j].getConnectionPoint();
        Point<int> toPoint = outputs[j].toNode.getInputPoint();
        outputs[j].setPath(fromPoint, toPoint);
      }
    }
  }

  set position(Point<int> point) {
    domElement.style.top = '${point.y}px';
    domElement.style.left = '${point.x}px';
    updatePosition();
  }

  void _onDrag(DraggableEvent event) {
    isDragging = true;
    updatePosition();
  }

  void _onDragEnd(DraggableEvent event){
    isDragging = false;
    updatePosition();
  }
}