import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../objects/Task.dart';
import '../objects/ScheduleTime.dart';
import '../objects/Calendar.dart';

String awsUrl = "https://bttmns45mb.execute-api.us-west-2.amazonaws.com";
String knnUrl = "https://checkmate-data-backend.herokuapp.com/api";
String devUrl = "localhost:5000/api";
String userId = "1";

String authorizationHeader =
    "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlFqRTJNemN5TWpKRE1ERTFSRVE0UXpRME1UQkJOVVpDUlRreU1ESXhSVVpFTnpFd09EVTFOdyJ9.eyJpc3MiOiJodHRwczovL2xlYXJuaW5nY2FsZW5kYXItZGV2ZWxvcG1lbnQuYXV0aDAuY29tLyIsInN1YiI6Imdvb2dsZS1vYXV0aDJ8MTExMDEzNzc2NjY0NjI2MjA1OTY2IiwiYXVkIjpbImh0dHBzOi8vYnR0bW5zNDVtYi5leGVjdXRlLWFwaS51cy13ZXN0LTIuYW1hem9uYXdzLmNvbS9kZXZlbG9wbWVudCIsImh0dHBzOi8vbGVhcm5pbmdjYWxlbmRhci1kZXZlbG9wbWVudC5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNTgzOTA3OTk3LCJleHAiOjE1ODM5OTQzOTcsImF6cCI6Ik5Ib1VBUnY3S0tkTzJWY0N1ZDNPV3pwdlo1MmIxNm04Iiwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSBvZmZsaW5lX2FjY2VzcyJ9.jvrWHjAQLrxyhv2EtZ6Lm9Bj-jXj1ZRUU-Jbd1ZruP2SawnHsGPWxKJnL19bK6zds_0Fxy5MgZPfIVVwTtIDUa_ZIzrPhOSAC5v0O30IekJ0aKJxG-nnAkEFiAlHAZozK4LJDLLIgNSvRd2ZucPwqUhi42-xayt7FnJphA772MVEy06rNzBbZJ39rvw1OBVSvKKpu1hb2VHboWQ-xdBpeEBHosl0dlxcHpi6BEAEZZnH-ooAwucqS2qgdSszdB3G_qMy4MQarCzjQV-KxvJVYpEfsrxe6Bpjtr46P76qDM8mqF4NPvjKP0fUdn8DIhQLpBoLUq_QYBwHX0v_Sw9jFA";

Map<String, String> requestHeaders = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
  'Authorization': authorizationHeader
};

Future<Map<String, List<ScheduleTime>>> getRecommendedTimes(
    String taskType, int taskTime) async {
  print(knnUrl +
      '/1/times/recommended?task_type=' +
      taskType +
      '&task_length=' +
      taskTime.toString());

  final response = await http.get(
      knnUrl +
          '/1/times/recommended?task_type=' +
          taskType +
          '&task_length=' +
          taskTime.toString(),
      headers: requestHeaders);

  if (response.statusCode == 200) {
    Map<String, List<ScheduleTime>> returnMap =
        new Map<String, List<ScheduleTime>>();
    json.decode(response.body).forEach((item, value) {
      returnMap[item] =
          value.map<ScheduleTime>((obj) => ScheduleTime.fromJson(obj)).toList();
    });
    return returnMap;
  } else {
    print(response);
    print(response.statusCode);
    throw Exception("You done fucked up you dumb ho");
  }
}

Future<List<ScheduleTime>> getAnnotatedTimes(String taskType) async {
  final response = await http.get(knnUrl + '/1/times?task_type=' + taskType,
      headers: requestHeaders);

  if (response.statusCode == 200) {
    return json
        .decode(response.body)
        .map<ScheduleTime>((time) => ScheduleTime.fromJson(time))
        .toList();
  } else {
    throw Exception("You done fucked up you dumb ho");
  }
}

Future<List<Task>> getPast() async {
  final response = await http.get(
      awsUrl + '/development/task/past?completed=-1',
      headers: requestHeaders);

  if (response.statusCode == 200) {
    return json
        .decode(response.body)['data']
        .map<Task>((task) => Task.fromJson(task))
        .toList();
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to get past task');
  }
}

Future<List<Task>> getScheduled() async {
  final response = await http.get(
      awsUrl + '/development/task/future?completed=-1',
      headers: requestHeaders);

  if (response.statusCode == 200) {
    return json
        .decode(response.body)['data']
        .map<Task>((task) => Task.fromJson(task))
        .toList();
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to get scheduled task');
  }
}

Future<List<Task>> getUnscheduled() async {
  final response = await http.get(
      awsUrl + '/development/task/unscheduled?completed=-1',
      headers: requestHeaders);

  if (response.statusCode == 200) {
    print("UNSCHEDULED");
    print(json
        .decode(response.body)['data']
        .map<Task>((task) => Task.fromJson(task))
        .toList());
    return json
        .decode(response.body)['data']
        .map<Task>((task) => Task.fromJson(task))
        .toList();
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to get unscheduled task');
  }
}

