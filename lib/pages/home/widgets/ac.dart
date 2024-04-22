import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iot_ui_challenge/utils/string_to_color.dart';

class MyWidget extends StatefulWidget {
  final String value;
  final String color;

  const MyWidget({Key? key, required this.value, required this.color})
      : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String? dropval;
  List<String> drplist = ["Start", "End"];
  String time = '00:00:00';
  bool showcontainer = false;
  late String _receivedValue;
  late String _receivedcolor;

  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _receivedValue = widget.value;
    _receivedcolor = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 252, 226, 225),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Container(
            color: Color.fromARGB(255, 252, 226, 225),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 252, 226, 225),
                    ),
                    height: height * 0.17,
                    width: width,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(),
                          child: Text(
                            '$_receivedValue',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    margin: EdgeInsets.only(right: 20, left: 15),
                    height: height * 0.75,
                    width: width,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Text(
                            'Power Consumption : 21',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                                color: Color.fromARGB(255, 11, 0, 0)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          width: 300.0,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(20),
                              color: _receivedcolor.toColor()),
                          child: DropdownButton(
                            itemHeight: 50.00,
                            hint: Text(
                              'Schedule',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            dropdownColor: _receivedcolor.toColor(),
                            iconSize: 40,
                            isExpanded: true,
                            value: dropval,
                            alignment: Alignment.center,
                            items: drplist.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                alignment: Alignment.center,
                              );
                            }).toList(),
                            onChanged: (newdrpval) {
                              setState(() {
                                dropval = newdrpval.toString();
                                if (dropval == 'Start' || dropval == 'End') {
                                  showcontainer = true;
                                } else {
                                  showcontainer = false;
                                }
                                updateTime(dropval!);
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: showcontainer,
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 30, bottom: 30, right: 50, left: 50),
                            margin: EdgeInsets.only(top: 50),
                            decoration: BoxDecoration(
                              color: _receivedcolor.toColor(),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '$time',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 25,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _selectTime(context);
                                  },
                                  child: Container(
                                    width: 170,
                                    child: TextField(
                                      controller: _timeController,
                                      decoration: InputDecoration(
                                        hintText: "00:00:00",
                                        hintStyle: TextStyle(
                                          fontSize: 20,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 40),
                                      ),
                                      keyboardType: TextInputType.datetime,
                                      enabled: false,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: TextButton(
                                    onPressed: () {
                                      _showToast();
                                    },
                                    child: Text(
                                      "Done",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding:
                                          EdgeInsets.only(right: 25, left: 25),
                                      alignment: Alignment(0, 0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void updateTime(String selectedValue) {
    setState(() {
      if (selectedValue == 'Start') {
        time = 'Start Time';
      } else if (selectedValue == 'End') {
        time = 'End Time';
      }
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null)
      setState(() {
        _timeController.text = picked.format(context);
      });
  }

  void _showToast() {
    Fluttertoast.showToast(
      msg: "Scheduled successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyWidget(value: 'My Widget', color: 'FF00FF'),
  ));
}
