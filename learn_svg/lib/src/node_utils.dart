import 'node_field.dart';

class Offset {
  int x, y;
  int top, left;

  @override
  String toString() {
    return 'Offset{x: $x, y: $y, top: $top, left: $left}';
  }
}

class Connection {
  NodeField output;
  NodeField input;

  int index;// Todo (jpu) :should be deleted

//  PathElement _path;
//
//  Connection(){
//    _initPath();
//  }
//
//  void _initPath() {
//    _path = document.createElementNS(NodeEditor.editor.svg.namespaceUri, 'path');
//    _path.setAttributeNS(null, 'stroke', '#8e8e8e');
//    _path.setAttributeNS(null, 'stroke-width', '2');
//    _path.setAttributeNS(null, 'fill', 'none');
//    NodeEditor.editor.svg.children.add(_path);
//  }
//
//  void deletePath(){
//    _path.attributes.remove('d');
//  }
}




