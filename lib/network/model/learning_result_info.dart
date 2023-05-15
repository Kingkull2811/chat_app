class LearningResultInfo {
  final int? id;
  final int? subjectId;
  final String? subjectName;
  final int? learningResultId;
  final double? oralTestScore;
  final double? m15TestScore;
  final double? m45TestScore;
  final double? semesterTestScore;
  final double? semesterSummaryScore;

  LearningResultInfo({
    this.id,
    this.subjectId,
    this.subjectName,
    this.learningResultId,
    this.oralTestScore,
    this.m15TestScore,
    this.m45TestScore,
    this.semesterTestScore,
    this.semesterSummaryScore,
  });

  factory LearningResultInfo.fromJson(Map<String, dynamic> json) {
    return LearningResultInfo(
      id: json['id'],
      subjectId: json['subjectId'],
      subjectName: json['subjectName'],
      learningResultId: json['learningResultId'],
      oralTestScore: json['oralTestScore'],
      m15TestScore: json['m15TestScore'],
      m45TestScore: json['m45TestScore'],
      semesterTestScore: json['semesterTestScore'],
      semesterSummaryScore: json['semesterSummaryScore'],
    );
  }

  LearningResultInfo copyWith({
    int? id,
    int? subjectId,
    String? subjectName,
    int? learningResultId,
    double? oralTestScore,
    double? m15TestScore,
    double? m45TestScore,
    double? semesterTestScore,
    double? semesterSummaryScore,
  }) =>
      LearningResultInfo(
        id: id ?? this.id,
        subjectId: subjectId ?? this.subjectId,
        subjectName: subjectName ?? this.subjectName,
        learningResultId: learningResultId ?? this.learningResultId,
        oralTestScore: oralTestScore ?? this.oralTestScore,
        m15TestScore: m45TestScore ?? this.m15TestScore,
        m45TestScore: m45TestScore ?? this.m45TestScore,
        semesterTestScore: semesterTestScore ?? this.semesterTestScore,
        semesterSummaryScore: semesterSummaryScore ?? this.semesterSummaryScore,
      );

  @override
  String toString() {
    return 'LearningResultInfo{id: $id, subjectId: $subjectId, subjectName: $subjectName, learningResultId: $learningResultId, oralTestScore: $oralTestScore, m15TestScore: $m15TestScore, m45TestScore: $m45TestScore, semesterTestScore: $semesterTestScore, semesterSummaryScore: $semesterSummaryScore}';
  }
}
