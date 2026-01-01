import 'dart:math';
import 'package:flutter/material.dart';
import '../data/models/range_model.dart';
import '../data/repository/range_repository.dart';

class RangeViewModel extends ChangeNotifier {
  final RangeRepository repository;

  RangeViewModel(this.repository);

  List<RangeModel> ranges = [];
  bool isLoading = false;
  String? error;

  double? min;
  double? max;
  double? _value;
  double? get value => _value;

  late TextEditingController controller;

  Future<void> loadRanges() async {
    isLoading = true;
    notifyListeners();

    try {
      ranges = await repository.getRanges();
      error = null;

      if (ranges.isNotEmpty) {
        // Determine dynamic min and max from the start and end of all ranges
        min = ranges.map((r) => r.start.toDouble()).reduce((a, b) => a < b ? a : b);
        max = ranges.map((r) => r.end.toDouble()).reduce((a, b) => a > b ? a : b);

        // Pick a random initial value between min and max
        _value = min! + Random().nextDouble() * (max! - min!);

        // Initialize the controller with this random value
        controller = TextEditingController(text: _value!.toInt().toString());
      } else {
        // Fallback if API returns empty list
        min = 0;
        max = 120;
        _value = 60;
        controller = TextEditingController(text: _value!.toInt().toString());
      }
    } catch (e) {
      error = e.toString();
      // Fallback in case of error
      min = 0;
      max = 120;
      _value = 60;
      controller = TextEditingController(text: _value!.toInt().toString());
    }

    isLoading = false;
    notifyListeners();
  }

  void applyValue() {
    if (_value == null || min == null || max == null) return;

    final input = double.tryParse(controller.text);
    if (input == null) return;

    final clamped = input.clamp(min!, max!);
    _value = clamped;
    controller.text = clamped.toInt().toString();

    notifyListeners();
  }
}
