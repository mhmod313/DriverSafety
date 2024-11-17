import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projectf/sign_in.dart';
import 'package:projectf/utlis/utils.dart';

import 'ShowAllCitiesPage.dart';
import 'ShowAllUsersPage.dart';
import 'addcity.dart';

class homeadmin extends StatefulWidget {
  const homeadmin({super.key});

  @override
  State<homeadmin> createState() => _homeadminState();

}




class _homeadminState extends State<homeadmin> {
  late List<Color> colors;
  late Timer _timer;
  late Timer _timer1;
  int _currentPage = 0;
  int currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Map<String, String>> _imagesWithCaptions = [
    {
      'image': 'assets/truck safty.webp', // Replace with your image paths
      'caption': 'ًWelcome To Driver Safty',
    },
    {
      'image': 'assets/sleep.webp',
      'caption': 'Monitoring the drivers eye movement using artificial intelligence techniques\n and treating sleep and snoozing states',
    },
    {
      'image': 'assets/location.jpg',
      'caption': 'Enhance the application by obtaining the nearest security center to the driver \nand sending an email message that includes the driver’s location and name',
    },
  ];


  @override
  void initState() {
    colors = [
      hexStringToColor("#caf0f8"),
      hexStringToColor("#0077b6"),
      hexStringToColor("#00b4d8"),
      hexStringToColor("#caf0f8"),
    ];
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % colors.length;
      });

    });
    _timer1 = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _imagesWithCaptions.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
    // TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home Page"),
        backgroundColor: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
        actions: [
          IconButton(onPressed: (){
            Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              }, icon:Icon(Icons.logout))
        ],
      ),
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1.3,
            stops: const [0.3, 1.5, 0.9, 1.8],
            colors: [
              colors[(currentIndex) % colors.length],
              colors[(currentIndex + 1) % colors.length],
              colors[(currentIndex + 2) % colors.length],
              colors[(currentIndex + 3) % colors.length],
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin:const EdgeInsets.only(bottom: 10),
                height: 320,
                child: Card(
                  elevation: 5,
                  color: const Color.fromARGB(255, 171, 178, 250).withOpacity(0.4),
                  child: SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _imagesWithCaptions.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(height: 30,),
                            Image.asset(
                              _imagesWithCaptions[index]['image']!,
                              fit: BoxFit.cover,
                              height: 140,
                            ),
                            Container(
                              margin:const EdgeInsets.all(20.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                              ),

                              child: Text(
                                _imagesWithCaptions[index]['caption']!,

                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowAllUsersPage()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Show All Users',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowAllCitiesPage()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Show All Cities',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CityInputScreen()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Save Data',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
