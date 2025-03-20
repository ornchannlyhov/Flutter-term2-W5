import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import 'course_score_form.dart';
import '../providers/courses_provider.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key});

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  //List<CourseScore> get scores => widget.course.scores;

  void _addScore() async {
    final courseProvider = Provider.of<CoursesProvider>(context, listen: false);
    CourseScore? newSCore = await Navigator.of(context).push<CourseScore>(
      MaterialPageRoute(builder: (ctx) => const CourseScoreForm()),
    );

    if (newSCore != null) {
      courseProvider.addScore(courseProvider.selectedCourse!.name, newSCore);
    }
  }

  Color scoreColor(double score) {
    return score > 50 ? Colors.green : Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final coursesProvider = Provider.of<CoursesProvider>(context);
    Widget content = const Center(child: Text('No Scores added yet.'));

    if (coursesProvider.selectedCourse != null && coursesProvider.selectedCourse!.scores.isNotEmpty) {
      content = ListView.builder(
        itemCount: coursesProvider.selectedCourse!.scores.length,
        itemBuilder:
            (ctx, index) => ListTile(
              title: Text(coursesProvider.selectedCourse!.scores[index].studentName),
              trailing: Text(
                coursesProvider.selectedCourse!.scores[index].studenScore.toString(),
                style: TextStyle(
                  color: scoreColor(coursesProvider.selectedCourse!.scores[index].studenScore),
                  fontSize: 15,
                ),
              ),
            ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          coursesProvider.selectedCourse?.name ?? "Course",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: _addScore, icon: const Icon(Icons.add)),
        ],
      ),
      body: content,
    );
  }
}