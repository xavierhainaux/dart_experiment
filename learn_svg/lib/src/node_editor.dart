import 'dart:html' hide Node;
import 'dart:svg' hide Point;
import 'package:learn_svg/src/node_utils.dart';
import 'node_field.dart';
import 'package:vector_math/vector_math.dart';

class NodeEditor{

  static final NodeEditor editor = new NodeEditor._();

  NodeField currentOutput;
  SvgElement svg;

  NodeEditor._(){
    svg = new SvgElement.tag("svg");
    document.body.children.add(svg);

    window.onClick.listen((e) {
      if (currentOutput != null) {
        currentOutput.deletePath();
        if (currentOutput.toNode != null) {
          //Todo (jpu) : ?? never pass here ??
          currentOutput.toNode.detachOutput(currentOutput);
        }
        currentOutput = null;
      }
    });

    window.onMouseMove.listen((MouseEvent e) {
      if (currentOutput != null) {
        Point<int> mousePosition = new Point<int>(e.client.x, e.client.y);
        currentOutput.drawTemporaryPath(mousePosition);
      }
    });
  }

  static Offset getFullOffset(Element element) {
    Vector3 transform = getCssTransform(element);

    Offset offset = new Offset()
      ..top = element.offsetTop + transform.y.toInt()
      ..left = element.offsetLeft + transform.x.toInt();


    if (element.offsetParent != null) {
      Offset parentOffset = getFullOffset(element.offsetParent);
      offset.top += parentOffset.top;
      offset.left += parentOffset.left;
    }

    return offset;
  }

  static Vector3 getCssTransform(Element element) {
    Vector3 result = new Vector3.zero();

    RegExp regExp = new RegExp(r'translate3d\((.+)px, (.+)px, (.+)px\)');
    var matches = regExp.allMatches(element.style.transform);
    if(matches.length > 0) {
      var match = matches.elementAt(0); // => extract the first (and only) match
      result.setValues(
          double.parse(match.group(1)),
          double.parse(match.group(2)),
          double.parse(match.group(3)));
    }

    return result;
  }
}