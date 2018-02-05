import 'package:learn_svg/src/nodes/node.dart';

class NodeDivide extends Node{
  NodeDivide():super('Multiply'){
    addOutputField<int>('Value', 0);
    addInputField<int>('inputValue 1', 0);
    addInputField<int>('inputValue 2', 0);
    evaluationFunction = (Node node) {
      assert(node.inputFields[1].value != 0);
      node.outputFields[0].value =
          node.inputFields[0].value ~/ node.inputFields[1].value;
    };
  }
}