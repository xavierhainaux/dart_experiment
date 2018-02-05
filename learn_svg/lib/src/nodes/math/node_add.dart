import 'package:learn_svg/src/nodes/node.dart';

class NodeAdd extends Node{
  NodeAdd():super('Add'){
    addOutputField<int>('Result', 0);
    addInputField<int>('inputValue 1', 0);
    addInputField<int>('inputValue 2', 0);
    evaluationFunction = (Node node) {
      node.outputFields[0].value =
          node.inputFields[0].value + node.inputFields[1].value;
    };
  }
}