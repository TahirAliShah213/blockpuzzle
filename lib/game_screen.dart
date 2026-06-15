import 'package:blockpuzzle/score_service.dart';
import 'package:blockpuzzle/stat_card.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../setting_screen.dart';
import 'control_button.dart';
import 'game_painter.dart';
import 'game_piece.dart';
import 'home_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int COLS = 10;
  static const int ROWS = 18;

  late List<List<Color?>> board;
  late GamePiece currentPiece;
  late Random random;

  int score = 0;
  int best = 0;
  int linesCleared = 0;
  int level = 1;

  Timer? gameTimer;
  int dropInterval = 800;
  bool gameRunning = false;
  int ghostRow = 0;

  final List<Color> pieceColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.amber,
    Colors.purple,
    Colors.pink,
    Colors.orange,
    Colors.teal,
  ];

  final List<List<List<int>>> shapes = [
    [[1, 1, 1, 1]],
    [[1, 1], [1, 1]],
    [[1, 1, 1], [0, 1, 0]],
    [[1, 1, 1], [1, 0, 0]],
    [[1, 1, 1], [0, 0, 1]],
    [[1, 1, 0], [0, 1, 1]],
    [[0, 1, 1], [1, 1, 0]],
  ];

  @override
  void initState() {
    super.initState();
    random = Random();
    initGame();
  }

  void initGame() {
    board = List.generate(ROWS, (_) => List.filled(COLS, null));
    score = 0;
    linesCleared = 0;
    level = 1;
    dropInterval = 800;
    gameRunning = true;
    loadBest();

    spawnPiece();
    startTimer();
  }

  void spawnPiece() {
    currentPiece = GamePiece(
      shape: List.from(shapes[random.nextInt(shapes.length)]),
      color: pieceColors[random.nextInt(pieceColors.length)],
      row: 0,
      col: (COLS ~/ 2) - 2,
    );

    if (!canFit(currentPiece.shape, currentPiece.row, currentPiece.col)) {
      endGame();
    }

    updateGhost();
  }

  void startTimer() {
    gameTimer?.cancel();
    gameTimer = Timer.periodic(
      Duration(milliseconds: dropInterval),
          (_) => tick(),
    );
  }

  void tick() {
    if (!gameRunning) return;

    if (canFit(currentPiece.shape, currentPiece.row + 1, currentPiece.col)) {
      currentPiece.row++;
    } else {
      lockPiece();
    }

    updateGhost();
    setState(() {});
  }

  bool canFit(List<List<int>> shape, int row, int col) {
    for (int r = 0; r < shape.length; r++) {
      for (int c = 0; c < shape[r].length; c++) {
        if (shape[r][c] == 1) {
          int nr = row + r;
          int nc = col + c;

          if (nr < 0 || nr >= ROWS || nc < 0 || nc >= COLS) return false;
          if (board[nr][nc] != null) return false;
        }
      }
    }
    return true;
  }

  void lockPiece() {
    for (int r = 0; r < currentPiece.shape.length; r++) {
      for (int c = 0; c < currentPiece.shape[r].length; c++) {
        if (currentPiece.shape[r][c] == 1) {
          board[currentPiece.row + r][currentPiece.col + c] =
              currentPiece.color;
        }
      }
    }

    int cleared = clearLines();
    score += cleared * 100;
    linesCleared += cleared;

    level = (linesCleared ~/ 10) + 1;
    dropInterval = max(100, 800 - level * 60);
    startTimer();

    spawnPiece();
  }

  int clearLines() {
    int count = 0;

    for (int r = ROWS - 1; r >= 0;) {
      if (board[r].every((cell) => cell != null)) {
        board.removeAt(r);
        board.insert(0, List.filled(COLS, null));
        count++;
      } else {
        r--;
      }
    }

    return count;
  }

  int getGhostRow() {
    int r = currentPiece.row;
    while (canFit(currentPiece.shape, r + 1, currentPiece.col)) {
      r++;
    }
    return r;
  }

  void updateGhost() {
    ghostRow = getGhostRow();
  }

  void moveLeft() {
    if (canFit(currentPiece.shape, currentPiece.row, currentPiece.col - 1)) {
      currentPiece.col--;
      updateGhost();
      setState(() {});
    }
  }

  void moveRight() {
    if (canFit(currentPiece.shape, currentPiece.row, currentPiece.col + 1)) {
      currentPiece.col++;
      updateGhost();
      setState(() {});
    }
  }

  void rotate() {
    List<List<int>> rotated = rotateShape(currentPiece.shape);

    if (canFit(rotated, currentPiece.row, currentPiece.col)) {
      currentPiece.shape = rotated;
      updateGhost();
      setState(() {});
    }
  }

  List<List<int>> rotateShape(List<List<int>> shape) {
    int rows = shape.length;
    int cols = shape[0].length;

    List<List<int>> rotated =
    List.generate(cols, (_) => List.filled(rows, 0));

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        rotated[c][rows - 1 - r] = shape[r][c];
      }
    }

    return rotated;
  }

  void drop() {
    currentPiece.row = ghostRow;
    lockPiece();
  }

  void loadBest() async {
    int saved = await ScoreService.getHighScore();
    setState(() {
      best = saved;
    });
  }

  Future<void> endGame() async {
    gameRunning = false;
    gameTimer?.cancel();

    await ScoreService.saveScore(score); // 👈 CLEAN CALL

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Game Over",
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

              color: Theme.of(context).colorScheme.surfaceContainerHighest,

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Icon(
                  Icons.emoji_events,
                  color: Colors.amber,
                  size: 60,
                ),

                const SizedBox(height: 12),

                 Text(
                  "GAME OVER",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    letterSpacing: 2,
                    decoration: TextDecoration.none,
                    decorationColor: Colors.transparent,
                  ),
                ),

                const SizedBox(height: 20),

                _scoreRow("Score", score.toString()),
                _scoreRow("Best", best.toString()),
                _scoreRow("Lines", linesCleared.toString()),
                _scoreRow("Level", level.toString()),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() => initGame());
                        },
                        child:  Text(
                          "PLAY AGAIN",
                          style: TextStyle(fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false, // sab remove kar dega
                    );
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
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
          scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  Widget _scoreRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    const reservedH = 56 + 60 + 54 + 46 + 48;

    final availH =
        mq.size.height - reservedH - mq.padding.top - mq.padding.bottom;
    final availW = mq.size.width - 24;

    final cellSize = (min(availH / ROWS, availW / COLS))
        .floorToDouble()
        .clamp(18.0, 40.0);

    final boardW = cellSize * COLS;
    final boardH = cellSize * ROWS;

    return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Block Puzzle"),
        actions: [
         /* IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          )*/
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatCard(label: "Score", value: "$score"),
                StatCard(label: "Best", value: "$best"),
                StatCard(label: "Lines", value: "$linesCleared"),
                StatCard(label: "Level", value: "$level"),
              ],
            ),
          ),

          Expanded(
            child: Center(
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx < -8) {
                    moveLeft();
                  } else if (details.delta.dx > 8) {
                    moveRight();
                  }
                },
                onVerticalDragEnd: (_) {
                  drop();
                },
                child: Container(
                  width: boardW,
                  height: boardH,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: CustomPaint(
                    painter: GamePainter(
                      board: board,
                      currentPiece: currentPiece,
                      ghostRow: ghostRow,
                      cellSize: cellSize,
                      rows: ROWS,
                      cols: COLS,

                      backgroundColor: Theme.of(context).colorScheme.background,
                      gridColor: Theme.of(context).colorScheme.outline.withOpacity(0.3),

                      highlightColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.15)
                          : Colors.white.withOpacity(0.25),

                      shadowColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.5)
                          : Colors.black.withOpacity(0.15),
                    )
                  ),
                ),
              ),
            ),
          ),

          Row(
            children: [
              ControlButton(label: '◀', onPressed: moveLeft),
              ControlButton(label: '↻', onPressed: rotate),
              ControlButton(label: '▼', onPressed: drop),
              ControlButton(label: '▶', onPressed: moveRight),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () {
                gameTimer?.cancel();
                setState(() => initGame());
              },
              child: const Text("New Game"),
            ),
          )
        ],
      ),
    );
  }


}