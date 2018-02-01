import 'dart:async';
import 'dart:convert';
import 'package:stream_channel/stream_channel.dart';
import 'package:collection/collection.dart';

//used to compare list
Function eq = const DeepCollectionEquality().equals;

Future main() async{
  await exemple01;
}

/// Creation of a stream-channel
/// The stream channel can be typed : StreamChannel<type>
/// The stream and sink both are from 2 StreamController (async library) : a sender and a receiver
/// stream is for the receiver ?
/// sink is for the sender ?
Future get exemple01 async {
  StreamController streamController = new StreamController();
  StreamController sinkController = new StreamController();

  StreamChannel<String> channel = new StreamChannel(streamController.stream, sinkController.sink);

  var transformed =
  channel.transform(new StreamChannelTransformer.fromCodec(UTF8));

  streamController.add([102, 111, 111, 98, 97, 114]);//List<byte> will be transformed in String 'foobar'
  streamController.close();
  List list1 = await transformed.stream.toList();
  assert(eq(list1, ["foobar"]));

  transformed.sink.add("fblthp");//Sent String will be transformed into bytes
  transformed.sink.close();

  List list2 = await sinkController.stream.toList();
  assert(eq(list2, [[102, 98, 108, 116, 104, 112]]));
}