import 'dart:math';

import 'package:demineur/bomb.dart';
import 'package:demineur/numberbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variables
  int numberOfSquare = 9 * 9;
  int numberInEachRow = 9;
  // stocke le nombre de bombes autour
  bool bombShow = false;

  var squareStatus = [];

  final List<int> bombLocation = [];


// Prend un nombre de mine à mettre dans le jeu
  void randomNumberMine(){
    int min = 15;
    int max = 35;

    var rng = new Random();
    var rangeRandom = min + rng.nextInt(max - min);

    for (var i = 0; i < rangeRandom; i++) {
      bombLocation.add(rng.nextInt(80));
    }

  }

  @override
  void initState() {
    super.initState();
    randomNumberMine();

    // init du jeu, chaque case à 0 bombes et is not show
    for (int i = 0; i < numberOfSquare; i++) {
      squareStatus.add([0, false]);
    }
    scanBombs();
  }

  void showCaseNumber(int index) {
    // affiche la case si c'est un nombre : 1,2,3 ...
    if (squareStatus[index][0] != 0) {
      setState(() {
        squareStatus[index][1] = true;
      });

      // si la case c'est 0
    } else if (squareStatus[index][0] == 0) {
      // affiche la case cliqué et 8 case autour à part si c'est un mur
      setState(() {
        squareStatus[index][1] = true;

        // affiche la case left à part si c'est un mur
        if (index % numberInEachRow != 0) {
          // si la cas suivante n'est pas afficher et si c'est 0 alors on la recupère
          if (squareStatus[index - 1][0] == 0 &&
              squareStatus[index - 1][1] == false) {
            showCaseNumber(index - 1);
          }
          // afficher la case de gauche
          squareStatus[index - 1][1] = true;
        }

        // afficher case top left hormis top row ou left wall
        if (index % numberInEachRow != 0 && index >= numberInEachRow) {
          if (squareStatus[index - 1 - numberInEachRow][0] == 0 &&
              squareStatus[index - 1 - numberInEachRow][1] == false) {
            showCaseNumber(index - 1 - numberInEachRow);
          }
          // afficher la case
          squareStatus[index - 1 - numberInEachRow][1] = true;
        }

        // afficher case top hormis top row ou left wall
        if (index >= numberInEachRow) {
          if (squareStatus[index - numberInEachRow][0] == 0 &&
              squareStatus[index - numberInEachRow][1] == false) {
            showCaseNumber(index - numberInEachRow);
          }
          // afficher la case
          squareStatus[index - numberInEachRow][1] = true;
        }

        // afficher top right
        if (index >= numberInEachRow &&
            index % numberInEachRow != numberInEachRow - 1) {
          if (squareStatus[index + 1 - numberInEachRow][0] == 0 &&
              squareStatus[index + 1 - numberInEachRow][1] == false) {
            showCaseNumber(index + 1 - numberInEachRow);
          }
          // afficher la case
          squareStatus[index + 1 - numberInEachRow][1] = true;
        }

        // afficher case right hormis top row ou left wall
        if (index % numberInEachRow != numberInEachRow - 1) {
          if (squareStatus[index + 1][0] == 0 &&
              squareStatus[index + 1][1] == false) {
            showCaseNumber(index + 1);
          }
          // afficher la case
          squareStatus[index + 1][1] = true;
        }

        // afficher case bottom right hormis top row ou left wall
        if (index < numberOfSquare - numberInEachRow &&
            index % numberInEachRow != numberInEachRow) {
          if (squareStatus[index + 1 + numberInEachRow][0] == 0 &&
              squareStatus[index + 1 + numberInEachRow][1] == false) {
            showCaseNumber(index + 1 + numberInEachRow);
          }
          // afficher la case
          squareStatus[index + 1 + numberInEachRow][1] = true;
        }

        // afficher case bottom hormis top row ou left wall
        if (index < numberOfSquare - numberInEachRow) {
          if (squareStatus[index + numberInEachRow][0] == 0 &&
              squareStatus[index + numberInEachRow][1] == false) {
            showCaseNumber(index + numberInEachRow);
          }
          // afficher la case
          squareStatus[index + numberInEachRow][1] = true;
        }

        // afficher case bottom left hormis top row ou left wall
        if (index < numberOfSquare - numberInEachRow &&
            index % numberInEachRow != 0) {
          if (squareStatus[index - 1 + numberInEachRow][0] == 0 &&
              squareStatus[index - 1 + numberInEachRow][1] == false) {
            showCaseNumber(index - 1 + numberInEachRow);
          }
          // afficher la case
          squareStatus[index - 1 + numberInEachRow][1] = true;
        }
      });
    }
  }

  void scanBombs() {
    for (int i = 0; i < numberOfSquare; i++) {
      // no bomb
      int numberOfBombsAround = 0;

      // check chaque case si une bombe est autour donc 8 cases à vérifier

      // check case part la gauche, a part si c'est la 1er colonne
      if (bombLocation.contains(i - 1) && i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }

      // check case 1st col 1st row
      if (bombLocation.contains(i - 1 - numberInEachRow) &&
          i % numberInEachRow != 0 &&
          i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      // check case part le top, a part si c'est la 1er colonne
      if (bombLocation.contains(i - numberInEachRow) && i >= numberInEachRow) {
        numberOfBombsAround++;
      }

      // check case part le top right, a part si c'est la 1er colonne et last col
      if (bombLocation.contains(i + 1 - numberInEachRow) &&
          i >= numberInEachRow &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }

      // check case part le right, a part si c'est la last col
      if (bombLocation.contains(i + 1) &&
          i % numberInEachRow != numberInEachRow - 1) {
        numberOfBombsAround++;
      }

      // check case part le bottom right, a part si c'est la 1er colonne et last col
      if (bombLocation.contains(i + 1 + numberInEachRow) &&
          i % numberInEachRow != numberInEachRow - 1 &&
          i < numberOfSquare - numberInEachRow) {
        numberOfBombsAround++;
      }

      // check case part le bottom, a part si c'est la last col
      if (bombLocation.contains(i + numberInEachRow) &&
          i < numberOfSquare - numberInEachRow) {
        numberOfBombsAround++;
      }

      // check case part le bottom left, a part si c'est la 1er col et last col
      if (bombLocation.contains(i - 1 + numberInEachRow) &&
          i < numberOfSquare - numberInEachRow &&
          i % numberInEachRow != 0) {
        numberOfBombsAround++;
      }

      setState(() {
        squareStatus[i][0] = numberOfBombsAround;
      });
    }
  }

  void gameOver() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            title: Center(
              child: Text(
                'GAME OVER !',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: (){
                  Phoenix.rebirth(context);
                  Navigator.pop(context);
                },
                 icon: Icon(Icons.refresh),
                 label: Text('Rejouer'),
                 ),
            ],
          );
        });
  }

  void gameWin() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: Center(
            child: Text('GAGNÉ !', style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
              TextButton.icon(
                onPressed: (){
                  Phoenix.rebirth(context);
                  Navigator.pop(context);
                },
                 icon: Icon(Icons.refresh),
                 label: Text('Rejouer'),
                 ),
            ],
        );
      });
  }

  void checkWinner(){
    // check le nbr de case restantes
    int caseRestantes = 0;

    for (int i = 0; i < numberOfSquare; i++) {
      if (squareStatus[i][1] == false) {
        caseRestantes++;
      }
    }

    if (caseRestantes == bombLocation.length){
      gameWin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // statut du jeu et menu
          Container(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // affichage nombre de bombes
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(bombLocation.length.toString(),
                        style: TextStyle(fontSize: 40)),
                    Text('BOMB'),
                  ],
                ),

                // boutton relancer le jeu
                GestureDetector(
                  onTap: (){
                    Phoenix.rebirth(context);
                  },
                  child: Card(
                    child: Icon(Icons.refresh, color: Colors.white, size: 40),
                    color: Colors.grey[700],
                  ),
                ),

                // affichage du temps
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('0', style: TextStyle(fontSize: 40)),
                    Text('TIME'),
                  ],
                )
              ],
            ),
          ),

          //grid
          Expanded(
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: numberOfSquare,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberInEachRow),
                itemBuilder: (context, index) {
                  if (bombLocation.contains(index)) {
                    return MyBomb(
                      isBombShow: bombShow,
                      fnction: () {
                        // clique bombe, joueur perd
                        setState(() {
                          bombShow = true;
                        });
                        gameOver();
                      },
                    );
                  } else {
                    return MyNumberBox(
                      child: squareStatus[index][0],
                      isBombShow: squareStatus[index][1],
                      fnction: () {
                        // clique case, partie continue
                        showCaseNumber(index);
                        checkWinner();
                      },
                    );
                  }
                }),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Text('Shainee Khaldi. Tous droits résérvés'),
          )
        ],
      ),
    );
  }
}
