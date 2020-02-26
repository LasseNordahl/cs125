import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../forms/taskDescriptionForm.dart';
import '../objects/Task.dart';

class TaskDescription extends StatefulWidget {
  final Task selectedTask;

  TaskDescription({Key key, this.selectedTask});

  @override
  createState() => new TaskDescriptionState();
}

class TaskDescriptionState extends State<TaskDescription> {
  @override
  Widget build(BuildContext context) {
    return new Hero(
      tag: widget.selectedTask.id.toString(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.white, Colors.white])),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: 64.0,
                  left: 32.0,
                  right: 32.0,
                  bottom: 24.0,
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Task Description",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: 26,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 32.0,
                  right: 32.0,
                  bottom: 32.0,
                ),
                child: new TaskDescriptionForm(
                  selectedTask: widget.selectedTask,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}