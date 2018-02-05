import 'package:learn_svg/src/nodes/node.dart';

class NodeInt extends Node{
  NodeInt(int value):super('Int'){
    value = value ?? 1;
    addOutputField<int>('Value', value);
  }
}