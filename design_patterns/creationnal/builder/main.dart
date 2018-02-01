import 'dart:async';

/// Exemple using Builder Design Pattern
/// Based on http://www.dofactory.com/net/builder-design-pattern
///
/// Separate the construction of a complex object from its representation so
/// that the same construction process can create different representations.
Future main() async {
  // Create director and builders
  Director director = new Director();

  Builder b1 = new ConcreteBuilder1();
  Builder b2 = new ConcreteBuilder2();

  // Construct two products
  director.construct(b1);
  Product p1 = b1.getResult();
  p1.show();

  director.construct(b2);
  Product p2 = b2.getResult();
  p2.show();
}

/// The 'Director' class
class Director {
  // Builder uses a complex series of steps
  void construct(Builder builder) {
    builder.buildPartA();
    builder.buildPartB();
  }
}

/// The 'Builder' abstract class
abstract class Builder {
  void buildPartA();
  void buildPartB();
  Product getResult();
}

/// The 'ConcreteBuilder1' class
class ConcreteBuilder1 extends Builder {
  Product _product = new Product();

  void buildPartA() {
    _product.add("PartA");
  }

  void buildPartB() {
    _product.add("PartB");
  }

  Product getResult() {
    return _product;
  }
}

/// The 'ConcreteBuilder2' class
class ConcreteBuilder2 extends Builder {
  Product _product = new Product();

  void buildPartA() {
    _product.add("PartX");
  }

  void buildPartB() {
    _product.add("PartY");
  }

  Product getResult() {
    return _product;
  }
}

/// The 'Product' class
class Product {
  List<String> _parts = new List<String>();

  void add(String part) {
    _parts.add(part);
  }

  void show() {
    print("\nProduct Parts -------");
    for (String part in _parts) {
      print(part);
    }
  }
}
