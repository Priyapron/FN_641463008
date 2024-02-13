import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateGrowingInfoScreen extends StatefulWidget {
  final Map<String, dynamic> growingData;

  UpdateGrowingInfoScreen({required this.growingData});

  @override
  _UpdateGrowingInfoScreenState createState() =>
      _UpdateGrowingInfoScreenState();
}

class _UpdateGrowingInfoScreenState extends State<UpdateGrowingInfoScreen> {
  TextEditingController greenHouseCodeController = TextEditingController();
  TextEditingController greenHouseNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    greenHouseCodeController.text =
        widget.growingData['green_house_code'] ?? '';
    greenHouseNameController.text =
        widget.growingData['green_house_name'] ?? '';
  }

  Future<void> _saveUpdatedGrowingInfo() async {
    final apiUrl = 'http://localhost/fn-db/growingInfo.php';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'case': '2',
          'green_house_code': greenHouseCodeController.text,
          'green_house_name': greenHouseNameController.text,
        },
      );

      if (response.statusCode == 200) {
        print('Growing information updated successfully');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Growing information updated successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context, true);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Error updating growing information: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating growing information'),
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
        title: Text('Edit Growing Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: greenHouseCodeController,
              decoration: InputDecoration(labelText: 'Green House Code'),
              enabled: false,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: greenHouseNameController,
              decoration: InputDecoration(labelText: 'Green House Name'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveUpdatedGrowingInfo,
              child: Text('Save Updated Growing Information'),
            ),
          ],
        ),
      ),
    );
  }
}
