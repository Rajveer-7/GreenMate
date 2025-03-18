import 'package:flutter/material.dart';

import '../components/plant_tile.dart';
import '../models/plant.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [


        //weather
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(children: [Text("Brampton- 11C", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)],),
        ),




        //PlantList
        Expanded(child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
          Plant plant = Plant(name: "Money Plant", Sunlight: "Medium", water: "Low", imagePath: "lib/images/plant.jpg");
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

          onPressed: (){},
          label: Text("Scan",style: TextStyle(fontSize: 15,color: Colors.grey[800]),),
          icon: Icon(Icons.camera_alt,color: Colors.grey[800],size: 20,),

          ),
        )

      ],

    );

  }
}
