import 'dart:io';
import 'package:path/path.dart' as path;

//from https://stackoverflow.com/questions/19934575/how-to-serve-files-with-httpserver-in-dart

String _basePath;

void main() {

  _basePath = r'';//set absollute folder path : d:\folder;

  HttpServer.bind('127.0.0.1', 1234).then((HttpServer server) {
    server.listen((request) {
      switch (request.method) {
        case 'GET':
          _handleGet(request);
          break;

        case 'POST':
          _handlePost(request);
          break;

        default:
          request.response.statusCode = HttpStatus.METHOD_NOT_ALLOWED;
          request.response.close();
      }
    });
  });
}

_sendNotFound(HttpResponse response) {
  response.write('Not found');
  response.statusCode = HttpStatus.NOT_FOUND;
  response.close();
}


_handleGet(HttpRequest request) {
  // PENDING: Do more security checks here?
  final String stringPath = request.uri.path == '/' ? './test.txt' : request.uri.path;
  final String fullPath = path.join(_basePath, stringPath);
  final File file = new File(fullPath);
  file.exists().then((bool found) {
    if (found) {
      file.openRead().pipe(request.response).catchError((e) { });

//      request.response.headers.add("Access-Control-Allow-Origin", "*");
//      request.response.headers.add("Access-Control-Allow-Methods", "POST,GET,DELETE,PUT,OPTIONS");
//
//      request.response.statusCode = HttpStatus.OK;
//      request.response.write("Success!");
//      request.response.close();

    } else {
      _sendNotFound(request.response);
    }
  });
}


_handlePost(HttpRequest request) {

}


