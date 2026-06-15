# Block Puzzle - Tips, Tricks & Development Guide 💡

## 🎮 Gameplay Tips (How to Score More)

### 1. **Tetris Strategy** (4 Lines = Massive Points!)
```
Goal: Clear 4 lines at once for 800 × Level points

Strategy:
- Bottom 3 lines ko almost full rakh
- Top line ko completely empty rakh
- Jab I-piece (long bar) aaye tab use drop karo
- Boom! 4 lines, huge points!

Example:
Level 5 × 4 lines = 800 × 5 = 4000 points!!! 🔥
```

### 2. **Ghost Piece Use Karo**
- Grey shadow dekhta hai? Wahi final position hai
- Rotation se pehle ghost check karo
- Last-second adjustments possible hain

### 3. **Rotation Wallah Trick**
```
Piece ko rotate करो placement se pehle:
- L piece ko rotate करके different shapes बनाओ
- T piece = 4 rotation states
- Use rotation for tight spaces
```

### 4. **Speed Management**
- Level 1 = 800ms (slow)
- Level 5 = 450ms (medium)  
- Level 10 = 100ms (CRAZY FAST!)
- Plan your moves carefully at high levels

### 5. **Column Strategy**
```
Don't just clear rows:
❌ Row clear = 100 points
✅ Column clear = 100 points

But if you clear both row AND column:
= 200 points + Combo!

Try to create patterns for both!
```

---

## 🔧 Development Tips (Code Improvements)

### Tip 1: Add Sound Effects
```dart
import 'package:audioplayers/audioplayers.dart';

final audioPlayer = AudioPlayer();

void playPlaceSound() async {
  await audioPlayer.play(AssetSource('sounds/place.mp3'));
}

void playClearSound() async {
  await audioPlayer.play(AssetSource('sounds/clear.mp3'));
}

// lockPiece() mein add करो:
lockPiece() {
  // ... code ...
  playPlaceSound();
}

// clearLines() mein:
int clearLines() {
  // ... code ...
  if (count > 0) playClearSound();
}
```

### Tip 2: Add Local High Score Storage
```dart
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveBestScore() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('best_score', best);
}

Future<int> loadBestScore() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('best_score') ?? 0;
}

// initGame() मे:
void initGame() {
  best = await loadBestScore();  // Load करो
  // ... rest ...
}

// endGame() में:
void endGame() {
  if (score > best) {
    best = score;
    saveBestScore();  // Save करो
  }
}
```

### Tip 3: Add Difficulty Levels
```dart
enum GameLevel { easy, medium, hard }

class GameConfig {
  final GameLevel level;
  final int dropSpeed;
  final int maxShapes;
  
  GameConfig({required this.level})
    : dropSpeed = level == GameLevel.easy ? 1000 : 
                  level == GameLevel.medium ? 700 :
                  500,
      maxShapes = level == GameLevel.hard ? 3 : 11;
}

// Use it:
late GameConfig config;

void initGame({GameLevel level = GameLevel.medium}) {
  config = GameConfig(level: level);
  dropInterval = config.dropSpeed;
}
```

### Tip 4: Add Next Piece Preview
```dart
late GamePiece nextPiece;

void initGame() {
  // ... code ...
  nextPiece = createRandomPiece();
}

void lockPiece() {
  // ... code ...
  currentPiece = nextPiece;
  nextPiece = createRandomPiece();  // Naya next piece
}

// UI में:
Widget buildNextPiecePreview() {
  return Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(border: Border.all()),
    child: CustomPaint(
      painter: PiecePainter(nextPiece, cellSize: 30),
      size: Size(120, 120),
    ),
  );
}
```

### Tip 5: Add Combo Counter
```dart
int comboCount = 0;
int maxCombo = 0;

int clearLines() {
  int count = clearingRows.length + clearingCols.length;
  
  if (count > 0) {
    comboCount++;
    if (comboCount > maxCombo) maxCombo = comboCount;
    
    int bonus = comboCount > 1 ? (comboCount - 1) * 50 : 0;
    return pts + bonus;  // Combo bonus add करो!
  } else {
    comboCount = 0;  // Reset combo
  }
  return pts;
}
```

### Tip 6: Add Game Pause
```dart
bool isPaused = false;

void pauseGame() {
  isPaused = true;
  gameTimer.cancel();
  setState(() {});
}

void resumeGame() {
  isPaused = false;
  startGameTimer();
  setState(() {});
}

void tick() {
  if (!gameRunning || isPaused) return;  // Check pause
  // ... rest of code
}

// UI Button:
ElevatedButton(
  onPressed: () => isPaused ? resumeGame() : pauseGame(),
  child: Text(isPaused ? 'Resume' : 'Pause'),
)
```

