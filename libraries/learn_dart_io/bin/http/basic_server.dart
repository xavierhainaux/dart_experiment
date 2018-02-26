import 'dart:async';
import 'dart:io';

///> try to access localhost:1234 and server will repsonse : 'Hello, world!'

Future main()async {
  HttpServer server = await HttpServer.bind('localhost', 1234);
  server.defaultResponseHeaders.set('Access-Control-Allow-Origin', '*');

  await for (HttpRequest request in server) {
    request.response
      ..write('Hello, world!')
      ..close();
  }
}

