import 'dart:async';
import 'package:build/build.dart';

/// A really simple [Builder], it just makes copies!
/// (jpu) from https://pub.dartlang.org/packages/build#-readme-tab-
class CopyBuilder implements Builder {

  final String extension;

  CopyBuilder(this.extension);

  Future build(BuildStep buildStep) async {
    /// Each [buildStep] has a single input.
    AssetId input = buildStep.inputId;

    /// Create a new target [AssetId] based on the old one.
    var copy = buildStep.inputId.addExtension(extension);
    var contents = await buildStep.readAsString(input);

    /// Write out the new asset.
    ///
    /// There is no need to `await` here, the system handles waiting on these
    /// files as necessary before advancing to the next phase.
    buildStep.writeAsString(copy, contents);
  }

  /// Configure output extensions. All possible inputs match the empty input
  /// extension. For each input 1 output is created with `extension` appended to
  /// the path.
  Map<String, List<String>> get buildExtensions =>  {'': [extension]};
}