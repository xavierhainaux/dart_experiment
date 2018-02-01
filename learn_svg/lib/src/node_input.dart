import 'dart:async';
import 'dart:html';

import 'package:learn_svg/src/node_utils.dart';

class NodeInput{

  Element domElement;

  Stream get onClick => domElement.onClick;

  NodeInput(){
    domElement = document.createElement('span');
    domElement.classes.add('output');
    domElement.innerHtml = '&nbsp;';
  }
}