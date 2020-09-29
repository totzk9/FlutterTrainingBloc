import 'package:flutter/material.dart';
import 'package:flutter_practice/data/data_pref.dart';
import 'package:flutter_practice/data/db/task_database.dart';
import 'package:flutter_practice/data/model/task.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class TaskDetail extends StatefulWidget {
  final Task task;

  TaskDetail(this.task);
  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  String _task;
  String imgUri;
  String _status;
  DateTime time;
  final ImagePicker _imagePicker = ImagePicker();

  // Future<Task> getData() async {
  //   Task task = Future.value(Provider.of<AppDatabase>(context, listen: false)
  //       .taskDao
  //       .getCurrentTask(DataPreferences().getIntData("currentTask")));
  // }

  Future taskFuture;
  Task task;

  @override
  void initState() {
    super.initState();
    task = widget.task;
    // _task = taskInfo.name;
    // imgUri = taskInfo.imageUrl;
    // _status = taskInfo.status;
    // time = taskInfo.dateAdded;
  }

  FutureBuilder _futureBuilder() {
    return FutureBuilder(
        future: taskFuture,
        builder: (context, snapshot) {
          Task task = snapshot.data;
          return _buildTaskDetail(task);
        });
  }

  // StreamBuilder<Task> _buildTaskDetail(BuildContext context) {
  //   final database = Provider.of<AppDatabase>(context);
  //   return StreamBuilder(
  //       stream: database
  //           .getCurrentTask(DataPreferences().getIntData("currentTask")),
  //       builder: (context, AsyncSnapshot<Task> snapshot) {
  //         final task =
  //             snapshot.data ?? new Task(id: null, name: null, status: null);
  //         // _task = task.name;
  //         // imgUri = task.imageUrl;
  //         // _status = task.status;
  //         // time = task.dateAdded;
  Widget _buildTaskDetail(Task task) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: TextEditingController(text: task.name),
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
                    (imgUri != null)
                        ? Image.file(
                            File(task.imageUrl),
                            height: 120,
                            width: 120,
                          )
                        : Image.asset(
                            'placeholder.png',
                            height: 120,
                            width: 120,
                          ),
                    Container(
                        width: 120,
                        color: Color(0x80424242),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Text(
                            (imgUri != null) ? "Add Image" : "Change Image",
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
                  Text("Status:", style: TextStyle(color: Colors.grey[700])),
                  Row(
                    children: [
                      Radio(
                        value: "Pending",
                        groupValue: task.status,
                        onChanged: (String value) {
                          setState(() {
                            print(_status);
                            _status = value;
                            print(_status);
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
                        groupValue: task.status,
                        onChanged: (String value) {
                          setState(() {
                            print(_status);
                            _status = value;
                            print(_status);
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
        ],
      ),
    );
    // });
  }

  _openGallery(BuildContext context) async {
    try {
      final pickedFile =
          await _imagePicker.getImage(source: ImageSource.gallery);
      setState(() {
        imgUri = pickedFile.path;
      });
    } catch (e) {}
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    try {
      final pickedFile =
          await _imagePicker.getImage(source: ImageSource.camera);
      setState(() {
        imgUri = pickedFile.path;
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
          title: Text("_currentTask.name"),
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
                final database =
                    Provider.of<AppDatabase>(context, listen: false).taskDao;
                final task = Task(
                    id: DataPreferences().getIntData("currentTask"),
                    name: _task,
                    status: _status,
                    imageUrl: imgUri ?? null);
                database.updateTask(task);
                close();
              },
            )
          ],
        ),
        body: _futureBuilder());
  }

  void close() {
    setState(() {
      Navigator.of(context).pop();
    });
  }
}
