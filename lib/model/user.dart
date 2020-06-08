class User {
  final int id;
  final String fullname;
  final String email;
  final String phone;
  final String password;
  final String role;
  final String level;

  User(
      {this.id,
      this.fullname,
      this.email,
      this.phone,
      this.password,
      this.role,
      this.level});
  User.withId(this.id, this.fullname, this.email, this.phone, this.password,
      this.role, this.level);

  ///convert a user to map format
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) map['id'] = id;
    map['fullname'] = fullname;
    map['email'] = email;
    map['username'] = phone;
    map['password'] = password;
    map['role'] = role;
    map['level'] = level;
    return map;
  } //toMap

  //extract a user form the map object
  User.fromMap(Map<String, dynamic> map, String id)
      : id = map['id'],
        fullname = map['fullname'],
        email = map['email'],
        phone = map['phone'],
        password = map['password'],
        role = map['role'],
        level = map['level'];
}
