import 'package:flutter/material.dart';
import 'package:risho_speech/screens/IeltsCoursesScreen.dart';
import 'package:risho_speech/ui/colors.dart';

import '../../models/ieltsCourseListDataModel.dart';

class IELTSHomeScreenMobile extends StatefulWidget {
  const IELTSHomeScreenMobile({super.key});

  @override
  State<IELTSHomeScreenMobile> createState() => _IELTSHomeScreenMobileState();
}

class _IELTSHomeScreenMobileState extends State<IELTSHomeScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Start your IELTS Preparation journey with Risho",
                style: TextStyle(fontSize: 26),
              ),
              const SizedBox(height: 10),
              /*IELTS BUTTONS*/
              Container(
                child: Row(
                  children: [
                    /*Skills*/
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            // width: 200,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color.fromRGBO(222, 253, 136, 1),
                                  Color.fromRGBO(8, 119, 75, 1)
                                ],
                              ),
                            ),
                            child: Stack(
                              children: [
                                const Positioned(
                                  top: 50.0,
                                  left: 10.0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Practice',
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Listening',
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Golf Flag image
                                Positioned(
                                  bottom: 95.0,
                                  right: -50.0,
                                  child: Transform(
                                    transform: Matrix4.rotationZ(0.785),
                                    // Rotates 45 degrees (pi/4 radians)
                                    child: Container(
                                      height: 75.0,
                                      width: 70.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            // Shadow color with transparency
                                            offset: Offset(4.0, 6.0),
                                            // Shadow offset in x and y direction

                                            blurRadius:
                                                5.0, // Shadow blur radius
                                          ),
                                        ],
                                      ),
                                      child: null,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 90.0,
                                  right: 8.0,
                                  child: Image.asset(
                                      'assets/images/golf_flag.png',
                                      height: 40.0,
                                      width: 40.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    /*Topics*/
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            // width: 200,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.0),
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color.fromRGBO(253, 140, 0, 1),
                                  Color.fromRGBO(248, 54, 1, 1)
                                ],
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 50.0,
                                  left: 10.0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Practice',
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Speaking',
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Diamond image
                                Positioned(
                                  bottom: 95.0,
                                  right: -50.0,
                                  child: Transform(
                                    transform: Matrix4.rotationZ(0.785),
                                    // Rotates 45 degrees (pi/4 radians)
                                    child: Container(
                                      height: 75.0,
                                      width: 70.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueGrey
                                                .withOpacity(0.5),
                                            // Shadow color with transparency
                                            offset: Offset(4.0, 6.0),
                                            // Shadow offset in x and y direction

                                            blurRadius:
                                                5.0, // Shadow blur radius
                                          ),
                                        ],
                                      ),
                                      child: null,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 90.0,
                                  right: 8.0,
                                  child: Image.asset(
                                      'assets/images/ielts_badge.png',
                                      height: 35.0,
                                      width: 40.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),

              /*VOCABULARY*/
              const Text(
                "Vocabulary",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              SizedBox(height: 10),
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      /*IELTS Vocabulary*/
                      vocabularyContainers(
                        title: "IELTS&Vocabulary",
                        gradientColors: [
                          Color.fromRGBO(254, 83, 83, 1),
                          Color.fromRGBO(168, 2, 0, 1),
                        ],
                      ),
                      SizedBox(width: 10.0),
                      /*Phrase And Idioms*/
                      vocabularyContainers(
                        title: "Phrase&Idioms",
                        gradientColors: [
                          Color.fromRGBO(160, 214, 120, 1),
                          Color.fromRGBO(50, 144, 88, 1),
                        ],
                      ),
                      SizedBox(width: 10.0),
                      /*Custom Practice*/
                      vocabularyContainers(
                        title: "Custom&Practice",
                        gradientColors: [
                          Color.fromRGBO(26, 136, 204, 1),
                          Color.fromRGBO(43, 50, 178, 1)
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /*COURSES*/
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Courses",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IeltsCourseScreen()),
                      );
                    },
                    child: const Text(
                      "View all",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 5.0),
              CardList(),
            ],
          ),
        ),
      ),
    );
  }
}

final List<IeltsCourseListDataModel> courses = [
  IeltsCourseListDataModel(
    imageUrl: 'assets/images/ielts/speaking.png',
    // Replace with your image URL
    title: 'IELTS - Speaking',
    price: '1000',
  ),
  IeltsCourseListDataModel(
    imageUrl: 'assets/images/ielts/ielts_Listening.png',
    // Replace with your image URL
    title: 'IELTS - Listening',
    price: '1200',
  ),
  IeltsCourseListDataModel(
    imageUrl: 'assets/images/ielts/reading.png', // Replace with your image URL
    title: 'IELTS - Reading',
    price: '900',
  ),
  IeltsCourseListDataModel(
    imageUrl: 'assets/images/ielts/writing.png', // Replace with your image URL
    title: 'IELTS - Writing',
    price: '1100',
  ),
];

class CardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length, // Number of cards
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomCard(
              cardItem: courses[index],
            ),
          );
        },
      ),
    );
    /*FutureBuilder<List<IeltsCourseListDataModel>>(
      future: fetchCardItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No items found'));
        } else {
          return Container(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomCard(cardItem: snapshot.data![index]),
                );
              },
            ),
          );
        }
      },
    );*/
  }
}

class CustomCard extends StatelessWidget {
  final IeltsCourseListDataModel cardItem;

  CustomCard({required this.cardItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Adjust width as needed
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.asset(
                /*'assets/images/ielts_Listening.png'*/
                cardItem.imageUrl, // Image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              cardItem.title /*'IELTS - Speaking'*/,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "৳ ${cardItem.price}" /*'৳ 1000'*/,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Start Now',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    backgroundColor: AppColors.primaryColor2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class vocabularyContainers extends StatelessWidget {
  final String title;
  final List<Color> gradientColors;

  vocabularyContainers({
    required this.title,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 100,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.split('&').first.trim(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            title.split('&').last.trim(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
