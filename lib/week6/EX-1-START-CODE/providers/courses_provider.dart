import 'package:flutter/material.dart';
import 'package:observer/week6/EX-1-START-CODE/repositories/courses_repositoy.dart';
import '../models/course.dart';
import '../repositories/courses_mock_repository.dart';

class CoursesProvider with ChangeNotifier {
  final CoursesRepository _coursesRepository = CoursesMockRepository();
  List<Course> _allCourses = [];
  Course? _selectedCourse;

  List<Course> get allCourses => _allCourses;
  Course? get selectedCourse => _selectedCourse;

  CoursesProvider() {
    loadCourses();
  }

  Future<void> loadCourses() async {
    _allCourses = await _coursesRepository.getCourses();
    notifyListeners();
  }

  Future<void> setSelectedCourse(String courseName) async{
    _selectedCourse = await _coursesRepository.getCourseFor(courseName);
    notifyListeners();
  }

  Future<void> addScore(String courseName, CourseScore score) async {
    await _coursesRepository.addScore(courseName, score);
    _selectedCourse = await _coursesRepository.getCourseFor(courseName);
    notifyListeners();
  }
}