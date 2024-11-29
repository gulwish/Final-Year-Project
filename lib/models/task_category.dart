class TaskCategory {
  final String name;
  final String thumbnail;
  final String id;

  TaskCategory(this.id, this.name, this.thumbnail);

  // static TaskCategory fromMap(Map<String, dynamic> map) {
  //   return TaskCategory(map['id'], map['name'], map['thumbnail']);
  // }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
    };
  }
}
