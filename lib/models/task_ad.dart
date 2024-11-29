class TaskAd {
  String? taskId;
  String? title;
  double? baseRate;
  String? thumbnailURL;
  String? description;
  String? labourerId;
  String? serviceCategory;

  TaskAd({
    this.taskId,
    this.title,
    this.baseRate,
    this.thumbnailURL,
    this.description,
    this.labourerId,
    this.serviceCategory,
  });

  Map toMap(TaskAd task) {
    var data = <String, dynamic>{};
    data['task_id'] = task.taskId;
    data['task_thumbnail'] = task.thumbnailURL;
    data['task_title'] = task.title;
    data['base_price'] = task.baseRate;
    data['description'] = task.description;
    data['labourer_id'] = task.labourerId;
    data['category'] = task.serviceCategory;
    return data;
  }

  TaskAd.fromMap(Map<String, dynamic> mapData) {
    taskId = mapData['task_id'];
    thumbnailURL = mapData['task_thumbnail'];
    title = mapData['task_title'];
    baseRate = mapData['base_price'];
    description = mapData['description'];
    labourerId = mapData['labourer_id'];
    serviceCategory = mapData['category'];
  }
}
