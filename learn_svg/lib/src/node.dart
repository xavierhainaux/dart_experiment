import 'dart:html';
import 'package:dnd/dnd.dart';
import 'node_editor.dart';
import 'node_field.dart';
import 'node_utils.dart';

class Node {
  final String name;
  Element domElement;

  List<NodeField> fields = new List();
  List<NodeField> get inputs => fields.where((f)=> f.nodeFieldType == NodeFieldType.input).toList();
  List<NodeField> get outputs => fields.where((f)=> f.nodeFieldType == NodeFieldType.output).toList();
//  List<Connection> inputConnections = new List();

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

  Point<int> getInputPoint(int fieldIndex) {
    return fields[fieldIndex].getConnectionPoint();
  }

  NodeField addInput(String name) {
    NodeField input = new NodeField.input(name, fields.length);
    fields.add(input);
    domElement.children.add(input.domElement);

    input.onClick.listen((e) {
      if (NodeEditor.editor.currentOutput != null && !outputs.contains(NodeEditor.editor.currentOutput)) {
        NodeField tmp = NodeEditor.editor.currentOutput;
        NodeEditor.editor.currentOutput = null;
        tmp.connectTo(this, fields.indexOf(input));
      }
      e.stopPropagation();
    });

    return input;
  }

  NodeField addOutput(String name) {
    NodeField output = new NodeField.output(name, fields.length);
    fields.add(output);
    domElement.children.add(output.domElement);

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

    return output;
  }

  /// que fais-tu réellement ?
  void detachOutput(NodeField output) {
    output.deletePath();
    output.toNode = null;
    output.outputConnection.input.inputConnections.remove(output.outputConnection);

    if (inputs.length <= 0) {
      domElement.classes.remove('connected');
    }
  }

  void updatePosition() {

    //inputs
    for (int i = 0; i < inputs.length; i++) {
      if(inputs[i].inputConnections.length > 0 ) {
        for(int j = 0; j < inputs[i].inputConnections.length; j++){
          Point<int> fromPoint = inputs[i].inputConnections[j].output
              .getConnectionPoint();
          Point<int> toPoint = inputs[i].inputConnections[j].input.getConnectionPoint();
          inputs[i].inputConnections[j].output.setPath(fromPoint, toPoint);
        }
      }
    }

    //outputs
    for (int j = 0; j < outputs.length; j++) {
      if (outputs[j].toNode != null) {
        Point<int> fromPoint = outputs[j].getConnectionPoint();
        Point<int> toPoint = outputs[j].outputConnection.input.getConnectionPoint();
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