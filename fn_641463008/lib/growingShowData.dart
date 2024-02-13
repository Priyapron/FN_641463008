import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fn_641463008/InsertGrowingInfo.dart';
import 'package:fn_641463008/updateGrowingInfo.dart';

class GrowingShowData extends StatefulWidget {
  @override
  _GrowingShowDataState createState() => _GrowingShowDataState();
}

class _GrowingShowDataState extends State<GrowingShowData> {
  late Future<List<Map<String, dynamic>>> _growingData;

  Future<List<Map<String, dynamic>>> _fetchGrowingData() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost/fn-db/selectGrowingInfo.php'));
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

  Future<void> _deleteGrowingData(String greenHouseCode) async {
    final response = await http.post(
      Uri.parse('http://localhost/fn-db/growingInfo.php'),
      body: {
        'case': '3',
        'green_house_code': '$greenHouseCode',
      },
    );

    if (response.statusCode == 200) {
      print('Growing data deleted successfully');
    } else {
      print('Failed to delete growing data');
    }
  }

  @override
  void initState() {
    super.initState();
    _growingData = _fetchGrowingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 56, 136, 255),
        title: Text('Growing Information'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _growingData,
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
                          'images/greenhIcon2.jpg',
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Growing Information',
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
                              DataColumn(label: Text('Green House Code')),
                              DataColumn(label: Text('Green House Name')),
                              DataColumn(label: Text('Search')),
                              DataColumn(label: Text('Edit')),
                              DataColumn(label: Text('Delete')),
                            ],
                            rows: snapshot.data!.map((data) {
                              return DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(' ')),
                                  DataCell(Text(
                                      data['green_house_code']?.toString() ??
                                          'N/A')),
                                  DataCell(Text(
                                      data['green_house_name']?.toString() ??
                                          'N/A')),
                                  DataCell(
                                  IconButton(
                                  icon: Icon(Icons.search),
                                    color: Colors.green,
                                      onPressed: () {
                                   Handle search action
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.blue,
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateGrowingInfoScreen(
                                              growingData: data,
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
                                                'Are you sure you want to delete this growing data?',
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
                                                    await _deleteGrowingData(
                                                      data['green_house_code']
                                                              ?.toString() ??
                                                          '',
                                                    );
                                                    Navigator.of(context).pop();
                                                    setState(() {
                                                      _growingData =
                                                          _fetchGrowingData();
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
              builder: (context) => InsertGrowingInfoScreen(
                onInsertSuccess: _refreshGrowingData,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _refreshGrowingData() {
    setState(() {
      _growingData = _fetchGrowingData();
    });
  }
}
