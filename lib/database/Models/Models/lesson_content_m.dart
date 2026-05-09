class LessonContentM{

  int? contentId;
  int  lessonId;
  String  contentType;
  String? videoUrlAr; 
  String? videoUrlEn;
  String?  descriptionAr;
  String?  descriptionEn; 

  LessonContentM({this.contentId, required this.lessonId, required this.contentType,this.videoUrlAr, this.videoUrlEn, this.descriptionAr, this.descriptionEn});

  Map<String, dynamic> toMap(){
  return{
    'content_id': contentId,
    'lesson_id': lessonId,
    'content_type': contentType,
    'video_url_ar': videoUrlAr,
    'video_url_en': videoUrlEn,
    'description_ar': descriptionAr,
    'description_en'   : descriptionEn,
  };
}

static LessonContentM fromMap(Map<String, dynamic>map){
return LessonContentM(
  contentId: map['content_id'],
  lessonId: map['lesson_id'],
  contentType: map['content_type'],
  videoUrlAr: map['video_url_ar'],
  videoUrlEn: map['video_url_en'],
  descriptionAr: map['description_ar'],
  descriptionEn: map['description_en'],
);
}
}