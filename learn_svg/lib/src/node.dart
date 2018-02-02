import 'dart:html';
import 'package:dnd/dnd.dart';
import 'node_editor.dart';
import 'node_input.dart';
import 'node_output.dart';
import 'node_utils.dart';

class Node {
  final String name;
  Element domElement;

  List<NodeInput> inputs = new List();
  List<Connection> inputConnections = new List();

  List<NodeOutput> outputs = new List();

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

    // Input Click handler
    NodeInput input = addInput();
    input.onClick.listen((e) {
      if (NodeEditor.editor.currentOutput != null && !outputs.contains(NodeEditor.editor.currentOutput)) {
        NodeOutput tmp = NodeEditor.editor.currentOutput;
        NodeEditor.editor.currentOutput = null;
        tmp.connectTo(this);
      }
      e.stopPropagation();
    });
  }

  Point<int> getInputPoint() {
    Element tmp = domElement.children.first;
    Offset offset = NodeEditor.getFullOffset(tmp);
    return new Point<int>(
        offset.left + tmp.offsetWidth ~/ 2, offset.top + tmp.offsetHeight ~/ 2);
  }

  NodeInput addInput() {
    NodeInput input = new NodeInput();
    inputs.add(input);
    domElement.children.add(input.domElement);
    return input;
  }

  NodeOutput addOutput(String name) {
    NodeOutput output = new NodeOutput(name);
    outputs.add(output);
    domElement.children.add(output.domElement);
    return output;
  }

  void detachOutput(NodeOutput output) {
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
      Point<int> fromPoint = inputConnections[i].output.getFromPoint();
      Point<int> toPoint = getInputPoint();
      inputConnections[i].output.setPath(fromPoint, toPoint);
    }

    for (int j = 0; j < outputs.length; j++) {
      if (outputs[j].toNode != null) {
        Point<int> fromPoint = outputs[j].getFromPoint();
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