### Tip 7: Add Wall Kicks (Rotation Near Walls)
```dart
void rotatePiece() {
  List<List<int>> rotated = rotateTetromino(currentPiece.shape);
  
  // Try original position
  if (canFit(rotated, currentPiece.row, currentPiece.col)) {
    currentPiece.shape = rotated;
    return;
  }
  
  // Try left kick
  if (canFit(rotated, currentPiece.row, currentPiece.col - 1)) {
    currentPiece.shape = rotated;
    currentPiece.col--;
    return;
  }
  
  // Try right kick
  if (canFit(rotated, currentPiece.row, currentPiece.col + 1)) {
    currentPiece.shape = rotated;
    currentPiece.col++;
    return;
  }
  
  // Try up kick
  if (canFit(rotated, currentPiece.row - 1, currentPiece.col)) {
    currentPiece.shape = rotated;
    currentPiece.row--;
    return;
  }
  
  // Rotation failed
  HapticFeedback.heavyImpact();  // Haptic feedback
}
```

### Tip 8: Add Particle Effects
```dart
class ParticleEffect {
  final Offset position;
  final Color color;
  late AnimationController controller;
  
  void dispose() => controller.dispose();
}

List<ParticleEffect> particles = [];

void addParticles(int x, int y, Color color) {
  for (int i = 0; i < 8; i++) {
    final angle = (i * 2 * pi) / 8;
    particles.add(ParticleEffect(
      position: Offset(x.toDouble(), y.toDouble()),
      color: color,
    ));
  }
}

// lockPiece() में:
void lockPiece() {
  // ... code ...
  addParticles(currentPiece.col * CELL_SIZE, 
               currentPiece.row * CELL_SIZE,
               currentPiece.color);
}
```

### Tip 9: Add Statistics Screen
```dart
class GameStats {
  int totalLines = 0;
  int totalPieces = 0;
  int maxLevel = 0;
  DateTime gameStartTime = DateTime.now();
  
  Duration get playTime => DateTime.now().difference(gameStartTime);
  double get avgScore => totalLines > 0 ? totalPieces / totalLines : 0;
}

late GameStats stats;

void updateStats() {
  stats.totalPieces++;
  stats.totalLines += linesCleared;
  if (level > stats.maxLevel) stats.maxLevel = level;
}

void showStatsScreen() {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('Game Statistics'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Pieces: ${stats.totalPieces}'),
          Text('Total Lines: ${stats.totalLines}'),
          Text('Max Level: ${stats.maxLevel}'),
          Text('Play Time: ${stats.playTime.inMinutes}m'),
        ],
      ),
    ),
  );
}
```

### Tip 10: Add Animation for Score Changes
```dart
class ScoreWidget extends StatefulWidget {
  final int score;
  const ScoreWidget({required this.score});
  
  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..forward();
  }
  
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(begin: 1.2, end: 1.0).animate(_controller),
      child: Text(
        widget.score.toString(),
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

---

## 📊 Performance Optimization

### Do's ✅
```dart
✅ Use const whenever possible
✅ Minimize setState() calls
✅ Use CustomPaint for heavy drawing
✅ Cache calculations
✅ Use Timer instead of while loops
✅ Cancel timers on dispose
✅ Use List.generate for initialization
```

### Don'ts ❌
```dart
❌ Don't rebuild entire widget tree
❌ Don't create objects in build()
❌ Don't use expensive operations in tick()
❌ Don't forget to cancel timers
❌ Don't use nested loops unnecessarily
❌ Don't recreate lists every frame
```

---

## 🎨 Customization Ideas

### Color Themes
```dart
// Dark Mode
final darkColors = [
  Color(0xFF1A1A2E),
  Color(0xFF16213E),
  Color(0xFF0F3460),
  Color(0xFFE94560),
];

// Neon Mode
final neonColors = [
  Color(0xFF00FF00),
  Color(0xFFFF00FF),
  Color(0xFF00FFFF),
  Color(0xFFFFFF00),
];
```

### Grid Sizes
```dart
// Classic (10x18)
const COLS = 10, ROWS = 18;

// Mobile (8x12)
const COLS = 8, ROWS = 12;

// Extreme (20x30)
const COLS = 20, ROWS = 30;
```

### More Shapes
```dart
// Add more complex shapes
[[1, 1, 1, 1, 1, 1]],  // I-6
[[1, 0, 0], [1, 1, 1], [1, 0, 0]],  // Cross
[[1, 1, 1], [1, 1, 1], [1, 1, 1]],  // 3x3 square
```

---

## 🚀 Publishing to Play Store

1. **Create Release APK**
   ```bash
   flutter build apk --release
   ```

2. **Sign APK**
   - Follow official Flutter docs

3. **Upload to Play Store**
   - Google Play Console
   - Create app listing
   - Add screenshots, description
   - Upload APK
   - Submit for review

4. **App Store (iOS)**
   - Need macOS + Xcode
   - Build IPA
   - Use App Store Connect

---

## 💰 Monetization Ideas

- 🎬 Rewarded video ads
- 🎁 In-app purchases (themes)
- 🏆 Premium features
- 📊 Analytics for improvements

---

**Happy Coding! 🎉**

Ab bahut features add kar sakte ho! 
Keep improving aur share karo apna game! 🚀

