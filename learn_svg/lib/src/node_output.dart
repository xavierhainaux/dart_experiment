import 'dart:html' hide Node;
import 'dart:svg' hide Point;
import 'node.dart';
import 'node_editor.dart';
import 'node_utils.dart';

///This represent a node field with it's output circle
class NodeOutput {
  final String name;

  Element domElement;
  PathElement _path;
  Node toNode;

  NodeOutput(this.name) {
    domElement = document.createElement('div');
    domElement.classes.add('connection');
    domElement.classes.add('empty');
    domElement.innerHtml = name;

    _initPath();

    domElement.onClick.listen((e) {
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
      NodeEditor.editor.currentOutput = this;

      if (toNode != null) {
        toNode.detachOutput(this);
        domElement.classes.remove('filled');
        domElement.classes.add('empty');
      }
      e.stopPropagation();
    });
  }

  void _initPath() {
    _path = document.createElementNS(NodeEditor.editor.svg.namespaceUri, 'path');
    _path.setAttributeNS(null, 'stroke', '#8e8e8e');
    _path.setAttributeNS(null, 'stroke-width', '2');
    _path.setAttributeNS(null, 'fill', 'none');
    NodeEditor.editor.svg.children.add(_path);
  }

  /// Create string representing a svg curve path between two points
  void setPath(Point<int> fromPoint, Point<int> toPoint){
    Point<int> diff = new Point<int>(toPoint.x - fromPoint.x, toPoint.y - fromPoint.y);

    String pathStr = 'M${fromPoint.x},${fromPoint.y} ';
    pathStr += 'C';
    pathStr += '${fromPoint.x + diff.x / 3 * 2},${fromPoint.y} ';
    pathStr += '${fromPoint.x + diff.x / 3},${toPoint.y} ';
    pathStr += '${toPoint.x},${toPoint.y}';

    _path.setAttributeNS(null, 'd', pathStr);
  }

  void deletePath(){
    _path.attributes.remove('d');
  }

  bool get hasPath => _path.getAttribute('d') != null;

  void drawTemporaryPath(Point<int> toPoint) {
    Point<int> fromPoint = getFromPoint();
    setPath(fromPoint, toPoint);
  }

  Point<int> getFromPoint() {
    Offset offset = NodeEditor.getFullOffset(domElement);
    return new Point<int>(offset.left + domElement.offsetWidth - 2,
        offset.top + domElement.offsetHeight ~/ 2);
  }

  void connectTo(Node node) {
    toNode = node;
    node.connected = true;
    node.domElement.classes.add('connected');

    domElement.classes.remove('empty');
    domElement.classes.add('filled');

    node.inputConnections.add(new Connection()
      ..output = this);

    Point<int> fromPoint = getFromPoint();
    Point<int> toPoint = node.getInputPoint();
    setPath(fromPoint, toPoint);
  }
}