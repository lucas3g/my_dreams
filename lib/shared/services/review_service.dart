import 'package:injectable/injectable.dart';
import 'package:in_app_review/in_app_review.dart';

/// Service responsible for handling app reviews.
@singleton
class ReviewService {
  final InAppReview _review = InAppReview.instance;

  /// Requests the operating system to show the review dialog if available.
  Future<void> requestReview() async {
    final bool available = await _review.isAvailable();
    if (available) {
      await _review.requestReview();
    }
  }
}
