import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import 'course_screen.dart';
import '../providers/courses_provider.dart';

const Color mainColor = Colors.blue;

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {

  void _editCourse(String courseName) async {
    final coursesProvider = Provider.of<CoursesProvider>(context, listen: false);
    await coursesProvider.setSelectedCourse(courseName);

    if(mounted){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => const CourseScreen()),
      );
    }

    // setState(() {
    //   // trigger a rebuild
    // });
  }

  @override
  Widget build(BuildContext context) {
    final coursesProvider = Provider.of<CoursesProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text('SCORE APP', style: TextStyle(color: Colors.white)),
      ),
      body: coursesProvider.allCourses.isEmpty ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: coursesProvider.allCourses.length,
        itemBuilder:
            (ctx, index) => Dismissible(
              key: Key(coursesProvider.allCourses[index].name),
              child: CourseTile(
                course: coursesProvider.allCourses[index],
                onEdit: _editCourse,
              ),
            ),
      ),
    );
  }
}

class CourseTile extends StatelessWidget {
  const CourseTile({super.key, required this.course, required this.onEdit});

  final Course course;
  final Function(String) onEdit;

  int get numberOfScores => course.scores.length;

  String get numberText {
    return course.hasScore ? "$numberOfScores scores" : 'No score';
  }

  String get averageText {
    String average = course.average.toStringAsFixed(1);
    return course.hasScore ? "Average : $average" : '';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            onTap: () => onEdit(course.name),
            title: Text(course.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(numberText), Text(averageText)],
            ),
          ),
        ),
      ),
    );
  }
}