import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:projectf/utlis/utils.dart';

import 'core/Fadeanimation.dart';
import 'drawer.dart';

class RatingBarScreen extends StatefulWidget {
  const RatingBarScreen({Key? key}) : super(key: key);

  @override
  State<RatingBarScreen> createState() => _RatingBarScreenState();
}

class _RatingBarScreenState extends State<RatingBarScreen> {
  double emojiRating = 0;
  double rate = 0;
  int count = 0;
  double su = 0;
  int count1 = 0;
  double su1= 0;

  CollectionReference ordersCollection =
  FirebaseFirestore.instance.collection('Rating');

  void saveValuesToFirestore(double su, int count) {
    ordersCollection.doc("dmWybxs8FB8yuFHUdsRc").set({
      'rate': su,
      'count': count,
    }).then((value) {
      print('Values saved successfully!');
    }).catchError((error) {
      print('Error occurred while saving values: $error');
    });
  }

  void st() async {
    try {
      final DocumentSnapshot snapshot =
      await ordersCollection.doc("dmWybxs8FB8yuFHUdsRc").get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          count = data['count'];
          su = data['rate'];
        });
      } else {
        print('Document does not exist.');
      }
    } catch (error) {
      print('Error occurred while retrieving data: $error');
    }
    print(su);
    print(count);
  }
  @override
  void initState() {
    st();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Rating"),
        backgroundColor: Color.fromARGB(255, 21, 30, 100).withOpacity(0.7),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.9, 0.5, 0.3, 0.9],
            colors: [
              hexStringToColor("#3E4C59"),
              hexStringToColor("#FFCF9F"),
              hexStringToColor("#FFCF9F"),
              hexStringToColor("#3E4C59"),
            ],
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              hexStringToColor("#FFCF9F").withOpacity(0.1),
              BlendMode.dstATop,
            ),
            image: const AssetImage('assets/output-onlinegiftools.gif'),
          ),
        ),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 150, left: 10, right: 10),
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue.shade100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "App Evaluation: ${su.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Divider(
                      height: 10,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FadeAnimation(
                      delay: 0.4,
                      child: Text(
                        'Emoji Rating Bar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                      delay: 1.1,
                      child: Center(
                        child: RatingBar.builder(
                          initialRating: 0,
                          minRating: 1,
                          allowHalfRating: false,
                          unratedColor: Colors.blue,
                          itemCount: 5,
                          itemSize: 50.0,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          updateOnDrag: true,
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return Icon(
                                  Icons.sentiment_very_dissatisfied,
                                  color: emojiRating == 1 ? Colors.red : Colors.grey,
                                );
                              case 1:
                                return Icon(
                                  Icons.sentiment_dissatisfied,
                                  color: emojiRating == 2
                                      ? Colors.redAccent
                                      : Colors.grey,
                                );
                              case 2:
                                return Icon(
                                  Icons.sentiment_neutral,
                                  color: emojiRating == 3 ? Colors.amber : Colors.grey,
                                );
                              case 3:
                                return Icon(
                                  Icons.sentiment_satisfied,
                                  color: emojiRating == 4
                                      ? Colors.lightGreen
                                      : Colors.grey,
                                );
                              case 4:
                                return Icon(
                                  Icons.sentiment_very_satisfied,
                                  color: emojiRating == 5 ? Colors.green : Colors.grey,
                                );
                              default:
                                return Container();
                            }
                          },
                          onRatingUpdate: (ratingvalue) {
                            setState(() {
                              emojiRating = ratingvalue;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                      delay: 1.5,
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue.shade300,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          emojiRating == 1
                              ? "${rate = 1.0} /4.0"
                              : emojiRating == 2
                              ? "${rate = 2.0} /4.0"
                              : emojiRating == 3
                              ? "${rate = 2.5} /4.0"
                              : emojiRating == 4
                              ? "${rate = 3.5} /4.0"
                              : emojiRating == 5
                              ? "${rate = 4.0} / 4.0"
                              : "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 24.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                      delay: 2.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade300,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            print("suuuuuuuuuuuuuuuu$su");
                            count += 1;
                            su = (su + rate) / count;
                          });
                          saveValuesToFirestore(su, count);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Rating successfully!')));
                        },
                        child: Text("Rating"),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: MyDrawer(width: 300,),
    );

  }
}
