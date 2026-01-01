import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/rangeviewmodel.dart';
import '../widgets/triangle_painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RangeViewModel>();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : vm.error != null
              ? Center(child: Text(vm.error!))
              : Column(
            children: [
              Expanded(
                child: Center(
                  child: _rangeBar(vm),
                ),
              ),
              _bottomControls(vm),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- RANGE BAR ----------------
  Widget _rangeBar(RangeViewModel vm) {
    // If min, max, or value are null, show a loading indicator
    if (vm.min == null || vm.max == null || vm.value == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;

        // Prevent division by zero
        final safeMax = vm.max! > 0 ? vm.max! : 1.0;

        final pointerX = (vm.value! / safeMax) * barWidth;

        return SizedBox(
          height: 90,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              /// Bar
              Positioned(
                top: 24,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Row(
                    children: vm.ranges.map((range) {
                      final width = range.end - range.start;
                      return _segment(
                        width,
                        Color(int.parse(range.color.replaceFirst('#', '0xff'))),
                      );
                    }).toList(),
                  ),
                ),
              ),

              /// Labels (from API)
              ...vm.ranges.map(
                    (r) => _label(
                  r.start.toDouble(),
                  barWidth,
                  safeMax,
                  top: 52,
                ),
              ),

              /// Pointer
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                left: pointerX - 10,
                top: 50,
                child: Column(
                  children: [
                    CustomPaint(
                      size: const Size(20, 10),
                      painter: TrianglePainter(),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      vm.value!.toInt().toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ---------------- LABEL ----------------
  Widget _label(
      double labelValue,
      double barWidth,
      double max, {
        required double top,
      }) {
    final safeMax = max > 0 ? max : 1.0;
    final left = (labelValue / safeMax) * barWidth;

    return Positioned(
      left: left - 12,
      top: top,
      child: Text(
        labelValue.toInt().toString(),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }


  /// ---------------- BAR SEGMENT ----------------
  Widget _segment(int range, Color color) {
    return Expanded(
      flex: range,
      child: Container(
        height: 24,
        color: color,
      ),
    );
  }



  /// ---------------- BOTTOM CONTROLS ----------------
  Widget _bottomControls(RangeViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: vm.controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                hintText: "Enter value (0 - 120)",
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.arrow_forward, size: 28),
            onPressed: vm.applyValue,
          ),
        ],
      ),
    );
  }
}
