// This file initializes the dynamic library and connects it with the stub
// generated by flutter_rust_bridge_codegen.

import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'bridge_definitions.dart';
import 'bridge_generated.dart';

class SimpleNativeImageCompress {
  @protected
  static const base = 'native_image_compress';

  final path = Platform.isWindows ? '$base.dll' : 'lib$base.so';
  late final _dylib = Platform.isIOS
      ? DynamicLibrary.process()
      : Platform.isMacOS
          ? DynamicLibrary.executable()
          : DynamicLibrary.open(path);

  late final _api = NativeCompressImpl(_dylib);

  /// "contain" will make the image fit into the given max width/height.
  /// DEFAULT size is 1024px x 1024px
  Future<Uint8List> contain({
    required String filePath,
    CompressFormat? compressFormat,
    int? quality,
    int? maxWidth,
    int? maxHeight,
  }) async {
    return await _api.contain(
      pathStr: filePath,
      compressFormat: compressFormat,
      quality: quality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
  }

  /// "fitWidth" will make the image fit into the given max width.
  /// DEFAULT width is 1024px
  Future<Uint8List> fitWidth({
    required String filePath,
    CompressFormat? compressFormat,
    int? quality,
    int? maxWidth,
  }) async {
    return await _api.fitWidth(
      pathStr: filePath,
      compressFormat: compressFormat,
      quality: quality,
      maxWidth: maxWidth,
    );
  }

  /// "fitHeight" will make the image fit into the given max height.
  /// DEFAULT height is 1024px
  Future<Uint8List> fitHeight({
    required String filePath,
    CompressFormat? compressFormat,
    int? quality,
    int? maxHeight,
  }) async {
    return await _api.fitHeight(
      pathStr: filePath,
      compressFormat: compressFormat,
      quality: quality,
      maxHeight: maxHeight,
    );
  }
}
