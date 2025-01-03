import 'package:flutter/material.dart';

class TeacherCourseDetailView extends StatefulWidget {
  final String courseID;
  const TeacherCourseDetailView({super.key, required this.courseID});


  @override
  State<TeacherCourseDetailView> createState() => _TeacherCourseDetailViewState();
}

class _TeacherCourseDetailViewState extends State<TeacherCourseDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Course ID: ${widget.courseID}'),
      ),
    );
  }
}
