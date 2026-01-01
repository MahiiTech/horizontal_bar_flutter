import 'package:flutter/material.dart';
import 'package:flutter_horizontal_bar/viewmodels/rangeviewmodel.dart';
import 'package:flutter_horizontal_bar/views/home_page.dart';
import 'package:provider/provider.dart';
import 'data/repository/range_repository.dart';
import 'data/services/api_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RangeViewModel(
            RangeRepository(RangeApiService()),
          )..loadRanges(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
