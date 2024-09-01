import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:risho_speech/models/speakingExamDataModel.dart';
import 'package:risho_speech/ui/colors.dart';

class SpeakingTestReportScreenMobile extends StatefulWidget {
  final Report report;

  const SpeakingTestReportScreenMobile({super.key, required this.report});

  @override
  State<SpeakingTestReportScreenMobile> createState() =>
      _SpeakingTestReportScreenMobileState();
}

class _SpeakingTestReportScreenMobileState
    extends State<SpeakingTestReportScreenMobile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Widget _buildTabBar() {
    return TabBar(
      dividerColor: Colors.transparent,
      controller: _tabController,
      indicatorColor: AppColors.primaryColor,
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: Colors.white,
      tabs: const [
        Tab(text: 'Overall Score'),
        Tab(text: 'Feedback'),
      ],
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          overallScore(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MarkdownWidget(data: widget.report.feedbackText ?? ''),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // Gives the height
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Test Report',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTabBar(),
              _buildTabBarView(),
              // feedback
            ],
          );
        }),
      ),
    );
  }

  Widget overallScore() {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              // color: AppColors.primaryColor2.withOpacity(0.1),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.transparent,
                  // Start with a transparent color
                  AppColors.primaryColor.withOpacity(0.3),
                  // Adjust opacity as needed
                ],
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Band Score",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 34.0),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.3),
                    border: Border.all(color: AppColors.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(64.0),
                  ),
                  child: Text(
                    widget.report.bandScore.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                width: 1.0,
                color: AppColors.primaryColor.withOpacity(0.5),
              ),
            ),
            child: Column(
              children: [
                RowContentWidget(
                  title: 'Pronunciation Score',
                  score: '${widget.report.pronScore.toInt()} / 100',
                ),
                Divider(),
                RowContentWidget(
                  title: 'Accuracy Score:',
                  score: '${widget.report.accuracyScore.toInt()} / 100',
                ),
                Divider(),
                RowContentWidget(
                  title: 'Fluency Score:',
                  score: '${widget.report.fluencyScore.toInt()} / 100',
                ),
                Divider(),
                RowContentWidget(
                  title: 'Completeness Score:',
                  score: '${widget.report.completenessScore.toInt()} / 100',
                ),
                Divider(),
                RowContentWidget(
                  title: 'Prosody Score:',
                  score: '${widget.report.prosodyScore.toInt()} / 100',
                ),
                Divider(),
                RowContentWidget(
                  title: 'Average Grammar Score:',
                  score: '${widget.report.avgGrammarScore.toInt()} / 100',
                ),
                Divider(),
                RowContentWidget(
                  title: 'Lexical Resources\n(Vocabulary) Score:',
                  score: '${widget.report.vocaScore.toInt()} / 100',
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class RowContentWidget extends StatelessWidget {
  const RowContentWidget({
    super.key,
    required this.title,
    required this.score,
  });

  final String title;
  final String score;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 18.0),
          ),
        ),
        SizedBox(width: 2),
        Text(
          score,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 18.0),
        ),
      ],
    );
  }
}
