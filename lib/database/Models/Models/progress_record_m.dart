class ProgressRecordM{

  int? progressId;
  int  userId;
  int  lessonId;
  int  completionStatus;
  String?  dateCompleted;

  ProgressRecordM({this.progressId, required this.userId, required this.lessonId, this.completionStatus = 0, this.dateCompleted,});

 Map<String, dynamic> toMap() {
    return {
      'progress_id': progressId,
      'user_id': userId,
      'lesson_id': lessonId,
      'completion_status': completionStatus,
      'date_completed': dateCompleted,
    };
  }

  static ProgressRecordM fromMap(Map<String, dynamic>map){
    return ProgressRecordM(
     progressId: map['progress_id'],
     userId: map['user_id'],
     lessonId: map['lesson_id'],
     completionStatus: map['completion_status'],
     dateCompleted: map['date_completed'],
    );
  }
}