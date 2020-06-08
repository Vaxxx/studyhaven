class Course {
  final int id;
  final String title;
  final String level;

  Course({this.id, this.title, this.level});

  Course.withId(this.id, this.title, this.level);

  ///convert a user to map format
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['id'] = id;
    map['title'] = title;
    map['level'] = level;
    return map;
  } //toMap

  //extract a user form the map object
//  Course.fromMap(Map<String, dynamic> map)
//      : id = map['id'],
//        title = map['title'],
//        level = map['level'];

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      level: json['level'],
    );
  }
}
