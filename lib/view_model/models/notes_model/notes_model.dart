class NotesModel {
  String title;
  String email;
  String description;
  int? id;
  int age;
  NotesModel(
      {required this.age,
      required this.description,
      required this.email,
      required this.title,
      this.id});
  NotesModel.jsonMap(Map<String, dynamic> res)
      : id = res["id"],
        description = res["description"],
        email = res["email"],
        title = res['title'],
        age = res["age"];
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "title": title,
      "email": email,
      "age": age
    };
  }
}
