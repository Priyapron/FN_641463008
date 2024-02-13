import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InsertGrowingInfoScreen extends StatefulWidget {
  final VoidCallback? onInsertSuccess;

  const InsertGrowingInfoScreen({Key? key, this.onInsertSuccess})
      : super(key: key);

  @override
  _InsertGrowingInfoScreenState createState() =>
      _InsertGrowingInfoScreenState();
}

class _InsertGrowingInfoScreenState extends State<InsertGrowingInfoScreen> {
  TextEditingController greenHouseCodeController = TextEditingController();
  TextEditingController greenHouseNameController = TextEditingController();

  void _showSaveSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Successfully'),
          content: Text('Growing information saved successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close AlertDialog
                Navigator.pop(context); // Close InsertGrowingInfoScreen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveGrowingInfo() async {
    final apiUrl = 'http://localhost/fn-db/growingInfo.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'case': '1', // Use case '1' for saving growing information
          'green_house_code': greenHouseCodeController.text,
          'green_house_name': greenHouseNameController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Growing information saved successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Growing information saved successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Show the success dialog
        _showSaveSuccessDialog();

        // Call the callback function to notify the parent (GrowingShowData)
        widget.onInsertSuccess?.call();
      } else {
        print('Error saving growing information: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving growing information'),
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
        title: Text('Growing Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: greenHouseCodeController,
              decoration: InputDecoration(labelText: 'Green House Code'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: greenHouseNameController,
              decoration: InputDecoration(labelText: 'Green House Name'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveGrowingInfo,
              child: Text('Save Growing Information'),
            ),
          ],
        ),
      ),
    );
  }
}
