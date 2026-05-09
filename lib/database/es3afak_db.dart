import 'package:esafak_app/database/Models/Models/emergency_call_m.dart';
import 'package:esafak_app/database/Models/Models/firstaid_lesson.dart';
import 'package:esafak_app/database/Models/Models/game_progress_m.dart';
import 'package:esafak_app/database/Models/Models/lesson_content_m.dart';
import 'package:esafak_app/database/Models/Models/progress_record_m.dart';
import 'package:esafak_app/database/Models/Models/user_model.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';



class Es3afakDb {

  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database> initialDb() async{
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'es3afak.db');
    Database mydb = await openDatabase(path, 
    version: 1, 
    onCreate: _onCreate,
     onOpen: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    },);
   
    return mydb;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE user(
    user_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    name           TEXT NOT NULL,
    email          TEXT,
    firebase_uid   TEXT,
    is_guest     INTEGER NOT NULL DEFAULT 0,
    created_at    TEXT  NOT NULL DEFAULT (datetime('now'))
    )
   ''');


     await db.execute('''
    CREATE TABLE first_aid_lesson(
    lesson_id  INTEGER PRIMARY KEY AUTOINCREMENT,
    title_ar   TEXT   NOT NULL,
    title_en   TEXT   NOT NULL
    )
    ''');
  
    await db.execute('''
    CREATE TABLE lesson_content(
    content_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    lesson_id        INTEGER  NOT NULL,
    content_type     TEXT  NOT NULL,
    video_url_ar     TEXT,   
    video_url_en    TEXT,
    description_ar      TEXT,
    description_en      TEXT,
    FOREIGN KEY (lesson_id) REFERENCES first_aid_lesson(lesson_id)
    )
    ''');

  await db.execute('''
    CREATE TABLE progress_record(
    progress_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id             INTEGER NOT NULL,
    lesson_id           INTEGER NOT NULL,
    completion_status   INTEGER NOT NULL DEFAULT 0,
    date_completed      TEXT,
    FOREIGN KEY (lesson_id) REFERENCES first_aid_lesson(lesson_id),
    FOREIGN KEY (user_id) REFERENCES user(user_id)
    UNIQUE(user_id, lesson_id)
    )
    '''); 

    await db.execute('''
    CREATE TABLE game_progress(
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id   INTEGER,
    game_name TEXT    NOT NULL,
    is_played INTEGER NOT NULL DEFAULT 0,
    is_won    INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
    UNIQUE(user_id, game_name)
  )
   ''');

  await db.execute('''
   CREATE TABLE emergency_call(
   call_id     INTEGER PRIMARY KEY AUTOINCREMENT,
   user_id     INTEGER NOT NULL,
   timestamp TEXT    NOT NULL DEFAULT (datetime('now')),
   FOREIGN KEY (user_id) REFERENCES user(user_id)
   )
   ''');  
   await _insertInitialData(db);
  }
  // user CRUD
  Future<int> insertUser(UserModel user) async {
    Database? mydb = await db;
    user.isGuest = 0;
    int userId = await mydb!.insert('user', user.toMap()); 
    await _insertGameProgressForUser(userId, mydb);        
    return userId;                                        
  }

  Future<int> insertGuest() async {
   Database? mydb = await db;
   UserModel guest = UserModel(
    name: 'زائر',
    isGuest: 1,
   );
   int userId = await mydb!.insert('user', guest.toMap()); 
  await _insertGameProgressForUser(userId, mydb);         
  return userId;  
  }

  Future<UserModel?> getUser(String firebaseUid) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> result = await mydb!.query(
     'user',
      where: 'firebase_uid = ?',
      whereArgs: [firebaseUid],
     limit:     1,
    );
    return result.isNotEmpty ? UserModel.fromMap(result.first) : null;
  }
   
  Future<int> updateUser(UserModel user) async {
    Database? mydb = await db;
     return await mydb!.update(

      'user',
      user.toMap(),
      where:     'user_id = ?',
      whereArgs: [user.userId],
    );
  }

  Future<int> deleteUser(int userId) async {
    Database? mydb = await db;
     return await mydb!.delete(
       'user',
       where:     'user_id = ?',
       whereArgs: [userId],
      );
  }
  // END user CRUD 
  
  //FirstAidLesson CRUD
  Future<int> insertLesson(FirstAidLesson lesson) async{
    Database? mydb = await db;
    return await mydb!.insert('first_aid_lesson', lesson.toMap(),);
  }

  Future<List<FirstAidLesson>> getAllLesson() async{
    Database? mydb = await db;
    List<Map<String, dynamic>> result = await mydb!.query('first_aid_lesson');
    return result.map((map) => FirstAidLesson.fromMap(map)).toList();
  }
  Future<List<FirstAidLesson>> searchLessons(String keyword) async{
    Database? mydb = await db;
    List<Map<String, dynamic>> result = await mydb!.query(
      'first_aid_lesson',
      where: 'title_ar LIKE ? OR title_en LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],);
      return result.map((map) => FirstAidLesson.fromMap(map)).toList();
  }
  // end first aid lesson
  Future<List<Map<String, dynamic>>> getAllLessonsWithFullDetails() async {
    Database? mydb = await db; 
    
    // هذا الاستعلام يربط جدول الدروس (f) بجدول المحتوى (c)
    // لكي لا نحتاج لعمل استدعاءين منفصلين
    return await mydb!.rawQuery('''
      SELECT 
        f.lesson_id, 
        f.title_ar, 
        f.title_en, 
        c.description_ar, 
        c.description_en, 
        c.video_url_ar, 
        c.video_url_en
      FROM first_aid_lesson f
      LEFT JOIN lesson_content c ON f.lesson_id = c.lesson_id
    ''');
  }
  // lesson_content CRUD
  Future<int> insertLessonContentM(LessonContentM lesson) async{
    Database? mydb = await db;
    return await mydb!.insert('lesson_content', lesson.toMap(),);
   }
  Future<List<LessonContentM>> getContentByLesson(int lessonId) async{
    Database? mydb = await db;
    List<Map<String, dynamic>> result = await mydb!.query(
      'lesson_content',
       where:     'lesson_id = ?',
       whereArgs: [lessonId],
    );
    return result.map((map) => LessonContentM.fromMap(map)).toList();
  }
  //End LessonContentM
  //start progressrecord crud

  Future<int> insertProgressRecordM (ProgressRecordM  progress) async{
    Database? mydb = await db;
    return await mydb!.insert(
      'progress_record', 
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ProgressRecordM>>getProgressByUser(int userId) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> result = await mydb!.query(
     'progress_record',
      where: 'user_id = ?',
      whereArgs: [userId]
    );
    return result.map((e) => ProgressRecordM.fromMap(e)).toList();
  }
  Future<int> updateProgress(ProgressRecordM progress) async {
     Database? mydb = await db;
      return await mydb!.update(
      'progress_record', 
      progress.toMap(),   
      where: 'progress_id = ?', 
      whereArgs: [progress.progressId], 
    );
  }
  Future<bool> isLessonCompleted(int userId, int lessonId) async {
    Database? mydb = await db;

    final result = await mydb!.query(
      'progress_record',
      where: 'user_id = ? AND lesson_id = ? AND completion_status = 1',
      whereArgs: [userId, lessonId],
    );

    return result.isNotEmpty;
  }
  //end progress
  // game progress
  Future<int> insertGameProgress(GameProgressM progress) async {
  Database? mydb = await db;
  return await mydb!.insert(
    'game_progress',
    progress.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
Future<List<GameProgressM>> getGameProgressByUser(int userId) async {
  Database? mydb = await db;
  List<Map<String, dynamic>> result = await mydb!.query(
    'game_progress',
    where:     'user_id = ?',
    whereArgs: [userId],
  );
  return result.map((e) => GameProgressM.fromMap(e)).toList();
}
Future<int> updateGameResult({
    required int userId,
    required String gameName,
    required bool isWon,
  }) async {
    Database? mydb = await db;

    return await mydb!.update(
      'game_progress',
      {
        'is_played': 1,
        'is_won': isWon ? 1 : 0,
      },
      where: 'user_id = ? AND game_name = ?',
      whereArgs: [userId, gameName],
    );
  }
// end game progress
//emergency
Future<int> insertEmergencyCall(EmergencyCallM call) async {
  Database? mydb = await db;
  return await mydb!.insert('emergency_call', call.toMap(),);
}
// END 

Future _insertInitialData(Database db) async {

  await db.insert('first_aid_lesson', {'title_ar': 'الكسور',              'title_en': 'Fracture'});
  await db.insert('first_aid_lesson', {'title_ar': 'الرعاف',              'title_en': 'Nosebleed'});
  await db.insert('first_aid_lesson', {'title_ar': 'نوبة انخفاض السكر',   'title_en': 'Low Blood Sugar'});
  await db.insert('first_aid_lesson', {'title_ar': 'ضربة شمس',            'title_en': 'Heat Stroke'});
  await db.insert('first_aid_lesson', {'title_ar': 'اختناق',                 'title_en': 'Choking'});
  await db.insert('first_aid_lesson', {'title_ar': 'إنعاش قلبي',                 'title_en': 'CPR'});
  await db.insert('first_aid_lesson', {'title_ar': 'حرق',                 'title_en': 'Burn'});
  await db.insert('first_aid_lesson', {'title_ar': 'جرح',                 'title_en': 'Wound'});


  // المحتوى

  // درس الكسور (lesson_id: 1)
await db.insert('lesson_content', {
  'lesson_id': 1,
  'content_type': 'video',
  'video_url_ar': 'assets/video/FractureAR.mp4',
  'video_url_en': 'assets/video/FractureEN.mp4',
  'description_ar': '• لا تحرك الطرف المصاب.\n'
                    '• استخدم جبيرة لتثبيت الكسر.\n'
                    '• ضع كمادات باردة لتقليل التورم.\n'
                    '• اطلب الإسعاف فوراً.',
  'description_en': '• Do not move the injured limb.\n'
                    '• Use a splint to stabilize the fracture.\n'
                    '• Apply cold packs to reduce swelling.\n'
                    '• Call for help immediately.',
});
 // درس 2: الرعاف
  await db.insert('lesson_content', {
    'lesson_id': 2,
    'content_type': 'video',
    'video_url_ar': 'assets/video/nosebleedAR.mp4',
    'video_url_en': 'assets/video/nosebleedEN.mp4',
    
    //  إضافة الوصف العربي هنا
    'description_ar': '١. اجلس بشكل مستقيم وانحنِ للأمام قليلاً.\n'
                      '٢. اضغط على الجزء اللين من الأنف بإحكام لمدة ١٠ دقائق.\n'
                      '٣. تجنب الاستلقاء أو إمالة الرأس للخلف لمنع بلع الدم.',
                      
    //  إضافة الوصف الإنجليزي هنا
    'description_en': '1. Sit upright and lean forward slightly.\n'
                      '2. Pinch the soft part of your nose firmly for 10 minutes.\n'
                      '3. Avoid lying down or tilting your head back to prevent swallowing blood.',
  });
 // مثال لدرس نوبة السكر (lesson_id: 3)
await db.insert('lesson_content', {
  'lesson_id': 3,
  'content_type': 'video',
  'video_url_ar': 'assets/video/Low_blood_sugarAR.mp4',
  'video_url_en': 'assets/video/Low_blood_sugarEN.mp4',
  'description_ar': '١. أعطِ المصاب ١٥ جرام سكر (نصف كوب عصير).\n'
                    '٢. انتظر ١٥ دقيقة وقس مستوى السكر.\n'
                    '٣. إذا قل السكر عن ٧٠، كرر الخطوات.',
  'description_en': '1. Give 15g of sugar (half a cup of juice).\n'
                    '2. Wait 15 minutes and check blood sugar.\n'
                    '3. If sugar is below 70, repeat the steps.',
});
 
 // درس ضربة الشمس (lesson_id: 4)
await db.insert('lesson_content', {
  'lesson_id': 4,
  'content_type': 'video',
  'video_url_ar': 'assets/video/Heat_strokeAR.mp4',
  'video_url_en': 'assets/video/Heat_strokeEN.mp4',
  'description_ar': '• انقل المصاب لمكان بارد وجيد التهوية.\n'
                    '• برد الجسم بمناشف مبللة بماء بارد.\n'
                    '• اتصل بالإسعاف (٩٩٧) في حال عدم الاستجابة.',
  'description_en': '• Move the victim to a cool, airy place.\n'
                    '• Cool the body with wet, cool towels.\n'
                    '• Call 997 if there is no response.',
});
 
  // درس الاختناق
await db.insert('lesson_content', {
      'lesson_id': 5,
      'content_type': 'video',
      'video_url_ar': 'assets/video/chokingAR.mp4',
      'video_url_en': 'assets/video/chokingEN.mp4',
      'description_ar': '• استخدم مناورة هيمليك.\n• اضغط بقوة فوق السرة للداخل ولأعلى.\n• كرر حتى يخرج الجسم الغريب.',
      'description_en': '• Use the Heimlich Maneuver.\n• Press inward and upward above navel.\n• Repeat until the object is expelled.'
    });
  
  //درس انعاش القلبي
await db.insert('lesson_content', {
  'lesson_id': 6,
  'content_type': 'video',
  'video_url_ar': 'assets/video/CPRAR.mp4',
  'video_url_en': 'assets/video/CPREN.mp4',
  'description_ar': '• اتصل بالطوارئ (٩٩٧) فوراً.\n'
                    '• ضع يديك في منتصف الصدر.\n'
                    '• اضغط بقوة وسرعة (١٠٠-١٢٠ ضغطة/دقيقة).',
  'description_en': '• Call emergency (997) immediately.\n'
                    '• Place hands in the center of the chest.\n'
                    '• Push hard and fast (100-120 bpm).',
});
   //حرق
 await db.insert('lesson_content', {
  'lesson_id': 7,
  'content_type': 'video',
  'video_url_ar': 'assets/video/burnAR.mp4',
  'video_url_en': 'assets/video/burnEN.mp4',
  'description_ar': '• برد الحرق بالماء الجاري لمدة ٢٠ دقيقة.\n'
                    '• غطِ الحرق بغلاف بلاستيكي نظيف.\n'
                    '• لا تضع المعجون أو الثلج مباشرة.',
  'description_en': '• Cool the burn under running water for 20 min.\n'
                    '• Cover with clean cling film.\n'
                    '• Do not apply toothpaste or ice directly.',
});
   //جرح
await db.insert('lesson_content', {
  'lesson_id': 8,
  'content_type': 'video',
  'video_url_ar': 'assets/video/woundAR.mp4',
  'video_url_en': 'assets/video/woundEN.mp4',
  'description_ar': '• اغسل يديك والجرح بالماء والصابون.\n'
                    '• طهر الجرح واستخدم ضمادة معقمة.\n'
                    '• راقب الجرح واستشر الطبيب في حال الالتهاب.',
  'description_en': '• Wash hands and the wound with soap and water.\n'
                    '• Disinfect the wound and use a sterile bandage.\n'
                    '• Monitor the wound and consult a doctor if inflamed.',
});
 
 }
  Future _insertGameProgressForUser(int userId, Database mydb) async {
    await mydb.insert('game_progress', {'user_id': userId, 'game_name': 'Quick Quiz',          'is_played': 0, 'is_won': 0});
    await mydb.insert('game_progress', {'user_id': userId, 'game_name': 'Memory Match',         'is_played': 0, 'is_won': 0});
    await mydb.insert('game_progress', {'user_id': userId, 'game_name': 'First Aid Puzzle',     'is_played': 0, 'is_won': 0});
    await mydb.insert('game_progress', {'user_id': userId, 'game_name': 'Emergency Scenarios',  'is_played': 0, 'is_won': 0});
  }
  
  


  Future<String?> getVideoPath(int lessonId) async {
  // 1. الوصول لنسخة قاعدة البيانات الصحيحة
  final dbClient = await db; 

  // 2. الاستعلام من جدول المحتوى باستخدام الـ ID (أدق من العنوان)
  List<Map<String, dynamic>> maps = await dbClient!.query(
    'lesson_content', 
    columns: ['video_url_ar'], // اختاري العمود العربي
    where: 'lesson_id = ?',
    whereArgs: [lessonId],
  );

  // 3. التأكد من وجود نتيجة وإرجاع المسار
  if (maps.isNotEmpty) {
    return maps.first['video_url_ar'] as String?;
  }
  return null;
 }
 Future<double> getLessonsProgressRatio(int userId) async {
  Database? mydb = await db;
  final result = await mydb!.rawQuery(
    'SELECT COUNT(*) as count FROM progress_record WHERE user_id = ? AND completion_status = 1',
    [userId]
  );
  int completedCount = Sqflite.firstIntValue(result) ?? 0;
  return completedCount / 8.0; 
}

Future<double> getGameProgressRatio(int userId, String gameName) async {
  Database? mydb = await db;
  final result = await mydb!.query('game_progress', where: 'user_id = ? AND game_name = ?', whereArgs: [userId, gameName]);
  if (result.isNotEmpty) {
    if (result.first['is_won'] == 1) return 1.0;
    if (result.first['is_played'] == 1) return 0.5;
  }
  return 0.0;
}


Future<Map<String, dynamic>?> getLessonByName(String lessonName) async {
  Database? mydb = await db; 
  final List<Map<String, dynamic>> maps = await mydb!.rawQuery('''
    SELECT 
      l.lesson_id as id, 
      l.title_ar, 
      l.title_en, 
      c.description_en as descriptionEn, 
      c.description_ar as descriptionAr, 
      c.video_url_en as videoUrlEn, 
      c.video_url_ar as videoUrlAr
    FROM first_aid_lesson l
    JOIN lesson_content c ON l.lesson_id = c.lesson_id
    WHERE l.title_ar = ? OR l.title_en = ? OR l.title_ar LIKE ? OR l.title_en LIKE ?
    LIMIT 1
  ''', [lessonName, lessonName, '%$lessonName%', '%$lessonName%']);

  if (maps.isNotEmpty) {
    return maps.first;
  }
  return null;
}
} 