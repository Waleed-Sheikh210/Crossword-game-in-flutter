import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class WordSearch extends StatefulWidget {
  const WordSearch({Key? key, this.alphabet, this.words, this.wordsPerLine,this.lockScrollFunction,this.changeWordColorOnWordFoundFunction})
      : super(key: key);

  final int? wordsPerLine;
  final List<String>? alphabet;
  final List<String>? words;
  final Function? lockScrollFunction;
  final Function? changeWordColorOnWordFoundFunction;

  @override
  _WordSearchState createState() => _WordSearchState();
}

class _WordSearchState extends State<WordSearch> {
  var uniqueLetters;

  List<Coordinates> allCoordinates = [];
  late Coordinates currentCoordinate;

  List<Color> _colorContainers = [];
  List<Color> _letterColorContainer = [];
  List<GlobalKey> _lettersKeys = [];
  List<Color> _highlightColors = [
                                Color(0xFFffe17c),
                                Color(0xFF9bfe89),
                                Color(0xFF89fdf4),
                                Color(0XFFf27739),
                                Color(0xFF3946f2),
                                Color(0xFFf2ee39),
                                Color(0xFFf23939),
                                Color(0xFF5f39f2)
                                 ];
  int _currentHighlightColorIndex = 0;
  var _correctColorMap = new Map();

  String _selectedWord = "";

  final key = GlobalKey();
  //final Set<_Foo> _trackTaped = Set<_Foo>();
  final List<int> _selectedIndex = [];
  final List<int> _correctIndexes = [];
 
    _detectTapedItem(PointerEvent event,bool isPointerDown) {
      widget.lockScrollFunction!(true);
    final RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);

