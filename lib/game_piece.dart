import 'package:flutter/material.dart';

class GamePiece {
  List<List<int>> shape;
  Color color;
  int row;
  int col;

  GamePiece({
    required this.shape,
    required this.color,
    required this.row,
    required this.col,
  });
}