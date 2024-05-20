import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreenMobile extends StatefulWidget {
  const AboutScreenMobile({super.key});

  @override
  State<AboutScreenMobile> createState() => _AboutScreenMobileState();
}

class _AboutScreenMobileState extends State<AboutScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About",
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                "assets/images/slogo.png",
              ),
            ),
            Text(
              'About Us',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to SHONOD, where we believe in simplifying learning to empower students for success. Our mission is clear: to make learning an engaging and enriching experience for every student. Through our innovative AI-based education platform, we strive to revolutionize the way students learn by combining interactivity and gamification.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Our Mission',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Our mission is to simplify learning for students. We understand that each student is unique, and we are dedicated to providing a learning environment that is not only effective but also enjoyable. We believe in the power of education to transform lives, and we aim to make the learning journey a seamless and rewarding one.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Our Vision',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Our vision is to see every student thrive and succeed. We envision a future where learning is not a chore but an exciting adventure. By offering interactive and gamifying learning experiences, we aspire to ignite the passion for knowledge in every student. We are committed to shaping a world where education is not just about acquiring information but also about fostering curiosity, critical thinking, and creativity.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'What We Offer',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Interactive Learning: ',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '''* Engage with educational content in a dynamic and interactive manner\n* Explore subjects through visually stimulating materials and immersive experiences.''',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Gamified Learning: ',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '''* Transform the learning experience into a game-like adventure.\n* Earn rewards, achievements, and recognition as you progress through your educational journey.''',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Question and Answer: ',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '''* Foster a collaborative learning environment where students can ask questions and receive timely answers.\n* Encourage peer-to-peer interaction and knowledge sharing.''',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Math Solving: ',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '''* Access a powerful tool for solving math problems with step-by-step guidance.\n* Develop a deeper understanding of mathematical concepts through interactive problem-solving.''',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Image Snap & Study: ',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '''* Seamlessly integrate visual learning into your study routine.\n* Capture images and use them as study aids, making learning more personalized and relatable.''',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Our Flagship Product: Risho Speech',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Risho Speech is an innovative platform designed to enhance English language learning through advanced AI technology. It offers a comprehensive suite of features aimed at improving pronunciation, vocabulary, and overall language fluency. Through interactive lessons and personalized feedback, users can refine their speaking skills with confidence. Whether you\'re a beginner or aiming for advanced proficiency, Risho Speech provides a dynamic and supportive environment for mastering English.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Our Team',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Our team consists of passionate developers, AI specialists, and language educators dedicated to making a difference in the field of language learning. We are constantly working to improve Shonod AI and introduce new features that will further enhance your learning experience.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'We love hearing from our users! If you have any questions, feedback, or suggestions, feel free to reach out to us at ',
              style: TextStyle(fontSize: 16),
            ),
            InkWell(
              onTap: _launchEmail,
              child: Text(
                'info@shonod.com',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Thank you for choosing Risho Speech!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _launchEmail() async {
    final String email = 'info@shonod.com';
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );
    var url = params.toString();
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      throw 'Could not launch $url';
    }
  }
}
