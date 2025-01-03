import 'package:flutter/material.dart';

import '../../../../core/sph/sph.dart';
import '../../../../models/lessons_teacher.dart';
import '../widgets/course_folder_history_entry_card.dart';

class TeacherCourseDetailView extends StatefulWidget {
  final CourseFolderStartPage courseFolder;
  const TeacherCourseDetailView({super.key, required this.courseFolder});


  @override
  State<TeacherCourseDetailView> createState() => _TeacherCourseDetailViewState();
}

class _TeacherCourseDetailViewState extends State<TeacherCourseDetailView> {
  bool _loading = true;
  late CourseFolderDetails data;

  void loadData() async {
    data = await sph!.parser.lessonsTeacherParser.getCourseFolderDetails(widget.courseFolder.id);
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseFolder.name),
      ),
      body: _loading ? Center(
        child: CircularProgressIndicator(),
      ) : ListView.builder(
        itemCount: data.history.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: CourseFolderHistoryEntryCard(entry: data.history[index]),
        ),
      ),
    );
  }
}
