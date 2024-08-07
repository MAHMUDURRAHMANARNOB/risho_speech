import 'package:flutter/material.dart';
import 'package:risho_speech/utils/constants/colors.dart';

import '../../models/ieltsCourseListDataModel.dart';
import '../../ui/colors.dart';

class IeltsCourseScreenMobile extends StatefulWidget {
  const IeltsCourseScreenMobile({super.key});

  @override
  State<IeltsCourseScreenMobile> createState() =>
      _IeltsCourseScreenMobileState();
}

class _IeltsCourseScreenMobileState extends State<IeltsCourseScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Courses"),
      ),
      body: /*SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.green,
            ),
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.green,
            ),
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.green,
            ),
          ],
        ),
      ),*/
          Container(
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            return CardList(cardModel: courses[index]);
          },
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
  final IeltsCourseListDataModel cardModel;

  CardList({required this.cardModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0)),
            child: Image.asset(
              cardModel.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            // width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cardModel.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                /*Text(
                  cardModel.subtitle,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),*/
                SizedBox(height: 8.0),
                Text(
                  "৳ ${cardModel.price}",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                // shape: OvalBorder(),
                backgroundColor: AppColors.primaryColor2,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
              ),
              onPressed: () {},
              child: Text(
                'Explore now',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
