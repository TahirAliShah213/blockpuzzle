# Block Puzzle Game - Quick Start Guide 🎮

## 5 Minute Setup

### Step 1: Create Project
```bash
flutter create block_puzzle
cd block_puzzle
```

### Step 2: Copy Code
- **Option A (Basic Version):** 
  - `lib/main.dart` ko delete karo
  - Provided `main.dart` ko `lib/` folder mein paste karo

- **Option B (Advanced with Animations):**
  - `lib/main.dart` ko delete karo  
  - `main_advanced.dart` ko `lib/main.dart` rename karke paste karo

### Step 3: Run Game
```bash
flutter run
```

Done! Game khelnay ke liye ready hai! 🎯

---

## Features Comparison

### Basic Version (main.dart)
✅ Simple, clean code  
✅ All core gameplay  
✅ ~400 lines  
✅ Perfect for learning  
✅ Works on all devices  

### Advanced Version (main_advanced.dart)
✅ **Animations** - Line clear effects
✅ **Haptic Feedback** - Vibration on actions  
✅ **Better UI** - Shadows, scaled buttons  
✅ **Smooth clearing** - Zoom animation  
✅ More visual feedback  
✅ ~550 lines  

---

## Game Rules

1. **Block aata hai** - Top se random tetromino
2. **Move karo** - Drag ya buttons se
3. **Place karo** - Drop button
4. **Lines clear** - Full row/column = points
5. **Level up** - Speed badhta hai
6. **Game Over** - Jab koi piece fit na ho

---

## Controls Cheat Sheet

| Action | Desktop | Mobile |
|--------|---------|--------|
| Left | ← Arrow | Swipe Left |
| Right | → Arrow | Swipe Right |
| Rotate | ↑ Arrow | Tap Rotate |
| Drop | Space / ↓ | Swipe Down / Tap Drop |
| Speed | Auto | Auto |

---

## Scoring Breakdown

```
10 x Level = Block place
100 x Level = 1 line clear
300 x Level = 2 lines
500 x Level = 3 lines
800 x Level = 4 lines (TETRIS!)
```

**Example:** Level 3 mein 4 lines = 800 × 3 = 2400 points! 🔥

---

## Customization Ideas

### 1. Colors Change Karo
```dart
final List<Color> pieceColors = [
  Colors.red,
  Colors.purple,
  Colors.cyan,
  // Apna favorite color add karo
];
```

### 2. Speed Adjust Karo
```dart
dropInterval = 600;  // Faster (original: 800)
```

### 3. Grid Size Change Karo
```dart
static const int COLS = 8;    // Original: 10
static const int ROWS = 16;   // Original: 18
```

### 4. More Shapes Add Karo
```dart
[[1, 1, 1, 1, 1, 1]], // 6-length I
[[1, 1, 1, 1, 1, 1, 1]], // 7-length
```

### 5. Difficulty Levels
```dart
enum Difficulty { easy, medium, hard }

// easy: slow speed, few shapes
// medium: normal speed, all shapes  
// hard: fast speed, only I-blocks!
```

---

## Testing Checklist

- [ ] Game start करता है
- [ ] Blocks सही जगह गिरते हैं
- [ ] Rotation काम करता है
- [ ] Lines clear होती हैं
- [ ] Score increase होता है
- [ ] Level up होता है
- [ ] Speed बढ़ता है
- [ ] Game Over होता है
- [ ] New Game शुरू होती है

---

## Build for Release

### Android APK बनाओ
```bash
flutter build apk --release
```
Output: `build/app/release/app-release.apk`

### Google Play के लिए
```bash
flutter build appbundle --release
```

### iOS App बनाओ  
```bash
flutter build ios --release
```
(Requires macOS with Xcode)

---

## Troubleshooting

**Problem:** Game नहीं चल रहा है
```bash
flutter clean
flutter pub get
flutter run -v
```

**Problem:** Blocks सही नहीं आ रहे
- Check करो `tetrisShapes` array
- Verify करो `canFit()` function

**Problem:** Performance slow है
```bash
flutter run --release  # Release mode mein faster
```

**Problem:** Build error
```bash
flutter doctor  # Check करो setup
```

---

## Next Steps (Advanced)

### Add करने के लिए Ideas:
1. **Sound Effects** - package: `audioplayers`
2. **Local Storage** - package: `shared_preferences` 
3. **Multiplayer** - package: `firebase_realtime_database`
4. **Leaderboard** - Cloud Firestore
5. **Themes** - Dark/Light mode toggle
6. **Analytics** - Firebase Analytics
7. **Ads** - Google Mobile Ads

---

## File Structure

```
block_puzzle/
├── lib/
│   └── main.dart           # Game code
├── pubspec.yaml            # Dependencies
├── README.md               # Full documentation
└── android/                # Android files
```

---

## Performance Tips

- ✅ Use `const` constructors
- ✅ Avoid rebuilding entire widget
- ✅ Use `CustomPaint` for game board
- ✅ Keep `setState()` minimal
- ✅ Use `Timer` for game loop

---

## Debug Tips

```dart
// Print board state
print(board.map((row) => row.map((c) => c != null ? 'X' : '.').join()).join('\n'));

// Check if piece fits
print('Can fit: ${canFit(shape, row, col)}');

// Log score changes
print('Score: $score | Lines: $linesCleared');
```

---

## Support / Help

अगर कोई issue आए:
1. Check करो `flutter doctor`
2. Run करो `flutter clean && flutter pub get`
3. See करो error message carefully
4. Google पर search करो error

---

**Happy Gaming! 🎮✨**

Aur enjoy करो apna game! 
Apne dost ko bhi share karna! 📱

