import 'package:flutter/material.dart';

import '../models/plant.dart';

class PlantTile extends StatelessWidget {
  Plant plant;
  PlantTile({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 25),
      width: 280,
      decoration: BoxDecoration(color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(plant.imagePath),
          ),

          //Plant Name
          Text(plant.name, style: TextStyle(color: Colors.grey[900],fontSize: 20),),


          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              //Water Display
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12)
              ),

                padding: EdgeInsets.all(25),
                child: Row(
                  children: [
                    Icon(Icons.water_drop_sharp,size: 25,color: Colors.blue[600],),
                    SizedBox(width: 10,),
                    Text(plant.water)
                  ],
                )

            ),

              //Sunlight Display
              Container(
                  decoration: BoxDecoration(
                      color: Colors.yellow[50],
                      borderRadius: BorderRadius.circular(12)
                  ),
                  padding: EdgeInsets.all(25),
                  child: Row(
                    children: [
                      Icon(Icons.sunny,size: 25,color: Colors.amber[800]),
                      SizedBox(width: 10,),
                      Text(plant.Sunlight)
                    ],
                  ),
              ),

          ],)
        ],

      ),
    );
  }
}
