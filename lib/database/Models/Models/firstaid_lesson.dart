class FirstAidLesson{
  int? lessonId;
  String  titleAr;
  String  titleEn;
  int  isOfflineAvailable;


  FirstAidLesson({this.lessonId, required this.titleAr, required this.titleEn, this.isOfflineAvailable =1,});

  Map<String, dynamic> toMap(){
  return{
   'lesson_id': lessonId,
    'title_ar': titleAr,
    'title_en': titleEn,
    'is_offline_available': isOfflineAvailable,
  };
  }

  static FirstAidLesson fromMap(Map<String, dynamic>map){
  return FirstAidLesson(
  lessonId: map['lesson_id'],
  titleAr: map['title_ar'],
  titleEn: map['title_en'],
  isOfflineAvailable: map['is_offline_available'],

  );
  }

}