class EmergencyCallM{

  int?    callId;
  int     userId;
  String? timestamp;
 
  EmergencyCallM({this.callId, required this.userId, this.timestamp,});

Map<String, dynamic> toMap() {
    return {
     'call_id': callId,
     'user_id': userId,
     'timestamp': timestamp,
     };
  }

  static EmergencyCallM fromMap(Map<String, dynamic>map){
    return EmergencyCallM(
     callId: map['call_id'],
     userId: map['user_id'],
     timestamp: map['timestamp'],
    );
  }

}