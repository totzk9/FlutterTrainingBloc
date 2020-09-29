import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/bloc/task_bloc.dart';
import 'package:flutter_practice/data/dao/task_dao.dart';
import 'package:flutter_practice/data/model/task.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewTask extends StatefulWidget {
  NewTask({Key key}) : super(key: key);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  String _task;
  String imgUri;
  String _status = "Pending";

  List<String> spinnerItems = [
    'Dont notify',
    'after 5 minutes',
    'after 10 minutes'
  ];
  String dropdownValue = "Dont notify";

  PickedFile _file;
  final ImagePicker _imagePicker = ImagePicker();

  _openGallery(BuildContext context) async {
    try {
      final pickedFile =
          await _imagePicker.getImage(source: ImageSource.gallery);
      setState(() {
        _file = pickedFile;
      });
    } catch (e) {}
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    try {
      final pickedFile =
          await _imagePicker.getImage(source: ImageSource.camera);
      setState(() {
        _file = pickedFile;
      });
    } catch (e) {}
    Navigator.of(context).pop();
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Select from:"),
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    _openGallery(context);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    _openCamera(context);
                  },
                )
              ],
            )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create New Task"),
          actions: [
            FlatButton(
              child: Text(
                "Save",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                final task = Task(
                    id: null,
                    name: _task,
                    status: _status,
                    imageUrl: (_file != null) ? _file.path : null);
                insertTask(context, task);
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  _task = value;
                },
                maxLines: 5,
                maxLength: 255,
                maxLengthEnforced: false,
                autofocus: false,
                autocorrect: false,
                obscureText: false, //make it password view
                textCapitalization: TextCapitalization.sentences,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                    hintText: "Task Name details",
                    icon: Icon(Icons.text_format),
                    hintStyle: TextStyle(color: Colors.blue),
                    helperText: "* This is required",
                    helperStyle: TextStyle(color: Colors.red),
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _showDialog(context);
                    },
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        if (_file != null)
                          Image.file(
                            File(_file.path),
                            height: 120,
                            width: 120,
                          )
                        else
                          Image.asset(
                            'placeholder.png',
                            height: 120,
                            width: 120,
                          ),
                        Container(
                            width: 120,
                            color: Color(0x80424242),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Text(
                                (_file != null) ? "Add Image" : "Change Image",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Status:",
                          style: TextStyle(color: Colors.grey[700])),
                      Row(
                        children: [
                          Radio(
                            value: "Pending",
                            groupValue: _status,
                            onChanged: (String value) {
                              setState(() {
                                _status = value;
                              });
                            },
                          ),
                          Text("Pending")
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            value: "Done",
                            groupValue: _status,
                            onChanged: (String value) {
                              setState(() {
                                _status = value;
                              });
                            },
                          ),
                          Text("Done")
                        ],
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Notify me:"),
                  SizedBox(
                    width: 8,
                  ),
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                    ),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String data) {
                      setState(() {
                        dropdownValue = data;
                      });
                    },
                    items: spinnerItems
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  void close() {
    setState(() {
      Navigator.of(context).pop();
    });
  }

  void insertTask(BuildContext context, Task task) {
    final taskBloc = BlocProvider.of<TaskBloc>(context);
    taskBloc.add(InsertTaskEvent(task));
  }
}
