import 'package:blockpuzzle/jelly_button.dart';
import 'package:blockpuzzle/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_screen.dart';
import 'score_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int highScore = 0;
  int lastScore = 0;

  @override
  void initState() {
    super.initState();
    loadScores();
  }

  void loadScores() async {
    highScore = await ScoreService.getHighScore();
    lastScore = await ScoreService.getLastScore();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              "BLOCK PUZZLE",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
                letterSpacing: 3,
              ),
            ),

            const SizedBox(height: 50),

            _menuButton(
              title: "PLAY",
              icon: Icons.play_arrow,
              colors: [Colors.greenAccent, Colors.green],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GameScreen(),
                  ),
                ).then((_) {
                  loadScores(); // 👈 wapas aate hi refresh
                });
              },
            ),

            _menuButton(
              title: "HIGH SCORE",
              icon: Icons.emoji_events,
              colors: [Colors.orangeAccent, Colors.deepOrange],
              onTap: () {
                _showHighScoreDialog(context);
              },
            ),

            _menuButton(
              title: "SETTINGS",
              icon: Icons.settings,
              colors: [Colors.purpleAccent, Colors.deepPurple],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),

            _menuButton(
              title: "EXIT",
              icon: Icons.exit_to_app,
              colors: [Colors.redAccent, Colors.red],
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) =>
                      AlertDialog(
                        title: const Text("Exit Game"),
                        content: const Text("Do you want to exit the app?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => SystemNavigator.pop(),
                            child: const Text("Exit"),
                          ),
                        ],
                      ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton({
    required String title,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child:  JellyButton(
        title: title,
        icon: icon,
        colors: colors,
        onTap: onTap,
      ),
    );
  }

  void _showHighScoreDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "High Score",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
        child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),

        // ✅ FIX: gradient remove, theme color use
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

        const Icon(Icons.emoji_events,
        color: Colors.amber, size: 60),

        const SizedBox(height: 12),


        Text(
        "HIGH SCORE",
        style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
        decoration: TextDecoration.none,
        ),
        ),

        const SizedBox(height: 20),

        _scoreBox("BEST", highScore, Colors.amber),
        const SizedBox(height: 10),
        _scoreBox("LAST GAME", lastScore, Colors.greenAccent),

        const SizedBox(height: 25),

        SizedBox(
        width: double.infinity,
        child: ElevatedButton(
        style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        ),
        onPressed: () => Navigator.pop(context),
        child: Text(
        "OK",
        style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        ),
        ),
        ),
        ),
        ],
        ),
        ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
              parent: anim, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
    );
  }

  Widget _scoreBox(String label, int score, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),

        // ✅ Theme based background
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              // ✅ Theme based text
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.7),
              fontSize: 14,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "$score",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color, // ye rehne do (accent color)
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

