import 'package:flutter/material.dart';
import 'package:recipe_book/pages/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'App Version:',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const Text(
                AppConfig.appVersion, // Replace with actual version number
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 23),
              const Text(
                'About RecipeBook:',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                        text:
                            'Welcome to RecipeBook, your ultimate offline recipe companion!\n'),
                    TextSpan(
                        text:
                            'RecipeBook is designed to help you discover, organize, and cook delicious recipes right from your device, without the need for an internet connection.\n'),
                    TextSpan(
                        text:
                            'Whether you\'re a seasoned chef or a cooking novice, RecipeBook has something for everyone.')
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Acknowledgments:',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'RecipeBook acknowledges the following third-party libraries and resources for their contributions to the application:',
                style: TextStyle(fontSize: 20),
              ),
              _buildAcknowledgments(
                'Hive Flutter',
                'A lightweight and efficient database for storing recipe data offline.',
              ),
              _buildAcknowledgments(
                'Provider Package',
                'A state management solution for managing theme preferences and application state.',
              ),
              const SizedBox(height: 20),
              const Text(
                'Features:',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              _buildFeature(
                  'Browse a vast collection of recipes across various categories.'),
              _buildFeature('Save your favorite recipes for quick access.'),
              _buildFeature(
                  'Manage your ingredients and create shopping lists.'),
              _buildFeature(
                  'Enjoy a seamless offline experience without internet dependency.'),
              const SizedBox(height: 20),
              const Text(
                'Frequently Asked Questions:',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              const FAQItem(
                question: 'How do I save a recipe as a favorite?',
                answer:
                    'To save a recipe as a favorite, simply navigate to the recipe home page then click the "Add to Favorites" from popdown menu.',
              ),
              const SizedBox(
                height: 10,
              ),
              const FAQItem(
                question: 'Can I access my saved recipes offline?',
                answer:
                    'Yes, RecipeBook allows you to access your saved recipes offline. Once you\'ve saved a recipe, you can view it anytime, anywhere, even without an internet connection.',
              ),
              const SizedBox(
                height: 10,
              ),
              const FAQItem(
                question: 'Are the recipes categorized?',
                answer:
                    'Yes, RecipeBook allows you to create your own custom categories. You can browse recipes by category, such as breakfast, lunch, dinner, desserts, and more.',
              ),
              const SizedBox(
                height: 10,
              ),
              const FAQItem(
                question: 'Is there a way to customize the app\'s theme?',
                answer:
                    'Yes, RecipeBook allows you to customize the app\'s theme according to your preferences. You can choose between light and dark mode, depending on your preference for day or night usage.',
              ),
              const SizedBox(
                height: 10,
              ),
              const FAQItem(
                question: 'Is my data secure and private?',
                answer:
                    'Yes, RecipeBook prioritizes user privacy and security. All your recipe and user data is stored locally on your device and is not shared with any third parties. We take your privacy seriously and ensure that your data remains safe and secure.',
              ),
              const SizedBox(
                height: 10,
              ),
              const FAQItem(
                  question:
                      'Can I suggest new features or improvements for the app?',
                  answer:
                      'Absolutely! We welcome feedback and suggestions from our users. If you have any ideas for new features or improvements, please don\'t hesitate to reach out to us at ',
                  email: 'feedback@recipebook.com'),
              const SizedBox(height: 20),
              const Text(
                'Contact Information:',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'For questions, feedback, or support requests, please contact us at ',
                style: TextStyle(fontSize: 20),
              ),
              _buildEmailLink('support@recipebook.com'),
              const SizedBox(height: 20),
              const Text(
                'Privacy Policy:',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'RecipeBook respects your privacy and does not collect any personal data. All recipe and user data is stored locally on your device and is not shared with any third parties.',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 8,
            child: Icon(Icons.arrow_right),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Text(
            feature,
            style: const TextStyle(fontSize: 20),
          )),
        ],
      ),
    );
  }
}

Widget _buildAcknowledgments(String library, String description) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        library,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        description,
        style: const TextStyle(fontSize: 18),
      ),
      const SizedBox(height: 10),
    ],
  );
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;
  final String? email;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
    this.email,
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
        if (email != null) _buildEmailLink(email!),
        const SizedBox(height: 10),
      ],
    );
  }
}

Widget _buildEmailLink(String email) {
  return GestureDetector(
    onTap: () => _launchEmail(email),
    child: Text(
      email,
      style: const TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
        fontSize: 18,
      ),
    ),
  );
}

void _launchEmail(String email) async {
  final Uri emailUri = Uri.parse('mailto:$email');
  await launchUrl(emailUri);
}
