import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectf/utlis/utils.dart';

class ShowAllUsersPage extends StatefulWidget {
  const ShowAllUsersPage({super.key});

  @override
  State<ShowAllUsersPage> createState() => _ShowAllUsersPageState();
}

class _ShowAllUsersPageState extends State<ShowAllUsersPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController _searchController;
  late Stream<QuerySnapshot> _usersStream;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _usersStream = _firestore.collection('users').snapshots();
  }

  Future<void> _deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User deleted successfully!')),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _usersStream = _firestore.collection('users').snapshots();
      });
    } else {
      setState(() {
        _usersStream = _firestore
            .collection('users')
            .where('firstname', isEqualTo: query)
            .snapshots();
      });
    }
  }

  void _showConfirmDeleteDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
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
                _deleteUser(userId);
                Navigator.of(context).pop();
                _performSearch(_searchController.text.trim()); // Refresh the users list
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Show All Users'),
        backgroundColor: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Container();
              } else {
                final users = snapshot.data!.docs;
                return PopupMenuButton<String>(
                  icon: Icon(Icons.delete),
                  onSelected: (String userId) {
                    _showConfirmDeleteDialog(context, userId);
                  },
                  itemBuilder: (BuildContext context) {
                    return users.map((user) {
                      return PopupMenuItem<String>(
                        value: user.id,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${user['firstname']} ${user['lastname']}"),
                            Icon(Icons.delete, color: Colors.red),
                          ],
                        ),
                      );
                    }).toList();
                  },
                );
              }
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black26,
                  labelText: 'Search by name',
                  suffixIcon: Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomRight:Radius.circular(10),topRight: Radius.circular(10),),
                      color: Colors.white,
                    ),

                    child: IconButton(
                      icon: Icon(Icons.search,color:  Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),),
                      onPressed: () {
                        _performSearch(_searchController.text.trim());
                      },
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white), // Outline border color when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.7)), // Outline border color when not focused
                  ),
                  labelStyle: TextStyle(color: Colors.white), // Color of the label text
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)), // Color of the hint text
                ),
                style: TextStyle(color: Colors.white), // Color of the input text
                cursorColor: Colors.white, // Color of the cursor
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No users found'));
                  } else {
                    final users = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Card(
                              shadowColor: Colors.black,
                              elevation: 25,
                              color: const Color.fromARGB(255, 171, 178, 250).withOpacity(0.4),
                              child: Column(
                                children: [
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/idcard.jpg'), // Replace with your image path
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(10),
                                      title: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                        child: Text(
                                          user['firstname'] + ' ' + user['lastname'],
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade900,
                                          ),
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(Icons.email, color: Colors.blue.shade900),
                                              SizedBox(width: 5),
                                              Text('Email: ${user['email']}',
                                                  style: TextStyle(fontSize: 16, color: Colors.black87)),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(Icons.person, color: Colors.blue.shade900),
                                              SizedBox(width: 5),
                                              Text('Firstname: ${user['firstname']}',
                                                  style: TextStyle(fontSize: 16, color: Colors.black87)),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(Icons.person, color: Colors.blue.shade900),
                                              SizedBox(width: 5),
                                              Text('Lastname: ${user['lastname']}',
                                                  style: TextStyle(fontSize: 16, color: Colors.black87)),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(Icons.directions_car, color: Colors.blue.shade900),
                                              SizedBox(width: 5),
                                              Text('Numbercar: ${user['numbercar']}',
                                                  style: TextStyle(fontSize: 16, color: Colors.black87)),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(Icons.phone, color: Colors.blue.shade900),
                                              SizedBox(width: 5),
                                              Text('Phone: ${user['phone']}',
                                                  style: TextStyle(fontSize: 16, color: Colors.black87)),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(Icons.car_crash_sharp, color: Colors.blue.shade900),
                                              SizedBox(width: 5),
                                              Text('Type: ${user['typecar']}',
                                                  style: TextStyle(fontSize: 16, color: Colors.black87)),
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
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