//Get Time from one location to another location
Future<String> getDuration(String origin, String destination) async {
  //origin format ex: 33.640495, -117.844296
  //destination format ex: 34.052235, -118.243683 

  String url = 'https://maps.googleapis.com/maps/api/distancematrix/json?' 
      + "origins=" + "33.640495, -117.844296"
      + "&destinations=" + destination
      + "&key=AIzaSyAKlXJEHJl_LWnCoAZ6yzVZ4_ClomAS6QY";
  print(url);
  final response =
      await http.post(url);

  if (response.statusCode == 200) {
    //Grab the time
    Map<String, dynamic> destinationMatrix = json.decode(response.body);
    print(destinationMatrix);
    String time = destinationMatrix['rows'][0]['elements'][0]['duration']['text'];
    print(time);
    return time;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to get Time');
  }

}

void putCompleted(String taskId, int completed, Function getTasks) async {
  String jsonObject = '{"task_id": "' +
      taskId +
      '", "completed": "' +
      completed.toString() +
      '"}';

  final response = await http.put(
      'https://bttmns45mb.execute-api.us-west-2.amazonaws.com/development/task/completed',
      headers: requestHeaders,
      body: jsonObject);

  if (response.statusCode == 200) {
    putCompletedKNN(Task.fromJson(json.decode(response.body)['data']));
    getTasks();
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to update completion');
  }
}

void postTask(Task task, bool isTimeSelected) async {
  String jsonObject = json.encode(task.toJson(true, isTimeSelected));

  print(awsUrl + '/development/task');
  print(jsonObject);

  final response = await http.post(awsUrl + '/development/task',
      headers: requestHeaders, body: jsonObject);

  if (response.statusCode == 200) {
    print("Successfully posted task");
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to post task');
  }
}

void putTaskPriority(Task task) async {
  String jsonObject = '{"task_id": "' +
      task.id +
      '", "priority": "' +
      task.priority.toString() +
      '"}';

  final response = await http.put(awsUrl + '/development/task/priority',
      headers: requestHeaders, body: jsonObject);

  if (response.statusCode == 200) {
    print("Successfully updated task priority");
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to update task priority');
  }
}

void putTaskTime(Task task) async {
  String jsonObject = '{"task_id": "' +
      task.id +
      '", "start_time": "' +
      task.startTime.toIso8601String() +
      '", "task_time": ' +
      task.taskTime.toString() +
      '}';

  final response = await http.put(awsUrl + '/development/task/time',
      headers: requestHeaders, body: jsonObject);

  if (response.statusCode == 200) {
    print("Successfully updated task time");
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to update task time');
  }
}

void putCompletedKNN(Task completedTask) async {
  Map<String, String> queryParams = {
    "task_type": completedTask.taskType,
    "day_of_week": getDayOfWeek(completedTask.startTime.weekday - 1),
    "time_of_day": 1.toString(),
    "completed": completedTask.completed.toString(),
  };

  String queryString = "?task_type=" +
      queryParams["task_type"] +
      "&day_of_week=" +
      queryParams["day_of_week"] +
      "&time_of_day=" +
      queryParams["time_of_day"] +
      "&completed=" +
      queryParams["completed"];

  final response =
      await http.post(knnUrl + "/" + userId + "/task" + queryString);

  if (response.statusCode == 200) {
    print("Successfully added to KNN");
  } else {
    throw Exception("Failed to add to KNN");
  }
}

Future<List<Calendar>> getCalendar() async {
  final response =
      await http.get(awsUrl + '/development/calendar', headers: requestHeaders);

  if (response.statusCode == 200) {
    return json.decode(response.body)['data'].map<Calendar>((calendar) => Calendar.fromJson(calendar)).toList();
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to get unscheduled task');
  }
}

 void putCalendar(String calendarId, bool selected) async {

    String jsonObject = '{"id": "' +
      calendarId +
      '", "selected": "' +
      selected.toString() +
      '"}';

  final response =
      await http.put(awsUrl + '/development/settings/calendar', headers: requestHeaders, body: jsonObject);

  if (response.statusCode == 200) {
    print("Successfully updated calendar");
    // return json.decode(response.body)['data'].map<Calendar>((calendar) => Calendar.fromJson(calendar)).toList();
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to put the calendar');
  }
}


String getDayOfWeek(int weekday) {
  if (weekday == 0) {
    return "monday";
  } else if (weekday == 1) {
    return "tuesday";
  } else if (weekday == 2) {
    return "wednesday";
  } else if (weekday == 3) {
    return "thursday";
  } else if (weekday == 4) {
    return "friday";
  } else if (weekday == 5) {
    return "saturday";
  } else if (weekday == 6) {
    return "sunday";
  }
}
