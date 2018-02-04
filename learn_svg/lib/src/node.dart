import 'dart:html';
import 'package:dnd/dnd.dart';
import 'package:learn_svg/src/node_utils.dart';
import 'node_editor.dart';
import 'node_field.dart';

class Node {
  final String name;
  Element domElement;

  List<NodeField> fields = new List();

  bool launcher = false;

  List<NodeField> get inputs => fields.where((f)=> f.nodeFieldType == NodeFieldType.input).toList();
  List<NodeField> get outputs => fields.where((f)=> f.nodeFieldType == NodeFieldType.output).toList();

  Draggable draggable;
  bool isDragging = false;

  Function evaluationFunction;

  Node(this.name) {
    domElement = document.createElement('div');
    domElement.classes.add('node');
    domElement.style.position = 'absolute';
    domElement.setAttribute('title', name);
    document.body.children.add(domElement);
    draggable = new Draggable(domElement,
        avatarHandler: new AvatarHandler.original())
      ..onDrag.listen(_onDrag)
      ..onDragEnd.listen(_onDragEnd);

    NodeEditor.editor.nodes.add(this);
  }

  Point<int> getInputPoint(int fieldIndex) {
    return fields[fieldIndex].getConnectionPoint();
  }

  NodeField addInput<T>(String name, T value) {
    NodeField input = new NodeField.input(name, value, this);
    fields.add(input);
    domElement.children.add(input.domElement);

    input.onClick.listen((e) {
      if (NodeEditor.editor.currentOutput != null && !outputs.contains(NodeEditor.editor.currentOutput)) {
        if(input.inputConnection != null){
          input.inputConnection.deletePath();
          input.inputConnection.output.outputConnections.remove(input.inputConnection);
          input.inputConnection = null;
        }
        NodeEditor.editor.currentOutput.tempConnection.deletePath();
        NodeField tmp = NodeEditor.editor.currentOutput;
        NodeEditor.editor.currentOutput = null;
        tmp.connectTo(this, fields.indexOf(input));
      }else if(NodeEditor.editor.currentOutput == null){
        if(input.inputConnection != null){
          NodeEditor.editor.currentOutput = input.inputConnection.output;
          input.inputConnection.deletePath();
          input.inputConnection.output.outputConnections.remove(input.inputConnection);
          input.inputConnection = null;
        }

      }
      e.stopPropagation();
    });

    return input;
  }

  NodeField addOutput<T>(String name, T value) {
    NodeField output = new NodeField<T>.output(name, value, this);
    fields.add(output);
    domElement.children.add(output.domElement);

    output.onClick.listen((e) {

//      //if an output path is already dynamic draw
//      if (NodeEditor.editor.currentOutput != null) {
//        if (NodeEditor.editor.currentOutput.hasPath) {
//          NodeEditor.editor.currentOutput.deletePath();
//        }
//        if (NodeEditor.editor.currentOutput.toNode != null) {
////          NodeEditor.editor.currentOutput.toNode.detachOutput(NodeEditor.editor.currentOutput);
//          NodeEditor.editor.currentOutput.toNode = null;
//        }
//      }
//
      //make this output active
      NodeEditor.editor.currentOutput = output;
//
//      if (output.toNode != null) {
////        output.toNode.detachOutput(output);
//        domElement.classes.remove('filled');
//        domElement.classes.add('empty');
//      }
      e.stopPropagation();
    });

    return output;
  }

//  /// que fais-tu réellement ?
//  void detachInput(NodeField output) {
//    output.deletePath();
//    output.toNode = null;
//    output.outputConnections.input.inputConnections.remove(output.outputConnections);
//
//    if (inputs.length <= 0) {
//      domElement.classes.remove('connected');
//    }
//  }

  void _onDrag(DraggableEvent event) {
    isDragging = true;
    updatePosition();
  }

  void _onDragEnd(DraggableEvent event){
    isDragging = false;
    updatePosition();
  }

  void updatePosition() {

    //inputs
    for (int i = 0; i < inputs.length; i++) {
      if(inputs[i].inputConnection != null ) {
        Point<int> fromPoint = inputs[i].inputConnection.output.getConnectionPoint();
        Point<int> toPoint = inputs[i].inputConnection.input.getConnectionPoint();
        inputs[i].inputConnection.setPath(fromPoint, toPoint);
      }
    }

    //outputs
    for (int i = 0; i < outputs.length; i++) {
      if (outputs[i].outputConnections.length > 0) {
        for (int j = 0; j < outputs[i].outputConnections.length; ++j) {
          Point<int> fromPoint = outputs[i].getConnectionPoint();
          Point<int> toPoint = outputs[i].outputConnections[j].input.getConnectionPoint();
          outputs[i].outputConnections[j].setPath(fromPoint, toPoint);
        }
      }
    }
  }

  Point<int> _position = new Point<int>(0,0);
  Point<int> get position => _position;
  set position(Point<int> point) {
    _position = point;
    domElement.style.top = '${point.y}px';
    domElement.style.left = '${point.x}px';
    updatePosition();
  }
  dynamic evaluate(/*NodeField outputField*/) {
    //set les valeurs des inputs en fonction des outputs si il en existe

    //
    for (NodeField input in inputs) {
      if(input.inputConnection != null){
        //evaluer chaque output node des connections d'input
        input.inputConnection.output.node.evaluate();
        // assigne les valeurs des outputs aux inputs
        input.inputConnection.input.value = input.inputConnection.output.value;
      }
    }

    dynamic value;


//    /// prepare outputs if needed with evaluation
//
//
//    if(inputs.length > 0) {
//      if (inputs[0].inputConnections.length == 0) {
//        value = inputs[0].value; //use default defined value
//      } else {
//        value = inputs[0].inputConnections[0].output.node.evaluate(inputs[0].inputConnections[0].output);
//      }
//    }else{
//      value = outputField.value;
//    }
//
//    if(evaluationFunction != null && outputField != null) {
//      evaluationFunction(outputField.node);
//    }
    return value;
  }
}