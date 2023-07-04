import './piece.dart';
import './values.dart';

class PixelDetailsCalc {
  int row;
  int col;
  PixelDetailsCalc(int index)
      : row = (index / rowLength).floor(),
        col = index % rowLength;
}

class PieceDetailsCalc {
  int row;
  int col;
  PieceDetailsCalc(Piece piece, int index)
      : row = (piece.position[index] / rowLength).floor(),
        col = piece.position[index] % rowLength;
}

// check for collision in a futere position
//(return true -> collision/return false -> no collision)
bool checkCollision(MoveDirection direction, List<List<Tetromino?>> gameBoard,
    Piece currentPiece) {
  // loop by each position of the current piece
  for (int i = 0; i < currentPiece.position.length; i++) {
    PieceDetailsCalc details = PieceDetailsCalc(currentPiece, i);

    switch (direction) {
      case MoveDirection.left:
        details.col -= 1;
        break;
      case MoveDirection.right:
        details.col += 1;
        break;
      case MoveDirection.down:
        details.row += 1;
        break;
      default:
    }

    // check piece is out
    if (details.row >= colLength ||
        details.col < 0 ||
        details.col >= rowLength) {
      return true;
    }

    if (details.row >= 0 && details.col >= 0) {
      if (gameBoard[details.row][details.col] != null) {
        return true;
      }
    }
  }
  return false;
}
