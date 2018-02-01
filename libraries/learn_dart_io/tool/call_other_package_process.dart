///This exemple shows how to caal a script in another package
import 'dart:convert';
import 'dart:io';

String sheet = 'text';
List<String> tabs = ['str01', 'str02', 'str03'];

main(){
  Directory.current = Platform.script.resolve('../../learn_args/').toFilePath();
  runScript('tool/base_args.dart', ['--sheet=$sheet','--tabs=${tabs.join(',')}']);
}

runScript(String script, List<String> arguments) {

  final lineSplitter = new LineSplitter();
  final String dartExecutable = Platform.resolvedExecutable;

  return Process.start(dartExecutable, [script]..addAll(arguments)).then((Process process) {
    lineSplitter.bind(UTF8.decoder.bind(process.stdout)).listen((line) {
      print(line);
    });

    lineSplitter.bind(UTF8.decoder.bind(process.stderr)).listen((line) {
      print('Error: $line');

      throw '$line';
    });

    return process.exitCode;
  });
}
