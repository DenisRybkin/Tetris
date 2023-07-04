import 'package:flutter/material.dart';
import './board.dart';
import './utils.dart';

import './values.dart';

class Piece {
  // type of tetris piece
  Tetromino type;

  Piece({required this.type});

  // the piece is just a list of board indexes
  List<int> position = [];

  // color piece by type
  Color get color {
    return tetrominoColors[type] ?? Colors.white;
  }

  // generate the initial positions
  void initilizePiece() {
    switch (type) {
      case Tetromino.L:
        position = [-26, -16, -6, -5];
        break;
      case Tetromino.J:
        position = [-25, -15, -5, -6];
        break;
      case Tetromino.I:
        position = [-4, -5, -6, -7];
        break;
      case Tetromino.O:
        position = [-15, -16, -5, -6];
        break;
      case Tetromino.S:
        position = [-15, -14, -6, -5];
        break;
      case Tetromino.Z:
        position = [-17, -16, -6, -5];
        break;
      case Tetromino.T:
        position = [-26, -16, -6, -15];
        break;
      default:
    }
  }

  // make a replacing on the board
  void movePiece(MoveDirection direction) {
    switch (direction) {
      case MoveDirection.down:
        for (int i = 0; i < position.length; i++) {
          position[i] += rowLength;
        }
        break;
      case MoveDirection.left:
        for (int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case MoveDirection.right:
        for (int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      default:
    }
  }

  // check is valid position
  bool positionIsValid(int position) {
    PixelDetailsCalc details = PixelDetailsCalc(position);

    //if the position is taken, return false
    if (details.row < 0 ||
        details.col < 0 ||
        gameBoard[details.row][details.col] != null) {
      return false;
    }

    return true;
  }

  // check if piece is valid position
  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOccupied = false;
    bool lastColOccupied = false;

    for (int pos in piecePosition) {
      // return false if any position is already taken
      if (!positionIsValid(pos)) {
        return false;
      }

      // get the col position
      int col = pos % rowLength;
      // check if the first or last column is occupid
      if (col == 0) {
        firstColOccupied = true;
      }
      if (col == rowLength - 1) {
        lastColOccupied = true;
      }
    }

    //if there is a piece in the first col and last col, it is going through the wall
    return !(firstColOccupied && lastColOccupied);
  }

  int rotationState = 1;
  // make a rotate
  void rotatePiece() {
    List<int> newPosition = [];

    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            /*
              o
              o
              o o
            */
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength + 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            /*
            o o o
            o
          */
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*
              o o
                o
                o
            */
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength - 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*
                  o
              o o o
            */
            newPosition = [
              position[1] - rowLength + 1,
              position[1],
              position[1] + 1,
              position[1] - 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          default:
        }
        break;
      case Tetromino.J:
        switch (rotationState) {
          case 0:
            /*
               o
               o
             o o
            */
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + rowLength - 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            /*
              o
              o o o
          */
            newPosition = [
              position[1] - rowLength - 1,
              position[1],
              position[1] - 1,
              position[1] + 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*
              o o
              o
              o
            */
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - rowLength + 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*
              o o o
                  o
            */
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] + rowLength + 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          default:
        }
        break;
      case Tetromino.I:
        switch (rotationState) {
          case 0:
            /*
              o o o o
            */
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            /*
              o
              o
              o
              o            
          */
            newPosition = [
              position[1] - rowLength,
              position[1],
              position[1] + rowLength,
              position[1] + 2 * rowLength
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*
              o o o o
            */
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*
              o
              o
              o
              o
            */
            newPosition = [
              position[1] + rowLength,
              position[1],
              position[1] - rowLength,
              position[1] - 2 * rowLength
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          default:
        }
        break;
      case Tetromino.O:
        switch (rotationState) {
          // does not need to rotate
          /*
            o o
            o o
          */
        }
        break;
      case Tetromino.S:
        switch (rotationState) {
          case 0:
            /*
                o o
              o o
            */
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            /*
              o
              o o
                o
          */
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*
                o o             
              o o              
            */
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLength - 1,
              position[1] + rowLength
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*
              o
              o o
                o
            */
            newPosition = [
              position[0] - rowLength,
              position[0],
              position[0] + 1,
              position[0] + rowLength + 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          default:
        }
        break;
      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            /*
              o o 
                o o
            */
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            /*
                o
              o o
              o
          */
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*
              o o              
                o o             
            */
            newPosition = [
              position[0] + rowLength - 2,
              position[1],
              position[2] + rowLength - 1,
              position[3] + 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*
                o
              o o
              o
            */
            newPosition = [
              position[0] - rowLength + 2,
              position[1],
              position[2] - rowLength + 1,
              position[3] - 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          default:
        }
        break;
      case Tetromino.T:
        switch (rotationState) {
          case 0:
            /*
              o
              o o
              o 
            */
            newPosition = [
              position[2] - rowLength,
              position[2],
              position[2] + 1,
              position[2] + rowLength
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            /*
              o o o
                o
          */
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLength
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            /*
                o
              o o             
                o              
            */
            newPosition = [
              position[1] - rowLength,
              position[1] - 1,
              position[1],
              position[1] + rowLength
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            /*
                o
              o o o
            */
            newPosition = [
              position[2] - rowLength,
              position[2] - 1,
              position[2],
              position[2] + 1
            ];
            if (piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          default:
        }
        break;
      default:
    }
  }
}
