import 'package:shared_preferences/shared_preferences.dart';

class ScoreService {
  static const String highScoreKey = "high_score";
  static const String lastScoreKey = "last_score";

  // 🔹 Save score
  static Future<void> saveScore(int score) async {
    final prefs = await SharedPreferences.getInstance();

    int savedBest = prefs.getInt(highScoreKey) ?? 0;

    if (score > savedBest) {
      await prefs.setInt(highScoreKey, score);
    }

    await prefs.setInt(lastScoreKey, score);
  }

  // 🔹 Get high score
  static Future<int> getHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(highScoreKey) ?? 0;
  }

  // 🔹 Get last score
  static Future<int> getLastScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(lastScoreKey) ?? 0;
  }

  // 🔹 Reset (optional)
  static Future<void> resetScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(highScoreKey);
    await prefs.remove(lastScoreKey);
  }
}