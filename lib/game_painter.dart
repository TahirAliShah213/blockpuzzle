import 'package:flutter/material.dart';
import 'game_piece.dart';

class GamePainter extends CustomPainter {
  final List<List<Color?>> board;
  final GamePiece currentPiece;
  final int ghostRow;
  final double cellSize;
  final int rows;
  final int cols;

  // 🔥 NEW: Theme based colors
  final Color backgroundColor;
  final Color gridColor;
  final Color highlightColor;
  final Color shadowColor;

  GamePainter({
    required this.board,
    required this.currentPiece,
    required this.ghostRow,
    required this.cellSize,
    required this.rows,
    required this.cols,
    required this.backgroundColor,
    required this.gridColor,
    required this.highlightColor,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ✅ Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    // ✅ Grid
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    for (int r = 0; r <= rows; r++) {
      canvas.drawLine(
        Offset(0, r * cellSize),
        Offset(cols * cellSize, r * cellSize),
        gridPaint,
      );
    }

    for (int c = 0; c <= cols; c++) {
      canvas.drawLine(
        Offset(c * cellSize, 0),
        Offset(c * cellSize, rows * cellSize),
        gridPaint,
      );
    }

    // ✅ Locked blocks
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (board[r][c] != null) {
          _drawBlock(canvas, c, r, board[r][c]!);
        }
      }
    }

    // ✅ Ghost piece
    for (int r = 0; r < currentPiece.shape.length; r++) {
      for (int c = 0; c < currentPiece.shape[r].length; c++) {
        if (currentPiece.shape[r][c] == 1) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(
                (currentPiece.col + c) * cellSize + 1,
                (ghostRow + r) * cellSize + 1,
                cellSize - 2,
                cellSize - 2,
              ),
              const Radius.circular(3),
            ),
            Paint()..color = currentPiece.color.withOpacity(0.2),
          );
        }
      }
    }

    // ✅ Current piece
    for (int r = 0; r < currentPiece.shape.length; r++) {
      for (int c = 0; c < currentPiece.shape[r].length; c++) {
        if (currentPiece.shape[r][c] == 1) {
          _drawBlock(
            canvas,
            currentPiece.col + c,
            currentPiece.row + r,
            currentPiece.color,
          );
        }
      }
    }
  }

  void _drawBlock(Canvas canvas, int col, int row, Color color) {
    final rect = Rect.fromLTWH(
      col * cellSize + 1,
      row * cellSize + 1,
      cellSize - 2,
      cellSize - 2,
    );

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(3));

    // Main block
    canvas.drawRRect(rrect, Paint()..color = color);

    // Highlight (top)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          col * cellSize + 1,
          row * cellSize + 1,
          cellSize - 2,
          cellSize * 0.35,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = highlightColor,
    );

    // Shadow (bottom)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          col * cellSize + 1,
          (row + 1) * cellSize - cellSize * 0.35,
          cellSize - 2,
          cellSize * 0.35 - 1,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = shadowColor,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}