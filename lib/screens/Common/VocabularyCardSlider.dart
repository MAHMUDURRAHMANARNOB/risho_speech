import 'package:flutter/material.dart';

class VocabularyCardSlider extends StatefulWidget {
  final List<Map<String, dynamic>> vocaList;

  const VocabularyCardSlider({Key? key, required this.vocaList})
      : super(key: key);

  @override
  _VocabularyCardSliderState createState() => _VocabularyCardSliderState();
}

class _VocabularyCardSliderState extends State<VocabularyCardSlider> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final word = widget.vocaList[currentIndex];
    return Column(
      children: [
        Card(
          color: Colors.blue, // Use your desired color here
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 1),
                    IconButton(
                      onPressed: () {
                        // Play audio or any action you want
                        print(word['wordaudios']);
                      },
                      icon: const Icon(
                        Icons.volume_up_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Container(
                  width: double.infinity,
                  child: Text(
                    word['vocWord'],
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Meaning: "),
                    Text(
                      word['englishMeaning'],
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Bangla Meaning: "),
                    Text(
                      word['banglaMeaning'],
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: currentIndex > 0
                    ? () {
                        setState(() {
                          currentIndex--;
                        });
                      }
                    : null,
                child: Text("Previous"),
              ),
              ElevatedButton(
                onPressed: currentIndex < widget.vocaList.length - 1
                    ? () {
                        setState(() {
                          currentIndex++;
                        });
                      }
                    : null,
                child: Text("Next"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
