import 'package:flutter/material.dart';
import 'package:green_mate/services/weather_service.dart';
import 'package:lottie/lottie.dart';
import '../components/plant_tile.dart';
import '../models/plant.dart';
import '../models/weather_model.dart';

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
    }

    catch (e) {
      print(e);
    }
  }


  //Initial State
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

    @override
    Widget build(BuildContext context) {
      return Column(
        children: [


          //weather
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start, // 👈 Align text to the left
                  children: [

                    Text(
                      _weather?.cityName ?? "loading city",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),

                    Text(
                      '${_weather?.temperature.round().toString() ?? "loading"} °C',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),






          //PlantList
          Expanded(child: ListView.builder(
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Plant plant = Plant(name: "Money Plant",
                    Sunlight: "Medium",
                    water: "Low",
                    imagePath: "lib/images/plant.jpg");
                return PlantTile(
                  plant: plant,
                );
              }
          ),
          ),


          //Scan Button
          Padding(

            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(

              onPressed: () {},
              label: Text("Scan",
                style: TextStyle(fontSize: 15, color: Colors.grey[800]),),
              icon: Icon(Icons.camera_alt, color: Colors.grey[800], size: 20,),

            ),
          )

        ],

      );
    }
  }


