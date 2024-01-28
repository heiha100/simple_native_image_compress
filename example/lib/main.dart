import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_native_image_compress/simple_native_image_compress.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _picker = ImagePicker();
  final _compress = SimpleNativeImageCompress();

  Uint8List? _bytes;

  Future<void> _compressImage() async {
    String filePath = '';
    if (Platform.isMacOS) {
      final res = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: false);
      if (res == null) return;
      if (res.files.isEmpty) return;
      filePath = res.files[0].path!;
    } else {
      final file = await _picker.pickImage(source: ImageSource.gallery);
      if (file == null) return;
      filePath = file.path;
    }
    try {
      final bytes = await _compress.contain(
        filePath: filePath,
        compressFormat: CompressFormat.Jpeg,
      );
      setState(() {
        _bytes = bytes;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _saveImage() async {
    if (Platform.isMacOS) return;
    String? outputFilePath = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file location',
      type: FileType.image,
    );

    if (outputFilePath == null) return;
    final tempFile = File(outputFilePath);
    await tempFile.create(recursive: true);
    RandomAccessFile raf = tempFile.openSync(mode: FileMode.write);
    try {
      raf.writeFromSync(_bytes!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _compressImage,
                child: const Text('Choose an image'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _bytes != null
                    ? InkWell(
                        onSecondaryTap: _saveImage,
                        child: Image.memory(_bytes!))
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
