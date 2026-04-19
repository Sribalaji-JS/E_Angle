class RecommendationResult {
  final String recommendedSection;
  final double recommendedCapacity;
  final String alternativeSection;
  final double alternativeCapacity;
  final String accuracy;
  final double t;
  final int n;
  final int nr;
  final double d;
  final double dh;
  final double p;
  final double e;
  final String failureMode;
  final double A;
  final double B;
  final List<Alternative> alternatives;

  RecommendationResult({
    required this.recommendedSection,
    required this.recommendedCapacity,
    required this.alternativeSection,
    required this.alternativeCapacity,
    required this.accuracy,
    required this.t,
    required this.n,
    required this.nr,
    required this.d,
    required this.dh,
    required this.p,
    required this.e,
    required this.failureMode,
    required this.A,
    required this.B,
    required this.alternatives,
  });

  factory RecommendationResult.fromJson(Map<String, dynamic> j) =>
      RecommendationResult(
        recommendedSection: j['recommended_section'] ?? 'N/A',
        recommendedCapacity: (j['recommended_capacity'] ?? 0.0).toDouble(),
        alternativeSection: j['alternative_section'] ?? 'N/A',
        alternativeCapacity: (j['alternative_capacity'] ?? 0.0).toDouble(),
        accuracy: j['accuracy'] ?? 'Low (65%)',
        t: (j['t'] ?? 0.0).toDouble(),
        n: j['n'] ?? 0,
        nr: j['nr'] ?? 0,
        d: (j['d'] ?? 0.0).toDouble(),
        dh: (j['dh'] ?? 0.0).toDouble(),
        p: (j['p'] ?? 0.0).toDouble(),
        e: (j['e'] ?? 0.0).toDouble(),
        failureMode: j['failure_mode'] ?? 'N/A',
        A: (j['A'] ?? 0.0).toDouble(),
        B: (j['B'] ?? 0.0).toDouble(),
        alternatives: (j['alternatives'] as List? ?? [])
            .map((a) => Alternative.fromJson(a))
            .toList(),
      );
}

class Alternative {
  final String designation;
  final double capacity;
  final double t;
  final int n;
  final int nr;
  final double d;
  final String failure;

  Alternative({
    required this.designation,
    required this.capacity,
    required this.t,
    required this.n,
    required this.nr,
    required this.d,
    required this.failure,
  });

  factory Alternative.fromJson(Map<String, dynamic> j) => Alternative(
        designation: j['designation'] ?? 'N/A',
        capacity: (j['capacity'] ?? 0.0).toDouble(),
        t: (j['t'] ?? 0.0).toDouble(),
        n: j['n'] ?? 0,
        nr: j['nr'] ?? 0,
        d: (j['d'] ?? 0.0).toDouble(),
        failure: j['failure'] ?? 'N/A',
      );
}
