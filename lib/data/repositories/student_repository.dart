import 'package:uuid/uuid.dart';
import '../models/student.dart';
import '../database/app_database.dart';

class StudentRepository {
  final AppDatabase _db;

  StudentRepository({AppDatabase? db}) : _db = db ?? AppDatabase();

  Student? getCurrentStudent() {
    return _db.getStudent();
  }

  Future<Student> createStudent({
    required String name,
    required String grade,
    required int age,
    required String avatar,
    String language = 'en',
  }) async {
    final student = Student(
      id: const Uuid().v4(),
      name: name.trim(),
      grade: grade,
      age: age,
      avatar: avatar,
      language: language,
      xp: 0,
      streak: 1,
      level: 1,
    );
    await _db.saveStudent(student);
    return student;
  }

  Future<Student> addXp(int xpEarned) async {
    final current = getCurrentStudent();
    if (current == null) throw Exception('No active student profile');

    final newXp = current.xp + xpEarned;
    // Level formula: 100 XP per level
    final newLevel = (newXp / 100).floor() + 1;

    final updated = current.copyWith(
      xp: newXp,
      level: newLevel,
    );
    await _db.saveStudent(updated);
    return updated;
  }

  Future<Student> updateStudent(Student updated) async {
    await _db.saveStudent(updated);
    return updated;
  }
}