    // var check1 = MediaQuery.of(context).size.width * 2;
    // var check2 = MediaQuery.of(context).size.width / 2;
    // var check3 = MediaQuery.of(context).size.width;
    // Offset lineOffsets = Offset(MediaQuery.of(context).size.width * (-0.02), MediaQuery.of(context).size.height *(-0.385));

    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        /// temporary variable so that the [is] allows access of [index]
        dynamic target = hit.target;
        if (target is _Foo && !_selectedIndex.contains(target.index)) {
          RenderBox letterRenderBox = _lettersKeys[target.index].currentContext?.findRenderObject() as RenderBox;
          print("CurrentWidget: ${_lettersKeys[target.index].currentWidget.toString()}");
          setState(() {
          //_trackTaped.add(target);
          if(isPointerDown){
            print(target.index);
            //Offset onPointerDownOffset = letterRenderBox.localToGlobal(Offset.zero);
            //currentCoordinate = Coordinates(StartPoint: onPointerDownOffset, EndPoint: onPointerDownOffset, color: _highlightColors[_currentHighlightColorIndex]);
            currentCoordinate = Coordinates(StartPoint: local, EndPoint: local, color: _highlightColors[_currentHighlightColorIndex]);
            allCoordinates.add(currentCoordinate);
            //print("Pointer Down: $onPointerDownOffset || ${event.position}");
          }else{
            print(target.index);
            currentCoordinate.EndPoint = local;
            //currentCoordinate.EndPoint = letterRenderBox.localToGlobal(Offset.zero);
            print("Pointer Move: ${letterRenderBox.localToGlobal(Offset.zero)}");
          }
          _selectedIndex.add(target.index);
          _selectedWord = _selectedWord+uniqueLetters[target.index]['letter'];
          //_colorContainers[target.index] = _highlightColors[_currentHighlightColorIndex];
          _letterColorContainer[target.index] = Colors.black;
          });
        }
      }
    }
  }

  void _CheckForAnswer(PointerEvent event){
    widget.lockScrollFunction!(false);
      if(widget.words!.contains(_selectedWord))
      {
        widget.changeWordColorOnWordFoundFunction!(_selectedWord);
        print("Words has: $_selectedWord");
        for(int i=0;i<_selectedIndex.length;i++){
          if(!_correctIndexes.contains(_selectedIndex[i])){
            _correctIndexes.add(_selectedIndex[i]);
            _correctColorMap[_selectedIndex[i]] = _highlightColors[_currentHighlightColorIndex];
          }
        }
        print('Before: $_currentHighlightColorIndex');
        _currentHighlightColorIndex++;
        if(_currentHighlightColorIndex >= _highlightColors.length)
          _currentHighlightColorIndex = 0;
        print('After: $_currentHighlightColorIndex');
      }
      else
      {
        for(int i=0;i<_selectedIndex.length;i++)
        {
          if(!_correctIndexes.contains(_selectedIndex[i])){
            print("Removing: ${uniqueLetters[_selectedIndex[i]]['letter']}");
            //_colorContainers[_selectedIndex[i]] = Colors.transparent;
            _letterColorContainer[_selectedIndex[i]] = Colors.white;
          }else{
            //_colorContainers[_selectedIndex[i]] = _correctColorMap[_selectedIndex[i]];
          }
        }
        allCoordinates.removeLast();
      }
      _selectedWord = "";
      _selectedIndex.clear();
  }

  @override
  void initState() {
    super.initState();
    uniqueLetters = widget.alphabet
        ?.map((letter) => {'letter': letter, 'key': GlobalKey()})
        .toList();

        _lettersKeys = List.generate(uniqueLetters.length, (index) => GlobalKey());
        _colorContainers = List.generate(uniqueLetters.length, (index) =>  Colors.transparent,);
        _letterColorContainer = List.generate(uniqueLetters.length, (index) => Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 14,),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left:10,top: 10),
                child: Text("Letters:",style: TextStyle(color: Colors.yellow)),
              ),
              Listener(
                onPointerDown: (event) {
                  _detectTapedItem(event, true);
                },
                onPointerMove: (event) {
                  _detectTapedItem(event, false);
                },
                onPointerUp: _CheckForAnswer,
                child: CustomPaint(
                  painter: MyCustomPainter(allCoordinates),
                  child: GridView.count(
                  key: key,
                childAspectRatio: 10/9,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: widget.wordsPerLine!,
                children: <Widget>[
                  for (int i = 0; i != uniqueLetters.length; ++i)
                  Foo(
                    index: i,
                    child: Container(
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                       color: _colorContainers[i],
                      ),
                      child: Center(
                            child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            key: uniqueLetters[i]['key'],
                            child: Text(
                              uniqueLetters[i]['letter'],
                              key:_lettersKeys[i],
                              style: TextStyle(
                                color: _letterColorContainer[i],
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                    ),
                  )
                ],
              ),
                ),
              ),
              SizedBox(height: 5,),
            ],
          ),
        ),
      ],
    );
  }
}

class Foo extends SingleChildRenderObjectWidget {
  final int index;

  Foo({Widget? child, required this.index, Key? key}) : super(child: child, key: key);

  @override
  _Foo createRenderObject(BuildContext context) {
    return _Foo()..index = index;
  }

  @override
  void updateRenderObject(BuildContext context, _Foo renderObject) {
    renderObject..index = index;
  }
}

class _Foo extends RenderProxyBox {
  late int index;
}

class MyCustomPainter extends CustomPainter{

  List<Coordinates> coordinates = [];

  MyCustomPainter(List<Coordinates> coordinates){
    this.coordinates = coordinates;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for(Coordinates c in coordinates){
      Paint paint = Paint()
        ..color = c.color
        ..strokeWidth = 35
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(c.StartPoint, c.EndPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class Coordinates{
  Offset StartPoint;
  Offset EndPoint;
  Color color = Colors.transparent;

  Coordinates({
    required this.StartPoint,
    required this.EndPoint,
    required this.color
  });
}

/*
Container(
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                       color: _colorContainers[i],
                      ),
                      child: Center(
                            child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            key: uniqueLetters[i]['key'],
                            child: Text(
                              uniqueLetters[i]['letter'],
                              style: TextStyle(
                                color: _letterColorContainer[i],
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                    ),
 */