import 'package:flutter/material.dart';
import 'package:guc_swiss_knife/components/review/review_card.dart';
import 'package:guc_swiss_knife/models/review.dart';

class ReviewsList extends StatelessWidget {
  final List<Review> reviews;
  const ReviewsList({super.key, required this.reviews});
  @override
  Widget build(BuildContext context) {
    int reviewsCount = 0;
    for (Review review in reviews) {
      if (review.review != null && review.review!.isNotEmpty) {
        reviewsCount++;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text(
              'Reviews ($reviewsCount)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ]),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Row(
              children: [
                for (var review in reviews)
                  if (review.review != null && review.review!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: ReviewCard(review: review),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
