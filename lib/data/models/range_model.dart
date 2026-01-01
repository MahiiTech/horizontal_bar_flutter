class RangeModel {
  final int start;
  final int end;
  final String meaning;
  final String color;

  RangeModel({
    required this.start,
    required this.end,
    required this.meaning,
    required this.color,
  });

  factory RangeModel.fromJson(Map<String, dynamic> json) {
    final parts = (json['range'] as String)
        .split('-')
        .map((e) => e.trim())
        .toList();

    return RangeModel(
      start: int.parse(parts[0]),
      end: int.parse(parts[1]),
      meaning: json['meaning'],
      color: json['color'],
    );
  }
}
