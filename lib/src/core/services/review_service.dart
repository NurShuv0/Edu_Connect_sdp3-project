import 'package:test_app/src/config/api_paths.dart';
import 'package:test_app/src/core/network/api_client.dart';

class ReviewService {
  final ApiClient apiClient;

  ReviewService({required this.apiClient});

  /// Create a review for a teacher
  /// POST /api/reviews/teacher/:teacherId
  Future<void> addTeacherReview({
    required String teacherId,
    required int rating,
    required String comment,
    String? matchId,
  }) async {
    final body = {
      'rating': rating,
      'comment': comment,
      if (matchId != null) 'matchId': matchId,
    };
    await apiClient.post(ApiPaths.teacherReviews(teacherId), body);
  }

  /// Get reviews for a specific teacher
  /// GET /api/reviews/teacher/:teacherId
  Future<List<Map<String, dynamic>>> getTeacherReviews(String teacherId) async {
    final res = await apiClient.get(ApiPaths.teacherReviews(teacherId));
    final list = res['reviews'] ?? res['data'];
    if (list is List) {
      return List<Map<String, dynamic>>.from(
        list.map((e) => Map<String, dynamic>.from(e as Map)),
      );
    }
    return [];
  }

  /// Get my reviews as a teacher (reviews I received)
  /// GET /api/reviews/my-received
  Future<List<Map<String, dynamic>>> getMyReceivedReviews() async {
    try {
      final res = await apiClient.get('/api/reviews/my-received');
      final list = res['reviews'] ?? res['data'] ?? [];
      if (list is List) {
        return List<Map<String, dynamic>>.from(
          list.map((e) => Map<String, dynamic>.from(e as Map)),
        );
      }
      return [];
    } catch (e) {
      print("Error fetching received reviews: $e");
      return [];
    }
  }

  /// Get my reviews as a student (reviews I left)
  /// GET /api/reviews/my
  Future<List<Map<String, dynamic>>> getMyReviews() async {
    try {
      final res = await apiClient.get('/api/reviews/my');
      final list = res['reviews'] ?? res['data'] ?? [];
      if (list is List) {
        return List<Map<String, dynamic>>.from(
          list.map((e) => Map<String, dynamic>.from(e as Map)),
        );
      }
      return [];
    } catch (e) {
      print("Error fetching my reviews: $e");
      return [];
    }
  }

  /// Update my review
  /// PATCH /api/reviews/:reviewId
  Future<void> updateReview(
    String reviewId, {
    int? rating,
    String? comment,
  }) async {
    final body = <String, dynamic>{};
    if (rating != null) body['rating'] = rating;
    if (comment != null) body['comment'] = comment;
    await apiClient.patch('/api/reviews/$reviewId', body);
  }

  /// Delete my review
  /// DELETE /api/reviews/:reviewId
  Future<void> deleteReview(String reviewId) async {
    await apiClient.delete('/api/reviews/$reviewId');
  }

  /// Get average rating for a teacher
  /// GET /api/reviews/rating/:teacherId
  Future<Map<String, dynamic>> getTeacherRating(String teacherId) async {
    try {
      final res = await apiClient.get('/api/reviews/rating/$teacherId');
      return res;
    } catch (e) {
      print("Error fetching teacher rating: $e");
      return {'averageRating': 0.0, 'totalReviews': 0};
    }
  }
}
