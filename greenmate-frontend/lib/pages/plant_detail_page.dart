import 'package:flutter/material.dart';

class PlantDetailPage extends StatelessWidget {
  final String name;
  final String imagePath;
  final String description;
  final String sunlight;
  final String water;

  const PlantDetailPage({
    super.key,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.sunlight,
    required this.water,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          name,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Plant Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Plant Name
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Sunlight & Water Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Sunlight container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.wb_sunny, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text('Sunlight: $sunlight'),
                    ],
                  ),
                ),

                // Water container
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.water_drop, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text('Water: $water'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Description
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  description,
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
