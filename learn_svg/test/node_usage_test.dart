import 'dart:html' hide Node;
import 'package:learn_svg/src/node.dart';
import "package:test/test.dart";

void main() {
  group("Node creation", () {
    test("new", () {
      Node node = new Node(null);
      expect(node, isNotNull);
    });
    test("name", () {
      final String name = 'Node 1';
      Node node = new Node(name);
      expect(node.name, name);
    });
    test("position", () {
      Node node = new Node('Node 1');
      expect(node.position, new Point<int>(0,0));

      node.position = new Point<int>(10,10);
      expect(node.position, new Point<int>(10,10));
    });
    test("output", () {
      Node node = new Node('Node 1');

      expect(node.outputs, isNotNull);
      expect(node.outputs.length, 0);
    });
    test("inputs", () {
      Node node = new Node('Node 1');

      expect(node.inputs, isNotNull);
      expect(node.inputs.length, 0);
    });
  });

  group("Node create inputs", () {
    test("new", () {
      Node node = new Node('Node 01');
      node.addInput('input01', 5);

      expect(node.inputs.length, 1);
      expect(node.inputs[0].value, 5);
      expect(node.inputs[0].name, 'input01');
      expect(node.inputs[0].displayedName, 'input01   (int) : 5');
    });

  });

  group("Node create outputs", () {
    test("new", () {
      Node node = new Node('Node 01');
      node.addOutput('output01', 5);

      expect(node.outputs.length, 1);
      expect(node.outputs[0].value, 5);
      expect(node.outputs[0].name, 'output01');
      expect(node.outputs[0].displayedName, 'output01   (int) : 5');
    });

  });

  group("Node connect", () {

    test("initial condition", () {
      Node node01 = new Node('Node 01');
      node01.addOutput('output01', 5);

      Node node02 = new Node('Node 02');
      node02.addInput('input01', 3);

      /// vérifie qu'un output existe sans connection
      expect(node01.outputs.length, 1);
      expect(node01.outputs[0].value, 5);
      expect(node01.outputs[0].outputConnections.length, 0);
      expect(node01.inputs.length, 0);

      /// vérifie qu'un input existe sans connection
      expect(node02.outputs.length, 0);
      expect(node02.inputs.length, 1);
      expect(node02.inputs[0].value, 3);
      expect(node02.inputs[0].inputConnection, null);
    });

    test("new", () {
      Node node01 = new Node('Node 01');
      node01.addOutput('output01', 5);

      Node node02 = new Node('Node 02');
      node02.addInput('input01', 3);

      node01.outputs.first.connectTo(node02, 0);
      node02.evaluate();

      /// vérifie qu'un output existe avec connection connection
      expect(node01.outputs.length, 1);
      expect(node01.outputs[0].value, 5);
      expect(node01.outputs[0].outputConnections, isNotNull);
      expect(node01.inputs.length, 0);

      //la connection est la même
      expect(node01.outputs[0].outputConnections[0], node02.inputs[0].inputConnection);

      //la connection d'output a les bons output / inputs
      expect(node01.outputs[0].outputConnections[0].output, node01.outputs[0]);
      expect(node01.outputs[0].outputConnections[0].input, node02.inputs[0]);

      /// vérifie qu'un input existe sans connection
      expect(node02.outputs.length, 0);
      expect(node02.inputs.length, 1);
      //la valuer de l'ouput du node1
      expect(node02.inputs[0].value, node01.outputs[0].value);
      expect(node02.inputs[0].value, 5);

      //la connection d'output a les bons output / inputs
      expect(node02.inputs[0].inputConnection.output, node01.outputs[0]);
      expect(node02.inputs[0].inputConnection.input, node02.inputs[0]);
    });

    test("evaluationFunction", () {
      Node node = new Node('Node 1');

      expect(node.evaluationFunction, isNull);
    });

  });

}