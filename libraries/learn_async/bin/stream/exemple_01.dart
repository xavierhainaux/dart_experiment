import 'dart:async';
import 'dart:io';

///Working exemple
class Application {
  // Create a stream controller and assign its stream to "onExit".
  // sync should be true in this case else event won't fire before exit, because exit doesn't car about async data and can miss important one
  StreamController<String> controller = new StreamController<String>(sync: true);
  Stream get onExit => controller.stream;

  Application() {
    print('controller.hasListener : ${controller.hasListener}');
    // Create some class that uses our stream.
    new UserOfStream(this);
    print('controller.hasListener : ${controller.hasListener}');

    // Whenever we exit the application, notify everyone about it first.
    controller.add('we are shutting down!');
    exit(0);
  }
}

class UserOfStream {
  UserOfStream(app) {
    app.onExit.listen(onExitHandler);
  }

  void onExitHandler(String message){
    print(message);
  }
}

main() => new Application();
