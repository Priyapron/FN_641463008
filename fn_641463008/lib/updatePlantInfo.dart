import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditPlantInfoScreen extends StatefulWidget {
  final Map<String, dynamic> plantData;

  EditPlantInfoScreen({required this.plantData});

  @override
  _EditPlantInfoScreenState createState() => _EditPlantInfoScreenState();
}

class _EditPlantInfoScreenState extends State<EditPlantInfoScreen> {
  TextEditingController plantIdController = TextEditingController();
  TextEditingController plantNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with existing data if available
    plantIdController.text = widget.plantData['plant_id'] ?? '';
    plantNameController.text = widget.plantData['plant_name'] ?? '';
  }

  Future<void> _saveEditedPlantInfo() async {
    final apiUrl = 'http://localhost/fn-db/plantInfo.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'case': '2', // Updated to use case '2'
          'plant_id': plantIdController.text,
          'plant_name': plantNameController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Plant information updated successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Plant information updated successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close AlertDialog
                    Navigator.pop(context, true); // Close EditPlantInfoScreen
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Error updating plant information: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating plant information'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Plant Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: plantIdController,
              decoration: InputDecoration(labelText: 'Plant ID'),
              enabled: false, // Make it non-editable if needed
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: plantNameController,
              decoration: InputDecoration(labelText: 'Plant Name'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveEditedPlantInfo,
              child: Text('Save Edited Plant Information'),
            ),
          ],
        ),
      ),
    );
  }
}
