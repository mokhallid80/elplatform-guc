import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:guc_swiss_knife/models/course.dart';
import 'package:guc_swiss_knife/models/review.dart';

class CourseService {
  static final CollectionReference _coursesCollectionReference =
      FirebaseFirestore.instance.collection('courses');

  static Stream<List<Course>> getCourses() {
    Stream<List<Course>> fetchedInstructors =
        _coursesCollectionReference.snapshots().asyncMap((snapshot) async {
      List<Course> courses = [];
      for (var doc in snapshot.docs) {
        Course course =
            Course.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        courses.add(course);
      }
      return courses;
    });
    return fetchedInstructors;
  }

  static Future<void> addReview(String? courseId, Review review) {
    if (courseId == null) {
      return Future.error('Course ID is null');
    }
    return _coursesCollectionReference
        .doc(courseId)
        .update({
          'reviews': FieldValue.arrayUnion([
            {
              'user_id': review.userId,
              'rating': review.rating,
              'review': review.review,
            }
          ]),
          'ratings_sum': FieldValue.increment(review.rating),
        })
        .then((value) => print("Review Added"))
        .catchError((error) => print("Failed to add review: $error"));
  }

  static Future<void> updateReview(
      String? courseId, Review? oldReview, Review newReview) async {
    if (courseId == null) {
      return Future.error('Course ID is null');
    }
    return _coursesCollectionReference
        .doc(courseId)
        .update({
          'reviews': FieldValue.arrayRemove([
            {
              'user_id': oldReview!.userId,
              'rating': oldReview.rating,
              'review': oldReview.review,
            }
          ]),
          'ratings_sum': FieldValue.increment(-oldReview.rating),
        })
        .then((value) => print("Review Removed"))
        .catchError((error) => print("Failed to remove review: $error"))
        .then((value) => _coursesCollectionReference
            .doc(courseId)
            .update({
              'reviews': FieldValue.arrayUnion([
                {
                  'user_id': newReview.userId,
                  'rating': newReview.rating,
                  'review': newReview.review,
                }
              ]),
              'ratings_sum': FieldValue.increment(newReview.rating),
            })
            .then((value) => print("Review Added"))
            .catchError((error) => print("Failed to add review: $error")));
  }

  static Future<void> deleteReview(String? courseId, Review? review) async {
    if (courseId == null) {
      return Future.error('Course ID is null');
    }
    return _coursesCollectionReference
        .doc(courseId)
        .update({
          'reviews': FieldValue.arrayRemove([
            {
              'user_id': review!.userId,
              'rating': review.rating,
              'review': review.review,
            }
          ]),
          'ratings_sum': FieldValue.increment(-review.rating),
        })
        .then((value) => print("Review Deleted"))
        .catchError((error) => print("Failed to delete review: $error"));
  }

  static void deleteCourse(String id) {
    _coursesCollectionReference.doc(id).delete();
  }

  static void addCourse(Course course) {
    _coursesCollectionReference.add(course.toMap());
  }
}
