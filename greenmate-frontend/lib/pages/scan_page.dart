import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';

import '../components/plant_tile.dart';
import '../models/plant.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker imagePicker = ImagePicker();
  late ImageLabeler imageLabeler;
  late ObjectDetector objectDetector;
  File? _image;
  String result = 'Not sure which plant you have? Let use help';
  List<DetectedObject> objects = [];
  var image;
  bool isObjectDetection = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    final modelPath = await getModelPath(
        'assets/ml/model_plant_species_50.tflite');

    // Load for image labeling
    final labelerOptions = LocalLabelerOptions(
      confidenceThreshold: 0.5,
      modelPath: modelPath,
    );
    imageLabeler = ImageLabeler(options: labelerOptions);

    // Load for object detection
    final detectorOptions = LocalObjectDetectorOptions(
      mode: DetectionMode.single,
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
    );
    objectDetector = ObjectDetector(options: detectorOptions);
  }

  @override
  void dispose() {
    imageLabeler.close();
    objectDetector.close();
    super.dispose();
  }

  Future<void> _imgFromCamera() async {
    try {
      final XFile? pickedFile = await imagePicker.pickImage(
          source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          isObjectDetection = false;
        });
        doImageLabeling();
      }
    } catch (e) {
      debugPrint("Error picking image from camera: $e");
    }
  }

  Future<void> _imgFromGallery() async {
    try {
      final XFile? pickedFile = await imagePicker.pickImage(
          source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          isObjectDetection = false;
        });
        doImageLabeling();
      }
    } catch (e) {
      debugPrint("Error picking image from gallery: $e");
    }
  }

  Future<void> _multiPlantFromCamera() async {
    try {
      final XFile? pickedFile = await imagePicker.pickImage(
          source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          isObjectDetection = true;
        });
        doObjectDetection();
      }
    } catch (e) {
      debugPrint("Error picking image from camera: $e");
    }
  }

  Future<void> doImageLabeling() async {
    if (_image == null) return;

    final inputImage = InputImage.fromFile(_image!);

    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

    final StringBuffer buffer = StringBuffer();
    for (ImageLabel label in labels) {
      buffer.writeln("This is a ${label.label} plant species.");
      buffer.writeln(
          "Confidence Score: ${label.confidence.toStringAsFixed(2)}\n");
    }

    setState(() {
      result = buffer.isNotEmpty
          ? buffer.toString()
          : "Not able to detect plant, please click another image.";
    });
  }

  Future<void> doObjectDetection() async {
    if (_image == null) return;

    InputImage inputImage = InputImage.fromFile(_image!);

    objects = await objectDetector.processImage(inputImage);

    for (DetectedObject detectedObject in objects) {
      for (Label label in detectedObject.labels) {
        print('${label.text} ${label.confidence}');
      }
    }

    setState(() {});
    drawRectanglesAroundObjects();
  }

  drawRectanglesAroundObjects() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    setState(() {
      image;
      objects;
    });
  }

  Future<String> getModelPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);

    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(byteData.buffer.asUint8List(
          byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Weather
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            children: [
              Text(
                "Brampton- 11C",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
        ),

        // Image and Results Section
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isObjectDetection) ...[
                  _image != null
                      ? Image.file(
                      _image!, width: 200, height: 200, fit: BoxFit.cover)
                      : const Icon(
                      Icons.camera_alt, size: 100, color: Colors.black),

                  const SizedBox(height: 20),

                  Text(
                    result,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ] else
                  ...[
                    Container(
                      width: 200,
                      height: 200,
                      child: image != null
                          ? Center(
                        child: FittedBox(
                          child: SizedBox(
                            width: image.width.toDouble(),
                            height: image.width.toDouble(),
                            child: CustomPaint(
                              painter: ObjectPainter(
                                  objectList: objects, imageFile: image),
                            ),
                          ),
                        ),
                      )
                          : Container(
                        color: Colors.grey,
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 53,
                        ),
                      ),
                    ),
                  ],
              ],
            ),
          ),
        ),

        // Buttons
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _imgFromCamera,
                icon: Icon(Icons.camera_alt, color: Colors.grey[800], size: 20),
                label: Text("Camera",
                    style: TextStyle(fontSize: 15, color: Colors.grey[800])),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: _imgFromGallery,
                icon: Icon(
                    Icons.photo_library, color: Colors.grey[800], size: 20),
                label: Text("Gallery",
                    style: TextStyle(fontSize: 15, color: Colors.grey[800])),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: _multiPlantFromCamera,
                icon: Icon(Icons.layers, color: Colors.grey[800], size: 20),
                label: Text("Multi Plant",
                    style: TextStyle(fontSize: 15, color: Colors.grey[800])),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ObjectPainter extends CustomPainter {
  List<DetectedObject> objectList;
  dynamic imageFile;
  ObjectPainter({required this.objectList, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }
    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 32;

    for (DetectedObject rectangle in objectList) {
      canvas.drawRect(rectangle.boundingBox, p);
      var list = rectangle.labels;
      for(Label label in list){
        print("${label.text}   ${label.confidence.toStringAsFixed(2)}");
        TextSpan span = TextSpan(text: label.text,style: const TextStyle(fontSize: 200,color: Colors.black));
        TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left,textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, Offset(rectangle.boundingBox.left,rectangle.boundingBox.top));
        break;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}