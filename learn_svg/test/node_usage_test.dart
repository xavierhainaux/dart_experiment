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

      expect(node.outputFields, isNotNull);
      expect(node.outputFields.length, 0);
    });
    test("inputs", () {
      Node node = new Node('Node 1');

      expect(node.inputFields, isNotNull);
      expect(node.inputFields.length, 0);
    });
  });

  group("Node create inputs", () {
    test("new", () {
      Node node = new Node('Node 01');
      node.addInputField('input01', 5);

      expect(node.inputFields.length, 1);
      expect(node.inputFields[0].value, 5);
      expect(node.inputFields[0].name, 'input01');
      expect(node.inputFields[0].displayedName, 'input01   (int) : 5');
    });

  });

  group("Node create outputs", () {
    test("new", () {
      Node node = new Node('Node 01');
      node.addOutputField('output01', 5);

      expect(node.outputFields.length, 1);
      expect(node.outputFields[0].value, 5);
      expect(node.outputFields[0].name, 'output01');
      expect(node.outputFields[0].displayedName, 'output01   (int) : 5');
    });

  });

  group("Node connect", () {

    test("initial condition", () {
      Node node01 = new Node('Node 01');
      node01.addOutputField('output01', 5);

      Node node02 = new Node('Node 02');
      node02.addInputField('input01', 3);

      /// vérifie qu'un output existe sans connection
      expect(node01.outputFields.length, 1);
      expect(node01.outputFields[0].value, 5);
      expect(node01.outputFields[0].outputConnections.length, 0);
      expect(node01.inputFields.length, 0);

      /// vérifie qu'un input existe sans connection
      expect(node02.outputFields.length, 0);
      expect(node02.inputFields.length, 1);
      expect(node02.inputFields[0].value, 3);
      expect(node02.inputFields[0].inputConnection, null);
    });

    test("new base 2 simple nodes", () {
      Node node01 = new Node('Node 01');
      node01.addOutputField('output01', 5);

      Node node02 = new Node('Node 02');
      node02.addInputField('input01', 3);

      node01.outputFields.first.connectTo(node02, 0);
      node02.evaluate();

      /// vérifie qu'un output existe avec connection connection
      expect(node01.outputFields.length, 1);
      expect(node01.outputFields[0].value, 5);
      expect(node01.outputFields[0].outputConnections.length, 1);
      expect(node01.inputFields.length, 0);

      //la connection est la même
      expect(node01.outputFields[0].outputConnections[0], node02.inputFields[0].inputConnection);

      //la connection d'output a les bons output / inputs
      expect(node01.outputFields[0].outputConnections[0].outputField, node01.outputFields[0]);
      expect(node01.outputFields[0].outputConnections[0].inputField, node02.inputFields[0]);

      /// vérifie qu'un input existe sans connection
      expect(node02.outputFields.length, 0);
      expect(node02.inputFields.length, 1);
      //la valuer de l'ouput du node1
      expect(node02.inputFields[0].value, node01.outputFields[0].value);
      expect(node02.inputFields[0].value, 5);

      //la connection d'output a les bons output / inputs
      expect(node02.inputFields[0].inputConnection.outputField, node01.outputFields[0]);
      expect(node02.inputFields[0].inputConnection.inputField, node02.inputFields[0]);
    });

    test("new base 3 simple nodes", () {
      Node node01 = new Node('Node 01');
      node01.addOutputField('01 output 01', 5);

      Node node02 = new Node('Node 02');
      node02.addOutputField('02 output 01', 9);
      node02.addInputField('02 input 01', 3);
      node02.evaluationFunction = (Node node) {
        node.outputFields[0].value = node.inputFields[0].value;
      };

      Node node03 = new Node('Node 03');
      node03.addInputField('03 input 01', 7);

      node01.outputFields.first.connectTo(node02, 1);
      node02.outputFields.first.connectTo(node03, 0);
      node03.evaluate();

      //node 1 state
      expect(node01.outputFields.length, 1);
      expect(node01.outputFields[0].value, 5);
      expect(node01.inputFields.length, 0);

      //node 2 state
      expect(node02.outputFields.length, 1);
      expect(node02.outputFields[0].value, 5);//should be same as node 1 output value
      expect(node02.outputFields[0].value, node01.outputFields[0].value);//should be same as node 1 output value
      expect(node02.inputFields.length, 1);

      //node 3 state
      expect(node03.outputFields.length, 0);
      expect(node03.inputFields.length, 1);
      expect(node03.inputFields[0].inputConnection, isNotNull);
      expect(node03.inputFields[0].value, node01.outputFields[0].value);//should be same as node 1 output value

      /// vérifie qu'un output existe avec connection 1
      expect(node01.outputFields[0].outputConnections.length, 1);
      expect(node02.inputFields[0].inputConnection, isNotNull);
      expect(node01.outputFields[0].outputConnections[0], node02.inputFields[0].inputConnection);

      /// vérifie qu'un output existe avec connection 2
      expect(node02.outputFields[0].outputConnections.length, 1);
      expect(node03.inputFields[0].inputConnection, isNotNull);
      expect(node02.outputFields[0].outputConnections[0], node03.inputFields[0].inputConnection);
    });

    test("evaluationFunction", () {
      Node node = new Node('Node 1');

      expect(node.evaluationFunction, isNull);
    });

  });

}