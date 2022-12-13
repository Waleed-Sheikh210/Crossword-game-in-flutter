import 'dart:math';

import 'package:flutter/material.dart';
import 'package:crossword_demo/wordSearch.dart';
import 'package:word_search_safety/word_search_safety.dart';

void main() {
  runApp(MaterialApp(
    home:Crossword()
  ));
}

class Crossword extends StatefulWidget {
  const Crossword({super.key});

  @override
  State<Crossword> createState() => _CrosswordState();
}

class _CrosswordState extends State<Crossword> {

  List<String> _words = [
                      'MIRROR',
                      'BIN',
                      'PILLOW',
                      'BED',
                      'SOFA',
                      'CUSHION',
                      'BLANKET',
                      'PLAYER'
                      ];

  List<String> _alphabets = [];
var _wordsColorMap = new Map();

  bool _isScrollLocked = false;

  void _lockUnlockScroll(bool lock){
    setState(() {
      _isScrollLocked = lock;
    });
  }

  void _changeWordColorOnWordFound(String word){
    _wordsColorMap[_words.indexOf(word)] = Colors.white;
  }

  void _setupAlphabets(){
    final WSSettings mazeSettings = WSSettings(
    width: 7,
    height: 7,
    orientations: List.from([
      WSOrientation.horizontal,
      WSOrientation.vertical,
      WSOrientation.diagonal,
    ]),
    );

    WordSearchSafety wordSearchSafety = new WordSearchSafety();
    final WSNewPuzzle generatedMaze = wordSearchSafety.newPuzzle(_words, mazeSettings);

    for(int i=0;i<generatedMaze.puzzle!.length;i++){
      for(int j=0;j<generatedMaze.puzzle![i].length;j++){
        _alphabets.add(generatedMaze.puzzle![i][j].toUpperCase());
      }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    _setupAlphabets();
    for(int i=0;i<_words.length;i++){
      _wordsColorMap[i] = Colors.white.withOpacity(0.5);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
          Color(0xFF0d647c),
          Color(0xFF072331)
        ]),
        
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("World Puzzle"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          child: SingleChildScrollView(
            physics: _isScrollLocked ? NeverScrollableScrollPhysics() : ScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 10,),
                Container(
                  // width: 400,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.1),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 14),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Words: ",style: TextStyle(color: Colors.yellow)),
                      SizedBox(height: 15),
                     GridView.count(
                      childAspectRatio: 18/6,
                      crossAxisSpacing: 50,
                      shrinkWrap: true,
                      children: [
                        for(int i=0;i<_words.length;i++)
                        Text(_words[i][0]+_words[i].substring(1).toLowerCase(),style: TextStyle(color: _wordsColorMap[i]))
                      ],
                      crossAxisCount: 3)
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                   WordSearch(wordsPerLine: 7,
                      alphabet: _alphabets,
                      words: _words,
                      lockScrollFunction: _lockUnlockScroll,
                      changeWordColorOnWordFoundFunction: _changeWordColorOnWordFound, 
                  ),
                  SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.fromLTRB(50, 12, 50, 12)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.3)),
                      ),
                      child: Text("Quit Puzzle"),
                      onPressed: (() {
                        
                      }),
                    ),
                  )
              ],
            ),
          ),)
      ),
    );
  }
}

/*
[
                        'B',
                        'I',
                        'S',
                        'O',
                        'F',
                        'A',
                        'B',
                        'P',
                        'I',
                        'L',
                        'L',
                        'O',
                        'W',
                        'L',
                        'I',
                        'H',
                        'N',
                        'B',
                        'E',
                        'D',
                        'A',
                        'C',
                        'U',
                        'S',
                        'H',
                        'I',
                        'O',
                        'N',
                        'R',
                        'E',
                        'Y',
                        'A',
                        'L',
                        'P',
                        'K',
                        'A',
                        'L',
                        'T',
                        'B',
                        'I',
                        'W',
                        'E',
                        'R',
                        'O',
                        'R',
                        'R',
                        'I',
                        'M',
                        'T'
                      ]
 */
