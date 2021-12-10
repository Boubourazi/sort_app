import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

typedef void SortFunction();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sort demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Demonstration live'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  final int size = 40;
  final List<String> sortList = [
    "Bubble Sort",
    "Selection Sort",
    "Insertion Sort",
  ];
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List list = [];
  String _selectedValue = "";
  bool isSorting = false;
  int speed = 5;
  List<SortFunction> sortFunctions = [];

  @override
  void initState() {
    list = List.generate(widget.size, (index) => index + 1);
    _selectedValue = widget.sortList[0];
    sortFunctions = [bubbleSort, selectionSort, insertionSort];

    super.initState();
  }

  void bubbleSort() async {
    if (isSorting) {
      return null;
    }
    setState(() {
      isSorting = true;
    });
    int lengthOfArray = list.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (list[j] > list[j + 1]) {
          await Future.delayed(Duration(milliseconds: 2));
          int temp = list[j];
          setState(() {
            list[j] = list[j + 1];
            list[j + 1] = temp;
          });
        }
      }
    }
    setState(() {
      isSorting = false;
    });
  }

  void selectionSort() async {
    if (isSorting) {
      return null;
    }
    setState(() {
      isSorting = true;
    });
    var n = list.length;
    for (var i = 0; i < n - 1; i++) {
      await Future.delayed(Duration(milliseconds: 2));
      var indexMin = i;
      for (var j = i + 1; j < n; j++) {
        if (list[j] < list[indexMin]) {
          indexMin = j;
        }
      }
      if (indexMin != i) {
        var temp = list[i];
        setState(() {
          list[i] = list[indexMin];
          list[indexMin] = temp;
        });
      }
    }
    setState(() {
      isSorting = false;
    });
  }

  void insertionSort() async {
    if (isSorting) {
      return null;
    }
    setState(() {
      isSorting = true;
    });
    for (int j = 1; j < list.length; j++) {
      int key = list[j];

      int i = j - 1;

      while (i >= 0 && list[i] > key) {
        await Future.delayed(Duration(milliseconds: 2));
        setState(() {
          list[i + 1] = list[i];
          i = i - 1;
          list[i + 1] = key;
        });
      }
    }
    setState(() {
      isSorting = false;
    });
  }

  void partition(arr, low, high) {
    var temp;
    var pivot = arr[high];

    // index of smaller element
    var i = (low - 1);
    for (var j = low; j <= high - 1; j++) {
      // If current element is smaller
      // than or equal to pivot
      if (arr[j] <= pivot) {
        i++;

        // swap arr[i] and arr[j]
        temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
      }
    }

    // swap arr[i+1] and arr[high]
    // (or pivot)

    temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;

    return i + 1;
  }

  void setList() {
    Random random = Random();
    list = list.map((e) => random.nextInt(11).toInt() + 1).toList();
  }

  void resetList() {
    setState(() {
      Random random = Random();
      list = list.map((e) => random.nextInt(11).toInt() + 1).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 30),
            child: Text("by Aurélien LLORCA"),
          ),
        ],
      ),
      body: Column(
        children: [
          Spacer(
            flex: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: this
                .list
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      width: 6,
                      height: e * 300 / list.length,
                      color: Colors.red,
                    ),
                  ),
                )
                .toList(),
          ),
          Spacer(
            flex: 2,
          ),
          Spacer(
            flex: 1,
          ),
          Text("${list.length} values"),
          Padding(
            padding: const EdgeInsets.only(left: 400, right: 400),
            child: Slider(
              min: 1,
              max: 200,
              value: list.length.toDouble(),
              onChanged: isSorting
                  ? null
                  : (value) {
                      setState(() {
                        list =
                            List.generate(value.toInt(), (index) => index + 1);
                        list.shuffle();
                      });
                    },
            ),
          ),
          Spacer(
            flex: 2,
          ),
          /*Padding(
            padding: const EdgeInsets.only(left: 400, right: 600),
            child: Slider(
              min: 1,
              max: 100,
              value: speed.toDouble(),
              onChanged: (value) {
                setState(() {
                  speed = value.toInt();
                });
              },
            ),
          ),*/
          DropdownButton(
              value: _selectedValue,
              onChanged: (String? value) {
                setState(() {
                  _selectedValue = value!;
                });
              },
              items: widget.sortList
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList()),
          TextButton(
            onPressed: sortFunctions[widget.sortList.indexOf(_selectedValue)],
            child: Text(
              "Start sort !",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("Check my LinkedIn profile here : "),
                VerticalDivider(
                  width: 20,
                ),
                IconButton(
                  onPressed: () async {
                    launch("http://www.linkedin.com/in/aurelienllorca");
                  },
                  icon: Image.asset(
                    "assets/linkedInLogo.png",
                    width: 50,
                    height: 50,
                  ),
                )
              ],
            ),
          ),
          TextButton(
              onPressed: () {
                launch("https://github.com/Boubourazi/sort_app");
              },
              child: Text("Check source code here "))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Shuffle",
        onPressed: () {
          setState(() {
            list.shuffle();
          });
        },
        child: Icon(Icons.shuffle),
      ),
    );
  }
}
