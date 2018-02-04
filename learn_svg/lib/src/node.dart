import 'dart:html';
import 'package:dnd/dnd.dart';
import 'node_editor.dart';
import 'node_field.dart';

typedef void EvaluateFunction(Node node);

class Node {
  final String name;
  Element domElement;

  List<NodeField> fields = new List();

  bool isLauncher = false;

  List<NodeField> get inputFields => fields.where((f)=> f.nodeFieldType == NodeFieldType.input).toList();
  List<NodeField> get outputFields => fields.where((f)=> f.nodeFieldType == NodeFieldType.output).toList();

  Draggable draggable;
  bool isDragging = false;

  EvaluateFunction evaluationFunction;

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

  NodeField addInputField<T>(String name, T value) {
    NodeField inputField = new NodeField.input(name, value, this);
    fields.add(inputField);
    domElement.children.add(inputField.domElement);

    inputField.onClick.listen((e) {
      if (NodeEditor.editor.currentOutput != null && !outputFields.contains(NodeEditor.editor.currentOutput)) {
        if(inputField.inputConnection != null){
          inputField.inputConnection.deletePath();
          inputField.inputConnection.outputField.outputConnections.remove(inputField.inputConnection);
          inputField.inputConnection = null;
        }
        NodeEditor.editor.currentOutput.tempConnection.deletePath();
        NodeField tmp = NodeEditor.editor.currentOutput;
        NodeEditor.editor.currentOutput = null;
        tmp.connectTo(this, fields.indexOf(inputField));
      }else if(NodeEditor.editor.currentOutput == null){
        if(inputField.inputConnection != null){
          NodeEditor.editor.currentOutput = inputField.inputConnection.outputField;
          inputField.inputConnection.deletePath();
          inputField.inputConnection.outputField.outputConnections.remove(inputField.inputConnection);
          inputField.inputConnection = null;
        }

      }
      e.stopPropagation();
    });

    return inputField;
  }

  NodeField addOutputField<T>(String name, T value) {
    NodeField outputField = new NodeField<T>.output(name, value, this);
    fields.add(outputField);
    domElement.children.add(outputField.domElement);

    outputField.onClick.listen((e) {

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
      NodeEditor.editor.currentOutput = outputField;
//
//      if (output.toNode != null) {
////        output.toNode.detachOutput(output);
//        domElement.classes.remove('filled');
//        domElement.classes.add('empty');
//      }
      e.stopPropagation();
    });

    return outputField;
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
    for (int i = 0; i < inputFields.length; i++) {
      if(inputFields[i].inputConnection != null ) {
        Point<int> fromPoint = inputFields[i].inputConnection.outputField.getConnectionPoint();
        Point<int> toPoint = inputFields[i].inputConnection.inputField.getConnectionPoint();
        inputFields[i].inputConnection.setPath(fromPoint, toPoint);
      }
    }

    //outputs
    for (int i = 0; i < outputFields.length; i++) {
      if (outputFields[i].outputConnections.length > 0) {
        for (int j = 0; j < outputFields[i].outputConnections.length; ++j) {
          Point<int> fromPoint = outputFields[i].getConnectionPoint();
          Point<int> toPoint = outputFields[i].outputConnections[j].inputField.getConnectionPoint();
          outputFields[i].outputConnections[j].setPath(fromPoint, toPoint);
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
  void evaluate(/*NodeField outputField*/) {
    //set les valeurs des inputs en fonction des outputs si il en existe
    for (NodeField input in inputFields) {
      if(input.inputConnection != null){
        //evaluer chaque output node des connections d'input
        input.inputConnection.outputField.node.evaluate();
        // assigne les valeurs des connections outputs aux connections inputs
        input.inputConnection.inputField.value = input.inputConnection.outputField.value;

      }
    }
    //evalue le fonction de traitement des nodes inputs vers les nodes outputs
    if(evaluationFunction != null){
      evaluationFunction(this);
    }
  }
}