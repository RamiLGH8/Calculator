import 'dart:ffi';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, home: calculatorInterface()));
}

class calculatorInterface extends StatefulWidget {
  const calculatorInterface({super.key});

  @override
  State<calculatorInterface> createState() => _calculatorInterfaceState();
}

class _calculatorInterfaceState extends State<calculatorInterface> {
  bool isDark = false;
  int indx = 0, num_numbers = 0;
  String stringResult = '', previousString = '';
  double result = 0;
  List<Icon> iconsArray = [
    Icon(
      Icons.sunny,
      color: Colors.grey,
    ),
    Icon(
      Icons.bedtime,
      color: Color.fromRGBO(142, 144, 146, 1),
    )
  ];

  List<String> numbersArray = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.',
    '0',
    '00',
  ];

  double calculate(String expression) {
    List<String> tokens = expression.split(RegExp(r"([+\-*/])"));
    List<String> operators = expression
        .split(RegExp(r"\d+(?:\.\d+)?"))
        .where((s) => s.isNotEmpty)
        .toList();

    // Perform multiplication and division operations first
    for (int i = 0; i < operators.length; i++) {
      if (operators[i] == '*' || operators[i] == '/') {
        double left = double.parse(tokens[i]);
        double right = double.parse(tokens[i + 1]);
        double result = operators[i] == '*' ? left * right : left / right;
        tokens.replaceRange(i, i + 2, [result.toString()]);
        operators.removeAt(i);
        i--;
      }
    }

    // Perform addition and subtraction operations next
    for (int i = 0; i < operators.length; i++) {
      if (operators[i] == '+' || operators[i] == '-') {
        double left = double.parse(tokens[i]);
        double right = double.parse(tokens[i + 1]);
        double result = operators[i] == '+' ? left + right : left - right;
        tokens.replaceRange(i, i + 2, [result.toString()]);
        operators.removeAt(i);
        i--;
      }
    }

    return double.parse(tokens.first);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: isDark
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(55, 55, 55, 1),
                        Color.fromRGBO(0, 3, 9, 1),
                      ],
                    )
                  : null,
              color: !isDark ? Color.fromRGBO(229, 229, 229, 1) : null),
          child: Container(
            width:width,
            child: Column(children: [
              SizedBox(
                height: height / 30,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? Color.fromRGBO(0, 54, 97, 1)
                        : Color.fromRGBO(216, 238, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: (() {
                    setState(() {
                      isDark = !isDark;
                      if (indx == 0)
                        indx = 1;
                      else
                        indx = 0;
                    });
                  }),
                  child: iconsArray[indx]),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: height/10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '$previousString',
                          style: TextStyle(color: Colors.grey, fontSize: 22),
                        ),
                        SizedBox(
                          width: width / 20,
                        )
                      ],
                    ),
                    SizedBox(
                      height: height / 30,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '=',
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 40),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '$stringResult',
                                style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                    fontSize: 40),
                              ),
                              SizedBox(
                                width: width / 20,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 11,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                Color.fromRGBO(0, 18, 63, 1),
                                Color.fromRGBO(42, 125, 161, 1),
                              ],
                            )
                          : LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromRGBO(138, 167, 184, 0.2),
                                Color.fromRGBO(156, 201, 242, 1),
                              ],
                            ),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30)),
                    ),
                    width: width,
                    child: Row(
                      children: [
                        Container(
                          height: height * (1 / 2),
                          width: width * (3 / 4),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30),
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  color: isDark
                                      ? Color.fromRGBO(5, 5, 5, 0.3)
                                      : Color.fromRGBO(255, 255, 255, 0.3),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            stringResult = '';
                                            previousString = '';
                                          });
                                        },
                                        child: Text(
                                          'AC',
                                          style: TextStyle(
                                              fontSize: 26,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                        )),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (stringResult != '') {
                                            stringResult =
                                                stringResult.substring(
                                                    0, stringResult.length - 1);
                                          }
                                        });
                                      },
                                      child: Icon(
                                        Icons.backspace,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            double num =
                                                (double.parse(stringResult)) /
                                                    100;
                                            stringResult = num.toString();
                                          });
                                        }),
                                        child: Text(
                                          '%',
                                          style: TextStyle(
                                              fontSize: 26,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 32,
                              ),
                              child: Expanded(
                                child: Container(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 20.0,
                                      mainAxisSpacing: 20.0,
                                      crossAxisCount:
                                         3
                                    ),
                                    itemBuilder:
                                        (BuildContext , int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            stringResult = stringResult +
                                                numbersArray[index];
                                          });
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: isDark
                                                  ? Color.fromRGBO(5, 5, 5, 0.3)
                                                  : Color.fromRGBO(
                                                      255, 255, 255, 0.3),
                                            ),
                                            child: Center(
                                                child: Text(
                                              numbersArray[index],
                                              style: TextStyle(
                                                  fontSize: 26,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black),
                                            ))),
                                      );
                                    },
                                    itemCount: 12,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Container(
                            height: height * 0.5,
                            width:width * (1 / 4),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: isDark
                                      ? Color.fromRGBO(5, 5, 5, 0.3)
                                      : Color.fromRGBO(255, 255, 255, 0.3),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // ignore: avoid_unnecessary_containers
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (stringResult != '') {
                                              stringResult = stringResult + '/';
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: 30,
                                          child: Center(
                                            child: Text('/',
                                                style: TextStyle(
                                                    fontSize: 26,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black)),
                                          ),
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (stringResult != '') {
                                              stringResult = stringResult + '*';
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: 30,
                                          child: Center(
                                            child: Text(
                                              '*',
                                              style: TextStyle(
                                                  fontSize: 26,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            stringResult = stringResult + '-';
                                          });
                                        },
                                        child: Container(
                                          width: 30,
                                          child: Center(
                                            child: Text(
                                              '-',
                                              style: TextStyle(
                                                  fontSize: 26,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (stringResult != '') {
                                              stringResult = stringResult + '+';
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: 30,
                                          child: Center(
                                            child: Text(
                                              '+',
                                              style: TextStyle(
                                                  fontSize: 26,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          ),
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (stringResult != '') {
                                              previousString = stringResult;
                                              stringResult =
                                                  calculate(stringResult)
                                                      .toString();
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: 30,
                                          child: Center(
                                              child: Text(
                                            '=',
                                            style: TextStyle(
                                                fontSize: 26,
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black),
                                          )),
                                        )),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    )),
              )
            ]),
          ),
        ),
      )),
    );
  }
}

class numOper {
  double num1 = 0;
  double num2 = 0;
  String operation = '';
  double calculateOper() {
    switch (operation) {
      case '+':
        return num1 + num2;
      case '*':
        return num1 * num2;
      case '/':
        return num1 / num2;
      case '-':
        return num1 - num2;
      default:
        return 0;
    }
  }
}
