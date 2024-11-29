// ignore_for_file: constant_identifier_names

enum JobState {
  PENDING,
  ACCEPTED,
  ON_THE_WAY, //
  AWAITING_ARRIVAL_CONFIRMATION, //
  REACHED, //
  COMPLETED_TASK,
  AWAITING_COMPLETION_CONFIRMATION, //
  AWAITING_PAY_CONFIRMATION,
  FINISHED_JOB,
  DECLINED,
}

String jobStateToString(JobState state) {
  switch (state) {
    case JobState.PENDING:
      return 'Pending';
    case JobState.ACCEPTED:
      return 'Accepted';
    case JobState.ON_THE_WAY:
      return 'On The Way';
    case JobState.AWAITING_ARRIVAL_CONFIRMATION:
      return 'Awaiting Arrival Confirmation';
    case JobState.REACHED:
      return 'Reached';
    case JobState.COMPLETED_TASK:
      return 'Completed Task';
    case JobState.AWAITING_COMPLETION_CONFIRMATION:
      return 'Awaiting Completion Confirmation';
    case JobState.AWAITING_PAY_CONFIRMATION:
      return 'Awaiting Pay Confirmation';
    case JobState.FINISHED_JOB:
      return 'Finished Job';
    case JobState.DECLINED:
      return 'Declined';
    default:
      return 'Pending';
  }
}

JobState parseJobState(String str) {
  switch (str) {
    case 'Pending':
      return JobState.PENDING;
    case 'Accepted':
      return JobState.ACCEPTED;
    case 'On The Way':
      return JobState.ON_THE_WAY;
    case 'Awaiting Arrival Confirmation':
      return JobState.AWAITING_ARRIVAL_CONFIRMATION;
    case 'Reached':
      return JobState.REACHED;
    case 'Completed Task':
      return JobState.COMPLETED_TASK;
    case 'Awaiting Completion Confirmation':
      return JobState.AWAITING_COMPLETION_CONFIRMATION;
    case 'Awaiting Pay Confirmation':
      return JobState.AWAITING_PAY_CONFIRMATION;
    case 'Finished Job':
      return JobState.FINISHED_JOB;
    case 'Declined':
      return JobState.DECLINED;
    default:
      return JobState.PENDING;
  }
}
