import 'dart:async';
import 'dart:html' hide Node;
import 'package:learn_svg/src/node_connection.dart';
import 'nodes/node.dart';
import 'node_editor.dart';
import 'node_utils.dart';

enum NodeFieldType { input, output }

///This represent a node field with it's output circle
class NodeField<T> {
  final String name;
  final NodeFieldType nodeFieldType;
  final String _displayedName;
  String get displayedName => _displayedName;

  T value;

  Element domElement;

  Node toNode;// Todo (jpu) :should be deleted

  Connection tempConnection;
  List<Connection> outputConnections = new List();
  Connection inputConnection = null;

  final Node node;

  Stream get onClick => domElement.onClick;

  NodeField.input(String name, T value, Node node) : this._(name, NodeFieldType.input, value, node);
  NodeField.output(String name, T value, Node node) : this._(name, NodeFieldType.output, value, node);

  NodeField._(this.name, this.nodeFieldType, this.value, this.node):this._displayedName = '$name   (${value.runtimeType}) : $value' {
    domElement = document.createElement('div');
    domElement.classes.add('nodeField');
    domElement.innerHtml = _displayedName;

    if (nodeFieldType == NodeFieldType.input) {
      domElement.classes.add('input');
    } else {
      domElement.classes.add('output');
      domElement.classes.add('empty');

//      outputConnections.forEach((outputConnection)=>outputConnection.initPath());
    }
  }

  bool get hasPath => outputConnections[0].path.getAttribute('d') != null;

  void drawTemporaryPath(Point<int> toPoint) {
    Point<int> fromPoint = getConnectionPoint();
    tempConnection.setPath(fromPoint, toPoint);
  }

  Point<int> getConnectionPoint() {
    Offset offset = NodeEditor.getFullOffset(domElement);
    Point<int> result;
    switch (nodeFieldType) {
      case NodeFieldType.input:
        result = new Point<int>(
            offset.left + 2, offset.top + domElement.offsetHeight ~/ 2);
        break;
      case NodeFieldType.output:
        result = new Point<int>(offset.left + domElement.offsetWidth - 10,
            offset.top + domElement.offsetHeight ~/ 2);
        break;
    }
    return result;
  }

  void connectTo(NodeField inputField) {
    toNode = inputField.node;

    domElement.classes.remove('empty');
    domElement.classes.add('filled');

    Connection connection = new Connection()
      ..outputField = this
      ..inputField = inputField;

    outputConnections.add(connection);
    inputField.inputConnection = connection;

    Point<int> fromPoint = getConnectionPoint();
    Point<int> toPoint = inputField.getConnectionPoint();
    connection.setPath(fromPoint, toPoint);
  }
}
