class LabourerRating {
  final String labourerId;
  final String userId;
  final int rating;
  final String jobId;

  LabourerRating({
    required this.labourerId,
    required this.userId,
    required this.rating,
    required this.jobId,
  });

  static LabourerRating fromMap(Map<String, dynamic> map) {
    return LabourerRating(
      labourerId: map['labourer_id'] as String,
      userId: map['user_id'] as String,
      rating: int.parse(map['rating'].toString()),
      jobId: map['job_id'] as String,
    );
  }
}
