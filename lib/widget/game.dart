import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweeper_flutter/data/board_square.dart';
import 'package:minesweeper_flutter/utils/image_utils.dart';

class GameActivity extends StatefulWidget {

  @override
  State createState() {

  }
}

class _GameActivityState extends State<GameActivity> {

  int rowCount = 18;
  int columnCount = 10;

  // Grid of square
  List<List<BoardSquare>> board;
  // List of clicked squares
  List<bool> openedSquares;
  List<bool> flaggedSquares;

  // Probability that a square be a bomb
  int bombProbability = 3;
  int maxProbability = 15;

  int bombCount = 0;
  int squaresLeft;

  @override
  Widget build(BuildContext context) {

    return null;
  }

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Initialize all the squares with no bombs
    board = List.generate(rowCount, (i) {
      return List.generate(columnCount, (j) {
        return BoardSquare();
      });
    });

    // Initialize list
    openedSquares = List.generate(rowCount * columnCount, (i){
      return false;
    });

    flaggedSquares = List.generate(rowCount * columnCount, (i){
      return false;
    });

    // Reset bomb count
    bombCount = 0;
    squaresLeft = rowCount * columnCount;

    // Generate bombs randomly
    Random random = new Random();
    for (int i = 0 ; i < rowCount ; i++ ) {
      for (int j = 0 ; i < columnCount ; j++) {
        int randNumber = random.nextInt(maxProbability);
        if (randNumber < bombProbability) {
          board[i][j].hasBomb = true;
          bombCount++;
        }
      }
    }


    setState(() {});
  }

  void _handleGameOver() {

  }

  void _handleWin() {

  }

  void _handleTap() {

  }

}