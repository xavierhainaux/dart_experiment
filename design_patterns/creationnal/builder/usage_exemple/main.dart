import 'dart:async';

/// Exemple using Builder Design Pattern
/// Based on http://www.dofactory.com/net/builder-design-pattern
///
/// Separate the construction of a complex object from its representation so
/// that the same construction process can create different representations.
///
/// This real-world code demonstates the Builder pattern in which different
/// vehicles are assembled in a step-by-step fashion. The Shop uses
/// VehicleBuilders to construct a variety of Vehicles in a series of sequential steps.
Future main() async {
  VehicleBuilder builder;

  // Create shop with vehicle builders
  Shop shop = new Shop();

  // Construct and display vehicles
  builder = new ScooterBuilder();
  shop.Construct(builder);
  builder.vehicle.Show();

  builder = new CarBuilder();
  shop.Construct(builder);
  builder.vehicle.Show();

  builder = new MotorCycleBuilder();
  shop.Construct(builder);
  builder.vehicle.Show();
}

/// The 'Director' class
class Shop {
  // Builder uses a complex series of steps

  void Construct(VehicleBuilder vehicleBuilder) {
    vehicleBuilder.BuildFrame();
    vehicleBuilder.BuildEngine();
    vehicleBuilder.BuildWheels();
    vehicleBuilder.BuildDoors();
  }
}

/// The 'Builder' abstract class
abstract class VehicleBuilder {
  Vehicle _vehicle;

  // Gets vehicle instance

  Vehicle get vehicle => _vehicle;

  // Abstract build methods

  void BuildFrame();
  void BuildEngine();
  void BuildWheels();
  void BuildDoors();
}

/// The 'ConcreteBuilder1' class
class MotorCycleBuilder extends VehicleBuilder {
  MotorCycleBuilder() {
    _vehicle = new Vehicle("MotorCycle");
  }

  @override
  void BuildFrame() {
    _vehicle["frame"] = "MotorCycle Frame";
  }

  @override
  void BuildEngine() {
    _vehicle["engine"] = "500 cc";
  }

  @override
  void BuildWheels() {
    _vehicle["wheels"] = "2";
  }

  @override
  void BuildDoors() {
    _vehicle["doors"] = "0";
  }
}

/// The 'ConcreteBuilder2' class
class CarBuilder extends VehicleBuilder {
  CarBuilder() {
    _vehicle = new Vehicle("Car");
  }

  @override
  void BuildFrame() {
    _vehicle["frame"] = "Car Frame";
  }

  @override
  void BuildEngine() {
    _vehicle["engine"] = "2500 cc";
  }

  @override
  void BuildWheels() {
    _vehicle["wheels"] = "4";
  }

  @override
  void BuildDoors() {
    _vehicle["doors"] = "4";
  }
}

/// The 'ConcreteBuilder3' class
class ScooterBuilder extends VehicleBuilder {
  ScooterBuilder() {
    _vehicle = new Vehicle("Scooter");
  }

  @override
  void BuildFrame() {
    _vehicle["frame"] = "Scooter Frame";
  }

  @override
  void BuildEngine() {
    _vehicle["engine"] = "50 cc";
  }

  @override
  void BuildWheels() {
    _vehicle["wheels"] = "2";
  }

  @override
  void BuildDoors() {
    _vehicle["doors"] = "0";
  }
}

/// The 'Product' class
class Vehicle {
  String _vehicleType;
  Map<String, String> _parts = new Map<String, String>();

  // Constructor
  Vehicle(String vehicleType) {
    this._vehicleType = vehicleType;
  }

  // Indexer
  operator [](String i) => _parts[i]; // get
  operator []=(String i, String value) => _parts[i] = value; // set

  void Show() {
    print("\n---------------------------");
    print("Vehicle Type: $_vehicleType");
    print(" Frame extends ${_parts["frame"]}");
    print(" Engine extends ${_parts["engine"]}");
    print(" #Wheels: ${_parts["wheels"]}");
    print(" #Doors extends ${_parts["doors"]}");
  }
}
