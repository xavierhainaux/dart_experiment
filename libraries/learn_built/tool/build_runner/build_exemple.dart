import 'package:build_runner/build_runner.dart';
import 'package:learn_built/copy_builder.dart';

/// This script use a Builder [CopyBuilder]  copy the files in the [inputs] folder
/// check infos here : https://pub.dartlang.org/packages/build_runner/versions/0.6.1#-readme-tab-
main() async {
  await build([
    new BuildAction(
      new CopyBuilder('.copy'),
      'learn_built',
      inputs: ['lib/build_runner/*.dart'],
    ),
  ]);
}
