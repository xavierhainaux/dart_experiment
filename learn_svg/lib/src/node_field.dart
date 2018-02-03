import 'dart:async';
import 'dart:html' hide Node;
import 'dart:svg' hide Point;
import 'node.dart';
import 'node_editor.dart';
import 'node_utils.dart';

enum NodeFieldType { input, output }

///This represent a node field with it's output circle
class NodeField {
  final String name;
  final NodeFieldType nodeFieldType;

  Element domElement;
  PathElement _path;// Todo (jpu) : should be in Connection
  Node toNode;// Todo (jpu) :should be deleted

  Connection outputConnection;
  final List<Connection> inputConnections = new List();

  final int _index;
  int get index => _index;

  Stream get onClick => domElement.onClick;

  NodeField.input(String name, int index) : this._(name, NodeFieldType.input, index);
  NodeField.output(String name, int index) : this._(name, NodeFieldType.output, index);

  NodeField._(this.name, this.nodeFieldType, this._index) {
    domElement = document.createElement('div');
    domElement.classes.add('nodeField');
    domElement.innerHtml = name;

    if (nodeFieldType == NodeFieldType.input) {
      domElement.classes.add('input');
    } else {
      domElement.classes.add('output');
      domElement.classes.add('empty');

      _initPath();
    }
  }

  void _initPath() {
    _path =
        document.createElementNS(NodeEditor.editor.svg.namespaceUri, 'path');
    _path.setAttributeNS(null, 'stroke', '#8e8e8e');
    _path.setAttributeNS(null, 'stroke-width', '2');
    _path.setAttributeNS(null, 'fill', 'none');
    NodeEditor.editor.svg.children.add(_path);
  }

  /// Create string representing a svg curve path between two points
  void setPath(Point<int> fromPoint, Point<int> toPoint) {
    Point<int> diff =
        new Point<int>(toPoint.x - fromPoint.x, toPoint.y - fromPoint.y);

    String pathStr = 'M${fromPoint.x},${fromPoint.y} ';
    pathStr += 'C';
    pathStr += '${fromPoint.x + diff.x / 3 * 2},${fromPoint.y} ';
    pathStr += '${fromPoint.x + diff.x / 3},${toPoint.y} ';
    pathStr += '${toPoint.x},${toPoint.y}';

    _path.setAttributeNS(null, 'd', pathStr);
  }

  void deletePath() {
    _path.attributes.remove('d');
  }

  bool get hasPath => _path.getAttribute('d') != null;

  void drawTemporaryPath(Point<int> toPoint) {
    Point<int> fromPoint = getConnectionPoint();
    setPath(fromPoint, toPoint);
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

  void connectTo(Node node, int fieldIndex) {
    toNode = node;
//    node.connected = true;
//    node.domElement.classes.add('connected');

    domElement.classes.remove('empty');
    domElement.classes.add('filled');

    NodeField nodeInputField = node.fields[fieldIndex];

    Connection connection = new Connection()
      ..index = fieldIndex
      ..output = this
      ..input = nodeInputField;

    outputConnection = connection;
    nodeInputField.inputConnections.add(connection);

    Point<int> fromPoint = getConnectionPoint();
    Point<int> toPoint = node.getInputPoint(fieldIndex);
    setPath(fromPoint, toPoint);
  }
}
