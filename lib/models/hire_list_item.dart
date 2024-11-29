import 'task_ad.dart';

class HireListItem {
  TaskAd? taskAd;
  double? duration;
  int? charges;

  HireListItem({this.taskAd, this.duration, this.charges});

  Map toMap(HireListItem hireListItem) {
    var data = <String, dynamic>{};
    data['task'] = hireListItem.taskAd!.toMap(hireListItem.taskAd!);
    data['duration'] = hireListItem.duration;
    data['charges'] = hireListItem.charges;
    return data;
  }

  HireListItem.fromMap(Map<String, dynamic> mapData) {
    taskAd = TaskAd.fromMap(mapData['task']);
    duration = mapData['duration'];
    charges = mapData['charges'];
  }
}
