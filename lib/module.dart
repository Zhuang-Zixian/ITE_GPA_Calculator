
class Module {
  String title;
  int creditUnits;
  String grade;

  Module(this.title, this.creditUnits, this.grade);

  Module.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        creditUnits = json['creditUnits'],
        grade = json['grade'];

  Map<String, dynamic> toJson() => {
    'title' : title,
    'creditUnits' : creditUnits,
    'grade' : grade
  };
}




