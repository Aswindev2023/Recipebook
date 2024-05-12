import 'package:flutter/material.dart';
import 'package:recipe_book/pages/app_config.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App Version:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              AppConfig.appVersion, // Replace with actual version number
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Frequently Asked Questions:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            FAQItem(
              question: 'Question 1?',
              answer: 'Answer 1.',
            ),
            FAQItem(
              question: 'Question 2?',
              answer: 'Answer 2.',
            ),
            // Add more FAQItems as needed
            // Additional Information Section
            // Include sections like Contact Information, Privacy Policy, etc.
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          answer,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
