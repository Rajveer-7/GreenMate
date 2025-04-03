import 'package:flutter/material.dart';
import 'package:green_mate/services/weather_service.dart';
import '../components/plant_tile.dart';
import '../models/plant.dart';
import '../models/weather_model.dart';
import 'package:green_mate/pages/scan_page_detailed.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _weatherService = WeatherService('db9f5103b784da9047fb57261398fbc6');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    print("Detected city: $cityName");

    if (cityName.isEmpty) {
      print("City name is empty. Could not fetch location.");
      return;
    }

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
        print("City: ${weather.cityName}");
        print("Temp: ${weather.temperature}");
        print("Condition: ${weather.mainCondition}");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // Weather info and plus icon button in a Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              // Weather container
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _weather?.cityName ?? "loading city",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      '${_weather?.temperature.round().toString() ?? "loading"} °C',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),

              // Plus icon button
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScanPageDetailed()),
                  );
                },
                icon: const Icon(Icons.add),
                color: Colors.black87,
                iconSize: 28,
                tooltip: 'Scan',
              ),
            ],
          ),
        ),

        // Plant list
        Expanded(
          child: ListView.builder(
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              Plant plant = Plant(
                name: "Money Plant",
                Sunlight: "Medium",
                water: "Low",
                imagePath: "lib/images/plant.jpg",
              );
              return PlantTile(plant: plant);
            },
          ),
        ),
      ],
    );
  }
}
