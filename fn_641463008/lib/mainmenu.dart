import 'package:flutter/material.dart';
import 'package:fn_641463008/plantShowData.dart';
import 'package:fn_641463008/growingShowData.dart';

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // First Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: buildStyledImageButton(
                      'images/plantIcon.png',
                      'ข้อมูลพืช',
                      PlantInfoPage(),
                      context,
                    ),
                  ),
                  Expanded(
                    child: buildStyledImageButton(
                      'images/greenHouseIcon.png',
                      'ข้อมูลแหล่งปลูก',
                      GrowingShowData(),
                      context,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStyledImageButton(String imagePath, String buttonText,
      Widget destination, BuildContext context) {
    return Container(
      width: 180,
      height: 220,
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Colors.blue, width: 2.0),
          ),
          elevation: 5.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 100,
              height: 100,
            ),
            SizedBox(height: 15),
            Text(
              buttonText,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
