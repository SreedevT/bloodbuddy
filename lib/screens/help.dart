import 'package:flutter/material.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help and Support"),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                "Contact Information",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Get in touch with our support team.",
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    title: Text("Contact Information"),
                    content: Text(
                      "For any support or inquiries, please contact us at:\n\nE-mail: bloodbuddy@gmail.com",
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                "Donation Guidelines",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Learn about blood donation guidelines.",
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    title: Text("Donation Guidelines"),
                    content: Text(
                      "1. Ensure you meet the eligibility criteria for blood donation.\n\n2. Maintain a healthy lifestyle and stay hydrated before donation.\n\n3. Bring a valid identification document.\n\n4. Get a good night's sleep before donation.\n\n5. Eat a nutritious meal before donation.\n\n6. Follow post-donation care instructions provided by the medical staff.",
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text(
                "Feedback and Suggestions",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Share your feedback and suggestions with us.",
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    title: Text("Feedback and Suggestions"),
                    content: Text(
                      "We value your feedback and suggestions. Please feel free to share your thoughts and ideas with us through our official communication channels. Your input helps us improve our services and provide a better experience for our users. Thank you for your support!",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
