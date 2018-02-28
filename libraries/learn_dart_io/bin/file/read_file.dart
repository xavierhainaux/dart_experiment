import 'dart:io';

main(){
  Directory current = Directory.current; // this gives the project path
  print(current);

  File file = new File("bin/file/test.txt");
  assert(file != null);
  String content = file.readAsStringSync();
  assert(content == "Hello, World!");
  print(content);
}