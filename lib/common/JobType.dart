enum JobType { JOBS, TODAY, UPCOMING }

extension JobTypeExtension on JobType {
  String get title {
    switch (this) {
      case JobType.JOBS:
        return 'Jobs Request';
      case JobType.TODAY:
        return 'Today\'s Jobs Request';

      case JobType.UPCOMING:
        return 'Upcoming Jobs Request';

      default:
        return "Jobs Request";
    }
  }
}
