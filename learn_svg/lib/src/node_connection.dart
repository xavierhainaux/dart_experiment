import 'dart:html';
import 'dart:svg' hide Point;
import 'package:learn_svg/src/node_editor.dart';
import 'package:learn_svg/src/node_field.dart';

class Connection {
  NodeField output;
  NodeField input;

  PathElement path;

  Connection(){
    initPath();
  }

  void initPath() {
    path =
        document.createElementNS(NodeEditor.editor.svg.namespaceUri, 'path');
    path.setAttributeNS(null, 'stroke', '#8e8e8e');
    path.setAttributeNS(null, 'stroke-width', '2');
    path.setAttributeNS(null, 'fill', 'none');
    NodeEditor.editor.svg.children.add(path);
  }

  /// Create string representing a svg curve path between two points
  void setPath(Point<int> fromPoint, Point<int> toPoint) {
    Point<int> diff =
    new Point<int>(toPoint.x - fromPoint.x, toPoint.y - fromPoint.y);

    String pathStr = 'M${fromPoint.x},${fromPoint.y} ';
    pathStr += 'C';
    pathStr += '${fromPoint.x + diff.x / 3 * 2},${fromPoint.y} ';
    pathStr += '${fromPoint.x + diff.x / 3},${toPoint.y} ';
    pathStr += '${toPoint.x - 7},${toPoint.y}';// Todo (jpu) : -7 ??

    path.setAttributeNS(null, 'd', pathStr);
  }

  void deletePath() {
    path.attributes.remove('d');
  }
}