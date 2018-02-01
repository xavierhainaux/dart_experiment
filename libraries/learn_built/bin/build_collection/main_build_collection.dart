import 'package:built_collection/built_collection.dart';

/// https://medium.com/dartlang/darts-built-collection-for-immutable-collections-db662f705eff
/// more infos : https://github.com/google/built_collection.dart
///
/// Built Collections are comparable and hashable.
/// This means you can put them in maps, sets, and multimaps, creating exactly
/// the collections to match your data.
main(){

  //new BuiltList([1, 2, 3]);     // Throws an exception! type must be defined
  //new BuiltList([1, 2, null]);  // Throws an exception! value mustn't be null
  //this is an immutable List
  var list = new BuiltList<int>([1, 2, 3]);

  //adding a value to the immutable list must create a new one
  var builder = list.toBuilder();
  builder.add(4);
  var newList = builder.build();

  //or in one line
  var newList2 = (list.toBuilder()..add(4)).build();

  //or better with lambda
  var newList3 = list.rebuild((b) => b.add(4));
}