import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/failure/failure.dart';
import '../entity/course_entity.dart';
import '../repository/course_repository.dart';

final courseUseCaseProvider = Provider<CourseUseCase>(
  (ref) => CourseUseCase(
    courseRepository: ref.read(courseRepositoryProvider),
  ),
);

class CourseUseCase {
  final ICourseRepository courseRepository;

  CourseUseCase({required this.courseRepository});

  Future<Either<Failure, bool>> addCourse(CourseEntity course) {
    return courseRepository.addCourse(course);
  }

  Future<Either<Failure, List<CourseEntity>>> getAllCourses() {
    return courseRepository.getAllCourses();
  }
}
