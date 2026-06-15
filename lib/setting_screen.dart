import 'package:blockpuzzle/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  // 🔐 Privacy Policy Screen open
  void openPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PrivacyPolicyScreen(),
      ),
    );
  }

  // 🎮 How to Play Dialog
  void howToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("How to Play"),
        content: const SingleChildScrollView(
          child: Text(
            "🎮 OBJECTIVE\n"
                "Fit falling blocks into a full row to clear lines and earn points.\n\n"

                "🎯 CONTROLS\n"
                "• ◀ Swipe or button: Move block left\n"
                "• ▶ Swipe or button: Move block right\n"
                "• ↻ Button: Rotate the block\n"
                "• ▼ Swipe down: Drop block faster\n\n"

                "🏆 SCORING\n"
                "• Each cleared line = 100 points\n"
                "• Multiple lines = bonus score\n"
                "• Level increases after every 10 lines\n\n"

                "⚠️ GAME OVER\n"
                "Game ends when new blocks cannot fit at the top of the board.\n\n"

                "💡 TIP\n"
                "Plan ahead using the ghost preview and try to clear multiple lines at once for higher score!",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }

  // ⭐ Rate Us (Play Store open karega)
  void rateUs() async {
    final Uri url = Uri.parse(
        "https://play.google.com/store/apps/details?id=com.blockpuzzlegame.bestofflinegamesforyou");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text("Privacy Policy"),
            onTap: () => openPrivacyPolicy(context),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.gamepad),
            title: const Text("How to Play"),
            onTap: () => howToPlay(context),
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            trailing: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                );
              },
            ),
          ),


          const Divider(),

          ListTile(
            leading: const Icon(Icons.star_rate),
            title: const Text("Rate Us"),
            onTap: rateUs,
          ),
        ],
      ),
    );
  }
}

// ==============================
// 🔐 Privacy Policy Screen
// ==============================

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  final String policyText = """
Privacy Policy for Block Puzzle Games

Effective Date: April 27, 2026

Welcome to Block Puzzle Games!

Your privacy is important to us. This Privacy Policy explains how Block Puzzle Games handles user information.

Information We Collect

Block Puzzle Games does not collect, store, or share any personal information or user data.

•⁠  ⁠No personal data collection
•⁠  ⁠No device information tracking
•⁠  ⁠No location access
•⁠  ⁠No account registration required

Offline Usage

Block Puzzle Games is completely offline and does not require an internet connection to play.

Advertisements

Block Puzzle Games does not display advertisements.

Third-Party Services

Block Puzzle Games does not use any third-party SDKs, analytics tools, or external services.

Permissions

Block Puzzle Games does not request any special permissions from your device.

Children's Privacy

Since no personal data is collected, Block Puzzle Games is safe for players of all ages, including children.

Security

Because no user data is collected or stored, there is no risk of personal information being shared or misused.

Changes to This Privacy Policy

If this Privacy Policy is updated in the future, changes will be reflected on this page with a revised effective date.

Contact Us

If you have any questions about this Privacy Policy, please contact us through the app store listing or developer contact page.

---

By using Block Puzzle Games, you agree to this Privacy Policy.
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            policyText,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}