import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectf/utlis/utils.dart';

class ShowAllCitiesPage extends StatefulWidget {
  const ShowAllCitiesPage({super.key});

  @override
  State<ShowAllCitiesPage> createState() => _ShowAllCitiesPageState();
}

class _ShowAllCitiesPageState extends State<ShowAllCitiesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _selectedCityId;
  List<Map<String, dynamic>> _cities = [];

  void _fetchCities() async {
    QuerySnapshot snapshot = await _firestore.collection('cities').get();
    setState(() {
      _cities = snapshot.docs.map((doc) {
        return {
          'id': doc['Id'],
          'city': doc['city'],
        };
      }).toList();
    });
  }

  void _deleteCityData(String cityId) async {
    try {
      int id = int.parse(cityId);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cities')
          .where('Id', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('cities')
            .doc(querySnapshot.docs.first.id)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('City data deleted successfully!')),
        );
        _fetchCities(); // Refresh the cities list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('City not found!')),
        );
      }
    } catch (e) {
      print("Error deleting city: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete city!')),
      );
    }
  }

  void _showConfirmDeleteDialog(BuildContext context, String cityId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete City'),
          content: Text('Are you sure you want to delete this city?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCityData(cityId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _fetchCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Show All Cities'),
        backgroundColor: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.delete),
            onSelected: (String cityId) {
              _showConfirmDeleteDialog(context, cityId);
            },
            itemBuilder: (BuildContext context) {
              return _cities.map((city) {
                return PopupMenuItem<String>(
                  value: city['id'].toString(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${city['id']} - ${city['city']}"),
                      Icon(Icons.delete, color: Colors.red),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1.3,
            stops: const [0.3, 1.5, 0.9, 1.8],
            colors: [
              hexStringToColor("#caf0f8"),
              hexStringToColor("#0077b6"),
              hexStringToColor("#caf0f8"),
              hexStringToColor("#caf0f8"),
            ],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('cities').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No cities found'));
            } else {
              final cities = snapshot.data!.docs;
              return ListView.builder(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Card(
                          shadowColor: Colors.black,
                          elevation: 55,
                          color: Color.fromARGB(168, 0, 19, 255).withOpacity(0.0),
                          child: Column(
                            children: [
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/cinterlocation.jpeg'), // استبدل هذا بمسار صورتك
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ListTile(
                                  title: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    child: Text(
                                      "Cinter: " + city['city'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(Icons.perm_identity, color: Colors.blue.shade900),
                                          SizedBox(width: 5),
                                          Text('ID: ${city['Id']}',
                                              style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, color: Colors.blue.shade900),
                                          SizedBox(width: 5),
                                          Text('Latitude: ${city['latitude']}',
                                              style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on, color: Colors.blue.shade900),
                                          SizedBox(width: 5),
                                          Text('Longitude: ${city['longitude']}',
                                              style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(Icons.email, color: Colors.blue.shade900),
                                          SizedBox(width: 5),
                                          Text('Email: ${city['email']}',
                                              style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
