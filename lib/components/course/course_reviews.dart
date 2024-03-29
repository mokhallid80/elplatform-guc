import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/review/ratings_summary.dart';
import 'package:guc_swiss_knife/components/review/add_review.dart';
import 'package:guc_swiss_knife/components/review/reviews_list.dart';
import 'package:guc_swiss_knife/models/review.dart';

class CourseReviews extends StatefulWidget {
  List<Review> reviews;
  final String courseId;
  CourseReviews({super.key, required this.reviews, required this.courseId});

  @override
  State<CourseReviews> createState() => _CourseReviews();
}

class _CourseReviews extends State<CourseReviews> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RatingsSummary(reviews: widget.reviews),
        ReviewsList(reviews: widget.reviews),
        AddReview(
          reviews: widget.reviews,
          courseId: widget.courseId,
          instructorId: null,
          setReviews: setReviews,
        ),
      ],
    );
  }

  void setReviews(List<Review> reviews) {
    setState(() {
      widget.reviews = reviews;
    });
  }
}
