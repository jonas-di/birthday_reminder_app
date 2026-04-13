class Friend {
  int id;

  String firstName;
  String? lastName;
  DateTime birthday;

  //constructor
  Friend({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthday,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthYear': birthday.year,
      'birthMonth': birthday.month,
      'birthDay': birthday.day,
    };
  }
}
