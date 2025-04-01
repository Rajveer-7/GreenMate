import 'package:flutter/material.dart';
import 'plant_detail_page.dart';

class PlantsPage extends StatelessWidget {
  const PlantsPage({super.key});

  // Updated dummy plant data with sunlight and water fields
  final List<Map<String, String>> plantData = const [
    {
      'name': 'Aloe Vera',
      'image': 'lib/images/plant.jpg',
      'description': 'Aloe Vera is great for skin and air purification.',
      'sunlight': 'High',
      'water': 'Low'
    },
    {
      'name': 'Snake Plant',
      'image': 'lib/images/plant2.jpg',
      'description': 'Snake Plants thrive in low light and are low-maintenance.',
      'sunlight': 'Low',
      'water': 'Low'
    },
    {
      'name': 'Peace Lily',
      'image': 'lib/images/plant3.jpg',
      'description': 'Peace Lilies are beautiful and help purify the air.',
      'sunlight': 'Medium',
      'water': 'Medium'
    },
    {
      'name': 'Spider Plant',
      'image': 'lib/images/plant4.jpg',
      'description': 'Spider Plants are easy to grow, great for beginners, and help purify indoor air.',
      'sunlight': 'Medium',
      'water': 'Medium'
    }

    // Add more plants as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: plantData.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final plant = plantData[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlantDetailPage(
                      name: plant['name']!,
                      imagePath: plant['image']!,
                      description: plant['description']!,
                      sunlight: plant['sunlight']!,
                      water: plant['water']!,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.asset(
                          plant['image']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        plant['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
