import 'package:flutter/material.dart';

class IELTSHomeScreenMobile extends StatefulWidget {
  const IELTSHomeScreenMobile({super.key});

  @override
  State<IELTSHomeScreenMobile> createState() => _IELTSHomeScreenMobileState();
}

class _IELTSHomeScreenMobileState extends State<IELTSHomeScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      borderRadius: BorderRadius.circular(18.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          // Shadow color with transparency
                                          offset: Offset(4.0, 6.0),
                                          // Shadow offset in x and y direction

                                          blurRadius: 5.0, // Shadow blur radius
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      borderRadius: BorderRadius.circular(18.0),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.blueGrey.withOpacity(0.5),
                                          // Shadow color with transparency
                                          offset: Offset(4.0, 6.0),
                                          // Shadow offset in x and y direction

                                          blurRadius: 5.0, // Shadow blur radius
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
          ],
        ),
      ),
    );
  }

/*Widget vocabularyContainers({
    required String title,
    required List<Colors> gradientColors,
  }) {
    return Container(
      width: 150,
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        */ /*color: Colors.redAccent,*/ /*
        */ /*gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            */ /* */ /*Color.fromRGBO(254, 83, 83, 1),
            Color.fromRGBO(168, 2, 0, 1)*/ /* */ /*
            gradientColors
          ],
        ),*/ /*
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
            title,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins",
                fontSize: 20),
          ),
          */ /*Text(
            "Vocabulary",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),*/ /*
        ],
      ),
    );
  }*/
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
