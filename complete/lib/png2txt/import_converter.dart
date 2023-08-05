/*
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:args/args.dart';

// Define a list to hold the paths to the input PNG files
List<String> filePaths = [];

String readMetadata(String filePath) {
  final bytes = File(filePath).readAsBytesSync();
  final reader = img.PngDecoder();
  final img.Image image = reader.decodeImage(Uint8List.fromList(bytes))!;
  
  final List<img.Chunk> chunks = reader.decodeChunks(Uint8List.fromList(bytes))!;

  for (final chunk in chunks) {
    if (chunk.type == 'tEXt') {
      final Map<String, Uint8List> textChunks = img.extractTextChunks(chunk);
      final metadata = textChunks['chara'];
      if (metadata != null) {
        return utf8.decode(metadata);
      }
    }
  }
  throw Exception("The specified metadata 'chara' was not found in the PNG file: $filePath");
}

String decodeBase64(String data) {
  try {
    final decodedData = base64.decode(data);
    // Ignore and remove invalid byte sequences
    return utf8.decode(decodedData);
  } catch (e) {
    throw Exception("Failed to decode the base64 data.");
  }
}

Map<String, dynamic> parseJson(String data) {
  try {
    return json.decode(data);
  } catch (e) {
    throw Exception("Failed to parse the JSON data.");
  }
}

String sanitizeFileName(String fileName) {
  final sanitizedFileName = fileName.replaceAll(RegExp(r'[^\w\-_]'), '');
  return sanitizedFileName.replaceAll(' ', '_');
}

void resizeImage(String imageFilePath, String outputFilePath) {
  final img.Image imgData = img.decodeImage(File(imageFilePath).readAsBytesSync())!;
  final newWidth = imgData.width < 390 ? imgData.width : 390;
  final newHeight = (newWidth / imgData.width * imgData.height).toInt();
  final resizedImage = img.copyCrop(imgData, 0, 0, newWidth, newHeight);
  final resizedPng = img.encodePng(resizedImage);
  File(outputFilePath).writeAsBytesSync(resizedPng);
}

void createJson(Map<String, dynamic> data, String fileName) {
  final newJsonData = {
    'char_name': data['name'],
    'char_persona': data['personality'],
    'char_greeting': data['first_mes'],
    'world_scenario': data['scenario'],
    'example_dialogue': data['mes_example'],
  };

  final jsonString = json.encode(newJsonData);
  File(fileName).writeAsStringSync(jsonString);
}

void copyImage(String imageFilePath, String outputFilePath) {
  final img.Image imgData = img.decodeImage(File(imageFilePath).readAsBytesSync())!;
  final pngData = img.encodePng(imgData);
  File(outputFilePath).writeAsBytesSync(pngData);
}

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('output', abbr: 'o', defaultsTo: '.', help: 'Output directory (default: current directory)');
  final args = parser.parse(arguments);

  // Find all the PNG files that match the input paths using glob
  for (final inputPath in args.rest) {
    final files = Directory(inputPath).listSync(recursive: false);
    for (final file in files) {
      if (file.path.endsWith('.png')) {
        filePaths.add(file.path);
      }
    }
  }

  // Process each PNG file in the list
  for (final filePath in filePaths) {
    try {
      // Read the metadata from the PNG file
      final metadata = readMetadata(filePath);
      // Decode the base64-encoded metadata to get the JSON data
      final decodedData = decodeBase64(metadata);
      // Parse the JSON data
      final jsonData = parseJson(decodedData);
      print("File: $filePath");

      // Create a JSON file for the JSON data
      final jsonFileName = '${sanitizeFileName(jsonData['name'])}.json';
      final jsonOutputPath = path.join(args['output'], jsonFileName);
      createJson(jsonData, jsonOutputPath);
      print("JSON file created: $jsonOutputPath");

      // Copy the PNG file and save it with the same name as the corresponding JSON file
      final pngFileName = '${sanitizeFileName(jsonData['name'])}.png';
      final pngOutputPath = path.join(args['output'], pngFileName);
      copyImage(filePath, pngOutputPath);
      print("PNG file copied and saved: $pngOutputPath");

      print("=" * 40);
    } catch (e) {
      print(e);
      print("=" * 40);
    }
  }
}
*/