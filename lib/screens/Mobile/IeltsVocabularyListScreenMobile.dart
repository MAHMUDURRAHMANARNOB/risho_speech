import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shimmer/shimmer.dart';

import '../../providers/IeltsVocabularyListProvider.dart';
import '../../ui/colors.dart';

class IeltsVocabularyListScreenMobile extends StatefulWidget {
  final int vocabularyCategoryId;
  final String isIdioms;

  const IeltsVocabularyListScreenMobile(
      {super.key, required this.vocabularyCategoryId, required this.isIdioms});

  @override
  State<IeltsVocabularyListScreenMobile> createState() =>
      _IeltsVocabularyListScreenMobileState();
}

class _IeltsVocabularyListScreenMobileState
    extends State<IeltsVocabularyListScreenMobile> {
  IeltsVocabularyListProvider ieltsVocabularyListProvider =
      IeltsVocabularyListProvider();

  double _playbackSpeed = 1.0; // Default playback speed
  final List<double> playbackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  late final AudioPlayer _player;

  @override
  void initState() {
    // TODO: implement initState
    _player = AudioPlayer();
    super.initState();
  }

  void _handlePlayPause() {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Practice Vocabulary",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _vocabCategoryList(),
    );
  }

  /*Vocabulary Widget*/

  Widget _vocabCategoryList() {
    return FutureBuilder<void>(
      future: ieltsVocabularyListProvider.fetchIeltsVocabularyList(
          widget.vocabularyCategoryId, widget.isIdioms),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SpinKitThreeInOut(
              color: AppColors.primaryColor,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          if (ieltsVocabularyListProvider.vocabularyCategories == null ||
              ieltsVocabularyListProvider
                  .vocabularyCategories!.vocaList.isEmpty) {
            return Center(
              child: Text('No vocabulary available.'),
            );
          } else {
            return PageView.builder(
              scrollDirection: Axis.horizontal,
              // shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: ieltsVocabularyListProvider
                  .vocabularyCategories!.vocaList.length,
              itemBuilder: (context, index) {
                final word = ieltsVocabularyListProvider
                    .vocabularyCategories!.vocaList[index];
                _player.setUrl(word.wordSoundFile);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*Play icon*/
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(
                                    width: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      /*Playback speed*/
                                      DropdownButton<double>(
                                        value: _playbackSpeed,
                                        dropdownColor:
                                            AppColors.primaryCardColor,
                                        onChanged: (double? newSpeed) {
                                          setState(() {
                                            _playbackSpeed = newSpeed!;
                                            _player.setSpeed(_playbackSpeed);
                                          });
                                        },
                                        items: playbackSpeeds
                                            .map<DropdownMenuItem<double>>(
                                                (double value) {
                                          return DropdownMenuItem<double>(
                                            value: value,
                                            child: Text(
                                              '${value} x',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                      IconButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors
                                              .primaryColor2
                                              .withOpacity(0.5),
                                        ),
                                        onPressed: _handlePlayPause,
                                        icon: Icon(
                                          _player.playing
                                              ? IconsaxPlusBold.pause
                                              : IconsaxPlusBold.play,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: double.infinity,
                                child: Text(
                                  word.vocabularyWord,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Meaning: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    word.wordMeaning,
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Bangla Meaning: ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    word.banglaMeaning,
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColorDark,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                              width: 2,
                              color: AppColors.primaryColor.withOpacity(0.2)),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Synonyms",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              word.wordsynonyms,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColorDark,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                              width: 2,
                              color: AppColors.primaryColor.withOpacity(0.2)),
                        ),
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Antonyms",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              word.wordantonyms,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}
