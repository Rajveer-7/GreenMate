import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';

class ScanPageDetailed extends StatefulWidget {
  const ScanPageDetailed({super.key});

  @override
  State<ScanPageDetailed> createState() => _ScanPageDetailedState();
}

class _ScanPageDetailedState extends State<ScanPageDetailed> {
  final ImagePicker imagePicker = ImagePicker();
  late ImageLabeler imageLabeler;
  late ObjectDetector objectDetector;
  File? _image;
  String result = 'Not sure which plant you have? Let us help';
  List<DetectedObject> objects = [];
  var image;
  bool isObjectDetection = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    final modelPath = await getModelPath('assets/ml/model_plant_species_50.tflite');

    final labelerOptions = LocalLabelerOptions(
      confidenceThreshold: 0.5,
      modelPath: modelPath,
    );
    imageLabeler = ImageLabeler(options: labelerOptions);

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
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        isObjectDetection = false;
      });
      doImageLabeling();
    }
  }

  Future<void> _imgFromGallery() async {
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        isObjectDetection = false;
      });
      doImageLabeling();
    }
  }

  Future<void> _multiPlantFromCamera() async {
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        isObjectDetection = true;
      });
      doObjectDetection();
    }
  }

  Future<void> doImageLabeling() async {
    if (_image == null) return;

    final inputImage = InputImage.fromFile(_image!);
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

    final StringBuffer buffer = StringBuffer();
    for (ImageLabel label in labels) {
      buffer.writeln("This is a ${label.label} plant species.");
      buffer.writeln("Confidence Score: ${label.confidence.toStringAsFixed(2)}\n");
    }

    setState(() {
      result = buffer.isNotEmpty
          ? buffer.toString()
          : "Not able to detect plant, please try another image.";
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

    drawRectanglesAroundObjects();
  }

  drawRectanglesAroundObjects() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    setState(() {});
  }

  Future<String> getModelPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);

    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(
          byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Plant Scanner"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Image and result area
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isObjectDetection) ...[
                      _image != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          _image!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                          : const Icon(Icons.camera_alt, size: 100, color: Colors.black),
                      const SizedBox(height: 20),
                      Text(
                        result,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ] else ...[
                      Container(
                        width: 200,
                        height: 200,
                        child: image != null
                            ? FittedBox(
                          child: SizedBox(
                            width: image.width.toDouble(),
                            height: image.width.toDouble(),
                            child: CustomPaint(
                              painter:
                              ObjectPainter(objectList: objects, imageFile: image),
                            ),
                          ),
                        )
                            : Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.camera_alt,
                              color: Colors.black, size: 50),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          // Button section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
            child: Column(
              children: [
                _customButton("Camera", Icons.camera_alt, _imgFromCamera),
                const SizedBox(height: 10),
                _customButton("Gallery", Icons.photo_library, _imgFromGallery),
                const SizedBox(height: 10),
                _customButton("Multi Plant", Icons.layers, _multiPlantFromCamera),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _customButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 22),
      label: Text(label, style: const TextStyle(fontSize: 15)),
    );
  }
}

class ObjectPainter extends CustomPainter {
  List<DetectedObject> objectList;
  dynamic imageFile;

  ObjectPainter({required this.objectList, required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    Paint p = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (DetectedObject obj in objectList) {
      canvas.drawRect(obj.boundingBox, p);

      for (Label label in obj.labels) {
        TextSpan span = TextSpan(
            text: label.text,
            style: const TextStyle(fontSize: 16, color: Colors.black));
        TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, Offset(obj.boundingBox.left, obj.boundingBox.top));
        break;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
