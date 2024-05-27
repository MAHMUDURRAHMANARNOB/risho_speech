import 'package:flutter/material.dart';

class ContainerCard extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final Color color;
  final VoidCallback onPressed;

  const ContainerCard({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
      child: GestureDetector(
        onTap: () {
          /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PracticeGuidedScreen(
                      screenName: 'PDL',
                    )),
          );*/
          onPressed();
        },
        child: Card(
          color: color,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0), // Adjust as needed
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent, // Start with a transparent color
                  Colors.white.withOpacity(0.3), // Adjust opacity as needed
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    image,
                    fit: BoxFit.contain,
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PracticeGuidedScreen(
                                      screenName: 'PDL',
                                    )),
                          );*/
                          onPressed();
                        },
                        /*style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainerColor,
                          padding: EdgeInsets.all(10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),*/
                        icon: Icon(
                          Icons.arrow_circle_right_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
