import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InsertPlantScreen extends StatefulWidget {
  final VoidCallback? onInsertSuccess;

  const InsertPlantScreen({Key? key, this.onInsertSuccess}) : super(key: key);

  @override
  _InsertPlantScreenState createState() => _InsertPlantScreenState();
}

class _InsertPlantScreenState extends State<InsertPlantScreen> {
  TextEditingController plantIdController = TextEditingController();
  TextEditingController plantNameController = TextEditingController();

  void _showSaveSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Successfully'),
          content: Text('Plant information saved successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close AlertDialog
                Navigator.pop(context); // Close InsertPlantScreen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _savePlantInfo() async {
    final apiUrl = 'http://localhost/fn-db/plantInfo.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'case': '1', // Use case '1' for saving plant information
          'plant_id': plantIdController.text,
          'plant_name': plantNameController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Plant information saved successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Plant information saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Show the success dialog
        _showSaveSuccessDialog();

        // Call the callback function to notify the parent (PlantInfoPage)
        widget.onInsertSuccess?.call();
      } else {
        print('Error saving plant information: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving plant information'),
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
        title: Text('Plant Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: plantIdController,
              decoration: InputDecoration(labelText: 'Plant ID'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: plantNameController,
              decoration: InputDecoration(labelText: 'Plant Name'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _savePlantInfo,
              child: Text('Save Plant Information'),
            ),
          ],
        ),
      ),
    );
  }
}
