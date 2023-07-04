import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import './utils.dart';
import './piece.dart';
import './pixel.dart';
import './values.dart';

List<List<Tetromino?>> gameBoard =
    List.generate(colLength, (index) => List.generate(rowLength, (j) => null));

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Piece currentPiece = Piece(type: Tetromino.L);
  int currentScore = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();

    // entry point of widget
    startGame();
  }

  void startGame() {
    currentPiece.initilizePiece();

    // frame refresh rate
    Duration frameRate = const Duration(milliseconds: 400);
    gameLoop(frameRate);
  }

  void checkLanding() {
    // if going down is occupid
    if (checkCollision(MoveDirection.down, gameBoard, currentPiece)) {
      // mark position as occupied on the gameboard
      for (int i = 0; i < currentPiece.position.length; i++) {
        PieceDetailsCalc details = PieceDetailsCalc(currentPiece, i);
        if (details.row >= 0 && details.col >= 0) {
          gameBoard[details.row][details.col] = currentPiece.type;
        }
      }
      // create new peace, because this peace is landed
      createNewPeace();
    }
  }

  // game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        // clear lines
        clearLines();
        //chack landing
        checkLanding();

        // check if game is over
        if (gameOver == true) {
          timer.cancel();
          showGameOverDialog();
        }

        // move current piece
        currentPiece.movePiece(MoveDirection.down);
      });
    });
  }

  void showGameOverDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Game over',
                  style: TextStyle(color: Colors.white)),
              content: Text("Your score is $currentScore",
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.grey[900],
              actions: [
                TextButton(
                    onPressed: () {
                      resetGame();

                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Play Again",
                    ))
              ],
            ));
  }

  void resetGame() {
    // clear the game board
    gameBoard =
        List.generate(colLength, (i) => List.generate(rowLength, (l) => null));
    // new game
    gameOver = false;
    currentScore = 0;
    createNewPeace();
    startGame();
  }

  void createNewPeace() {
    // create random tetromino type
    Random rand = Random();
    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initilizePiece();

    if (isGameOver()) {
      gameOver = true;
    }
  }

  // move piece to left
  void moveLeft() {
    // check collision
    if (!checkCollision(MoveDirection.left, gameBoard, currentPiece)) {
      setState(() {
        currentPiece.movePiece(MoveDirection.left);
      });
    }
  }

  // move piece to left
  void moveRight() {
    // check collision
    if (!checkCollision(MoveDirection.right, gameBoard, currentPiece)) {
      setState(() {
        currentPiece.movePiece(MoveDirection.right);
      });
    }
  }

  // move piece to left
  void rotatePiece() {
    // check collision
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  void clearLines() {
    // loop each row of the game board from bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      // init var if the row if full
      bool rowIsFull = true;

      // check if the row is full (each piece)
      for (int col = 0; col < rowLength; col++) {
        // if peace if empty, set rowIsFull to false and break the loop
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      // if the row is full, clear the row and shift rows down
      if (rowIsFull) {
        // move all rows above the cleared row down by one position
        for (int r = row; r > 0; r--) {
          // copy the above row to the current row
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }

        // set the top row to empty
        gameBoard[0] = List.generate(row, (index) => null);
        //increase  the score
        currentScore++;
      }
    }
  }

  // game over method
  bool isGameOver() {
    //check if any collumns is the top row are filled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }

    // if the top row is empty, the game is not over
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // GAME GRID
          Expanded(
            child: GridView.builder(
                itemCount: rowLength * colLength,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowLength),
                itemBuilder: (context, index) {
                  PixelDetailsCalc details = PixelDetailsCalc(index);

                  if (currentPiece.position.contains(index)) {
                    // current piece
                    return Pixel(
                      color: currentPiece.color,
                    );
                  } else if (gameBoard[details.row][details.col] != null) {
                    // laned piace

                    final Tetromino? tetrominoType =
                        gameBoard[details.row][details.col];

                    return Pixel(
                      color: tetrominoColors[tetrominoType],
                    );
                  } else {
                    // blank pixel
                    return const Pixel(
                      color: Color.fromARGB(255, 27, 27, 27),
                    );
                  }
                }),
          ),

          // SCORE
          Text(
            'Score: $currentScore',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          // GAME CONTROLL
          Padding(
            padding: const EdgeInsets.only(bottom: 50, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // left
                IconButton(
                    onPressed: moveLeft,
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: Colors.white),
                // left
                IconButton(
                    onPressed: rotatePiece,
                    iconSize: 35,
                    icon: const Icon(Icons.rotate_right_sharp),
                    color: Colors.white),
                // right
                IconButton(
                    onPressed: moveRight,
                    icon: const Icon(Icons.arrow_forward_ios),
                    color: Colors.white),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Created by Denis Rybkin',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
