class GameProgressM {
  int? id;
  int userId;
  String gameName; 
  int isPlayed;
  int isWon;

  GameProgressM({ this.id, 
  required this.userId,
  required this.gameName,
  this.isPlayed = 0,
  this.isWon = 0,
    });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'game_name': gameName,
      'is_played': isPlayed,
      'is_won': isWon,
    };
  }

  static GameProgressM fromMap(Map<String, dynamic> map) {
    return GameProgressM(
      id: map['id'],
      userId: map['user_id'],
      gameName: map['game_name'],
      isPlayed: map['is_played'] ?? 0,
      isWon: map['is_won'] ?? 0,
    );
  }
}