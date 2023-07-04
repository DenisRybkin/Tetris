//grid dimensions
import 'package:flutter/material.dart';

int rowLength = 10;
int colLength = 15;

enum MoveDirection { left, right, down }

enum Tetromino { L, J, I, O, S, Z, T }

/*
L:
  o
  o
  o o
J:
  o
  o
o o

I:
  o
  o
  o
  o

O:
  o o
  o o

S:
    o o
  o o 

Z: 
  o o
    o o


T: o
   o o
   o
*/

const Map<Tetromino, Color> tetrominoColors = {
  Tetromino.L: Colors.orange,
  Tetromino.J: Colors.blue,
  Tetromino.I: Colors.pink,
  Tetromino.O: Colors.yellow,
  Tetromino.S: Colors.green,
  Tetromino.Z: Colors.red,
  Tetromino.T: Colors.purple
};
