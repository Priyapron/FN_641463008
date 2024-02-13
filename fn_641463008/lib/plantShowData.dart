import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fn_641463008/insertPlantInfo.dart';
import 'package:fn_641463008/updatePlantInfo.dart';

class PlantInfoPage extends StatefulWidget {
  @override
  _PlantInfoPageState createState() => _PlantInfoPageState();
}

class _PlantInfoPageState extends State<PlantInfoPage> {
  late Future<List<Map<String, dynamic>>> _plantData;

  Future<List<Map<String, dynamic>>> _fetchPlantData() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost/fn-db/selectPlantInfo.php'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final List<dynamic> parsed = json.decode(response.body);
        return parsed.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Cannot connect to data. Please check.');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Cannot connect to data. Please check.');
    }
  }

  // Function to delete plant data
  Future<void> _deletePlantData(String plantId) async {
    final response = await http.post(
      Uri.parse('http://localhost/fn-db/plantInfo.php'),
      body: {
        'case': '3',
        'plant_id': '$plantId',
      },
    );

    if (response.statusCode == 200) {
      print('Plant data deleted successfully');
    } else {
      print('Failed to delete plant data');
    }
  }

  @override
  void initState() {
    super.initState();
    _plantData = _fetchPlantData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 56, 136, 255),
        leading: IconButton(
          icon: Icon(Icons.home),
          color: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/mainmenu');
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Plant Information',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _plantData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data found'));
            } else {
              return Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/plantIcon.png',
                          width: 40,
                          height: 40,
                          color: Colors.green,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Plant Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Center(
                          child: DataTable(
                            columns: <DataColumn>[
                              DataColumn(label: Text(' ')),
                              DataColumn(label: Text('Plant ID')),
                              DataColumn(label: Text('Plant Name')),
                              //DataColumn(label: Text('Search')),
                              DataColumn(label: Text('Edit')),
                              DataColumn(label: Text('Delete')),
                            ],
                            rows: snapshot.data!.map((data) {
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(' ')),
                                  DataCell(Text(
                                      data['plant_id']?.toString() ?? 'N/A')),
                                  DataCell(Text(
                                      data['plant_name']?.toString() ?? 'N/A')),
                                  //DataCell(
                                  //IconButton(
                                  //  icon: Icon(Icons.search),
                                  //  color: Colors.green,
                                  //  onPressed: () {
                                  //    // Handle search action
                                  //  },
                                  //  ),
                                  //  ),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.blue,
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditPlantInfoScreen(
                                              plantData: data,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  Text('Delete Confirmation'),
                                              content: Text(
                                                'Are you sure you want to delete this plant data?',
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await _deletePlantData(
                                                      data['plant_id']
                                                              ?.toString() ??
                                                          '',
                                                    );
                                                    Navigator.of(context).pop();
                                                    setState(() {
                                                      _plantData =
                                                          _fetchPlantData();
                                                    });
                                                  },
                                                  child: Text('Delete'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsertPlantScreen(
                onInsertSuccess: _refreshPlantData,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Callback function to refresh plant data after successful insertion
  void _refreshPlantData() {
    setState(() {
      _plantData = _fetchPlantData();
    });
  }
}
