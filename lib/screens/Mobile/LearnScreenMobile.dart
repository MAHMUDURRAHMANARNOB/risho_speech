import 'package:flutter/material.dart';

class LearnScreenMobile extends StatefulWidget {
  const LearnScreenMobile({super.key});

  @override
  State<LearnScreenMobile> createState() => _LearnScreenMobileState();
}

class _LearnScreenMobileState extends State<LearnScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                /*Skills*/
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromRGBO(179, 226, 124, 1),
                            Color.fromRGBO(49, 118, 70, 1)
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 50.0,
                            left: 10.0,
                            child: Text(
                              'Skills',
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          // Golf Flag image
                          Positioned(
                            bottom: 55.0,
                            right: -50.0,
                            child: Transform(
                              transform: Matrix4.rotationZ(
                                  0.785), // Rotates 45 degrees (pi/4 radians)
                              child: Container(
                                height: 75.0,
                                width: 70.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.5), // Shadow color with transparency
                                      offset: Offset(4.0,
                                          6.0), // Shadow offset in x and y direction

                                      blurRadius: 5.0, // Shadow blur radius
                                    ),
                                  ],
                                ),
                                child: null,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 55.0,
                            right: 5.0,
                            child: Image.asset('assets/images/golf_flag.png',
                                height: 40.0, width: 40.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                /*Topics*/
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      width: 200,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.0),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromRGBO(223, 135, 107, 1),
                            Color.fromRGBO(143, 57, 30, 1)
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 50.0,
                            left: 10.0,
                            child: Text(
                              'Topics',
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Diamond image
                          Positioned(
                            bottom: 55.0,
                            right: -50.0,
                            child: Transform(
                              transform: Matrix4.rotationZ(
                                  0.785), // Rotates 45 degrees (pi/4 radians)
                              child: Container(
                                height: 75.0,
                                width: 70.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueGrey.withOpacity(
                                          0.5), // Shadow color with transparency
                                      offset: Offset(4.0,
                                          6.0), // Shadow offset in x and y direction

                                      blurRadius: 5.0, // Shadow blur radius
                                    ),
                                  ],
                                ),
                                child: null,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 55.0,
                            right: 5.0,
                            child: Image.asset('assets/images/diamond.png',
                                height: 35.0, width: 40.0),
                          ),
                        ],
                      ),
                    ),
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
