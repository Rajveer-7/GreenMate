import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ImagePicker imagePicker = ImagePicker();
  late ImageLabeler imageLabeler;
  late ObjectDetector objectDetector;
  File? _image;
  String result = 'Results will be shown here';
  List<DetectedObject> objects = [];
  var image;
  bool isObjectDetection = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    final modelPath = await getModelPath('assets/ml/plant_disease.tflite');

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
      final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
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
      final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
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
      final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
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
      buffer.writeln("Detected Disease: ${label.label}");
      buffer.writeln("Confidence Score: ${label.confidence.toStringAsFixed(2)}\n");
    }

    setState(() {
      result = buffer.isNotEmpty
          ? buffer.toString()
          : "Unable to identify plant disease. Please try another image.";
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
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Weather
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Plant Disease Identification',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.green[800]
                ),
              ),
              Text(
                'Identify plant health with AI',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600]
                ),
              ),
            ],
          ),
        ),

        // Image and Results Section
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isObjectDetection) ...[
                    _image != null
                        ? Image.file(_image!, width: 200, height: 200, fit: BoxFit.cover)
                        : const Icon(Icons.medical_services_outlined, size: 100, color: Colors.green),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        result,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: 250,
                      height: 250,
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
                          Icons.medical_services_outlined,
                          color: Colors.green,
                          size: 53,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
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
            icon: Icon(Icons.camera_alt, color: Colors.green[800], size: 20),
            label: Text("Camera", style: TextStyle(fontSize: 15, color: Colors.green[800])),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[100]
            ),

            ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _imgFromGallery,
                icon: Icon(Icons.photo_library, color: Colors.green[800], size: 20),
                label: Text("Gallery", style: TextStyle(fontSize: 15, color: Colors.green[800])),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[100]
                ),
              ),



          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _multiPlantFromCamera,
            icon: Icon(Icons.layers, color: Colors.green[800], size: 20),
            label: Text("Multi Plant", style: TextStyle(fontSize: 15, color: Colors.green[800])),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[100]
              ),
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