import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

void main() async {
  final studentService = StudentService(StudentRepository());

  // Fetch all students
  List<Student> students = await studentService.getAllStudents();

  // Print students
  for (var student in students) {
    print(student);


  await studentService.deleteStudent("");
  }
}

class StudentRepository {
  static const String _baseUrl =
      'https://fb-testing-db-default-rtdb.asia-southeast1.firebasedatabase.app';
  static const String _students = "students";
  static const String _allStudents = '$_baseUrl/$_students.json';

  /// Fetch all students
  Future<List<Student>> getAllStudents() async {
    Uri uri = Uri.parse(_allStudents);
    final response = await http.get(uri);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to load students');
    }

    final data = json.decode(response.body) as Map<String, dynamic>?;

    if (data == null) return [];

    return data.entries
        .map((entry) => StudentDto.fromJson(entry.key, entry.value))
        .toList();
  }

  // Add a new data

  Future<void> addStudent(Student student) async {
    Uri uri = Uri.parse(_allStudents);
    final response = await http.post(
      uri,
      body: json.encode(StudentDto.toJson(student)),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != HttpStatus.ok &&
        response.statusCode != HttpStatus.created) {
      throw Exception('Failed to add student');
    }
  }

  // Update a student
  Future<void> updateStudent(String id, Student student) async {
    Uri uri = Uri.parse('$_baseUrl/$_students/$id.json');
    final response = await http.patch(
      uri,
      body: json.encode(StudentDto.toJson(student)),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to update student');
    }
  }

  // Delete a student
  Future<void> deleteStudent(String id) async {
    Uri uri = Uri.parse('$_baseUrl/$_students/$id.json');
    final response = await http.delete(uri);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to delete student');
    }
  }
}

class StudentService {
  final StudentRepository _repository;

  StudentService(this._repository);

  Future<List<Student>> getAllStudents() {
    return _repository.getAllStudents();
  }

  Future<void> addStudent(Student student) {
    return _repository.addStudent(student);
  }

  Future<void> updateStudent(String id, Student student) {
    return _repository.updateStudent(id, student);
  }

  Future<void> deleteStudent(String id) {
    return _repository.deleteStudent(id);
  }
}

// DTO
class StudentDto {
  // convert to json to student object
  static Student fromJson(String id, Map<String, dynamic> json) {
    return Student(
        id: id,
        age: json['age'],
        name: json['name'],
        course: json['course'],
        year: json['year']);
  }

  // convert student object to json
  static Map<String, dynamic> toJson(Student student) {
    return {
      'age': student.age,
      'name': student.name,
      'course': student.course,
      'year': student.year,
    };
  }
}

// Model
class Student {
  final String id;
  final int age;
  final String name;
  final String course;
  final String year;

  Student(
      {required this.id,
      required this.age,
      required this.name,
      required this.course,
      required this.year});

  @override
  String toString() {
    return 'Student(id: $id, age: $age, name: $name, course: $course, year: $year)';
  }
}
