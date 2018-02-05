import 'package:learn_svg/src/nodes/node.dart';

class NodeLog extends Node{
  NodeLog():super('Log'){
    addInputField<String>('value', "default value");
    isLauncher = true;
    evaluationFunction = (Node node) => print(node.inputFields[0].value);
  }
}