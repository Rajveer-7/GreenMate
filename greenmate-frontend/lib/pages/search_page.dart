import 'package:flutter/material.dart';
import 'plant_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> allPlants = [
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
    },
  ];

  List<Map<String, String>> filteredPlants = [];

  @override
  void initState() {
    super.initState();
    filteredPlants = allPlants;
  }

  void _searchPlants(String query) {
    final results = allPlants.where((plant) {
      final name = plant['name']!.toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredPlants = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search plants...',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                  onChanged: _searchPlants,
                ),
              ),

              const SizedBox(height: 16),

              // Results
              Expanded(
                child: filteredPlants.isEmpty
                    ? const Center(child: Text("No plants found."))
                    : ListView.builder(
                  itemCount: filteredPlants.length,
                  itemBuilder: (context, index) {
                    final plant = filteredPlants[index];
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
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              plant['image']!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            plant['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            plant['description']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
