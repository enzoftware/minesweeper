import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minesweeper_flutter/data/board_square.dart';
import 'package:minesweeper_flutter/utils/image_utils.dart';

class GameActivity extends StatefulWidget {

  @override
  _GameActivityState createState() => _GameActivityState();
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

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.grey,
            height: 60,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    _initializeGame();
                  },
                  child: CircleAvatar(
                    child: Icon(
                      Icons.tag_faces,
                      color: Colors.black,
                      size: 40,
                    ),
                    backgroundColor: Colors.yellowAccent,
                  ),
                )
              ],
            ),
          ),
          // THE GRID VIEW OF SQUARES
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columnCount),
            itemBuilder: (context, position) {
              int rowNumber = (position / columnCount).floor();
              int columnNumber = (position % columnCount);

              Image image;
              if (openedSquares[position] == false) {
                if (flaggedSquares[position] == true) {
                  image = getImage(ImageType.flagged);
                } else {
                  image = getImage(ImageType.facingDown);
                }
              } else {
                if (board[rowNumber][columnNumber].hasBomb) {
                  image = getImage(ImageType.bomb);
                } else {
                  image = getImage(
                    getImageTypeFromNumber(
                        board[rowNumber][columnNumber].bombsAround),
                  );
                }
              }

              return InkWell(
                // Opens square
                onTap: () {
                  if (board[rowNumber][columnNumber].hasBomb) {
                    _handleGameOver();
                  }
                  if (board[rowNumber][columnNumber].bombsAround == 0) {
                    _handleTap(rowNumber, columnNumber);
                  } else {
                    setState(() {
                      openedSquares[position] = true;
                      squaresLeft = squaresLeft - 1;
                    });
                  }

                  if(squaresLeft <= bombCount) {
                    _handleWin();
                  }

                },
                // Flags square
                onLongPress: () {
                  if (openedSquares[position] == false) {
                    setState(() {
                      flaggedSquares[position] = true;
                    });
                  }
                },
                splashColor: Colors.grey,
                child: Container(
                  color: Colors.grey,
                  child: image,
                ),
              );
            },
            itemCount: rowCount * columnCount,
          ),
        ],
      ),
    );
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

    // Resets bomb count
    bombCount = 0;
    squaresLeft = rowCount * columnCount;

    // Randomly generate bombs
    Random random = new Random();
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        int randomNumber = random.nextInt(maxProbability);
        if (randomNumber < bombProbability) {
          board[i][j].hasBomb = true;
          bombCount++;
        }
      }
    }

    // Check bombs around and assign numbers
    for (int i = 0; i < rowCount; i++) {
      for (int j = 0; j < columnCount; j++) {
        if (i > 0 && j > 0) {
          if (board[i - 1][j - 1].hasBomb) {
            board[i][j].bombsAround++;
          }
        }

        if (i > 0) {
          if (board[i - 1][j].hasBomb) {
            board[i][j].bombsAround++;
          }
        }

        if (i > 0 && j < columnCount - 1) {
          if (board[i - 1][j + 1].hasBomb) {
            board[i][j].bombsAround++;
          }
        }

        if (j > 0) {
          if (board[i][j - 1].hasBomb) {
            board[i][j].bombsAround++;
          }
        }

        if (j < columnCount - 1) {
          if (board[i][j + 1].hasBomb) {
            board[i][j].bombsAround++;
          }
        }

        if (i < rowCount - 1 && j > 0) {
          if (board[i + 1][j - 1].hasBomb) {
            board[i][j].bombsAround++;
          }
        }

        if (i < rowCount - 1) {
          if (board[i + 1][j].hasBomb) {
            board[i][j].bombsAround++;
          }
        }

        if (i < rowCount - 1 && j < columnCount - 1) {
          if (board[i + 1][j + 1].hasBomb) {
            board[i][j].bombsAround++;
          }
        }
      }
    }

    setState(() {});
  }

  void _handleGameOver() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Game Over :("),
            content: Text("You click a bomb"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _initializeGame();
                  Navigator.pop(context);
                },
                child: Text("Play again"),
              )
            ],
          );
        }
    );
  }

  void _handleWin() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Congratulations!!!"),
            content: Text("You win the game"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  _initializeGame();
                  Navigator.pop(context);
                },
                child: Text("Play again"),
              )
            ],
          );
        }
    );
  }


  // This function opens other squares around the target square which don't have any bombs around them.
  // We use a recursive function which stops at squares which have a non zero number of bombs around them.
  void _handleTap(int i , int j) {
    int position = (i * columnCount) + j;
    openedSquares[position] = true;
    squaresLeft = squaresLeft - 1;

    if (i > 0) {
      if (!board[i - 1][j].hasBomb &&
          openedSquares[((i - 1) * columnCount) + j] != true) {
        if (board[i][j].bombsAround == 0) {
          _handleTap(i - 1, j);
        }
      }
    }

    if (j > 0) {
      if (!board[i][j - 1].hasBomb &&
          openedSquares[(i * columnCount) + j - 1] != true) {
        if (board[i][j].bombsAround == 0) {
          _handleTap(i, j - 1);
        }
      }
    }

    if (j < columnCount - 1) {
      if (!board[i][j + 1].hasBomb &&
          openedSquares[(i * columnCount) + j + 1] != true) {
        if (board[i][j].bombsAround == 0) {
          _handleTap(i, j + 1);
        }
      }
    }

    if (i < rowCount - 1) {
      if (!board[i + 1][j].hasBomb &&
          openedSquares[((i + 1) * columnCount) + j] != true) {
        if (board[i][j].bombsAround == 0) {
          _handleTap(i + 1, j);
        }
      }
    }

    setState(() {});
  }
}