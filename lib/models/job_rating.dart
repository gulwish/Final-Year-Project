class JobRating {
  final String ratingId; // The collection id which is saved for this model
  final String jobId; // The id of the job done
  final String taskId; // ID of the task ad
  final String hirerId;
  final String labourerId;
  final double? ratingForHirer;
  final double? ratingForLabourer;
  final String? feedbackForHirer;
  final String? feedbackForLabourer;

  JobRating({
    required this.ratingId,
    required this.jobId,
    required this.taskId,
    required this.hirerId,
    required this.labourerId,
    this.ratingForHirer,
    this.ratingForLabourer,
    this.feedbackForHirer,
    this.feedbackForLabourer,
  });

  static JobRating fromMap(Map<String, dynamic> map) {
    return JobRating(
      ratingId: map['ratingId'],
      jobId: map['jobId'],
      taskId: map['taskId'],
      hirerId: map['hirerId'],
      labourerId: map['labourerId'],
      ratingForHirer: map['ratingForHirer'],
      ratingForLabourer: map['ratingForLabourer'],
      feedbackForHirer: map['feedbackForHirer'],
      feedbackForLabourer: map['feedbackForLabourer'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ratingId': ratingId,
      'jobId': jobId,
      'taskId': taskId,
      'hirerId': hirerId,
      'labourerId': labourerId,
      'ratingForHirer': ratingForHirer,
      'ratingForLabourer': ratingForLabourer,
      'feedbackForHirer': feedbackForHirer,
      'feedbackForLabourer': feedbackForLabourer,
    };
  }
}
