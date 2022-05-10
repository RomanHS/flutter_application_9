import 'package:flutter/material.dart';
import 'package:flutter_application_9/core/domain/models/Product.dart';
import 'package:flutter_application_9/core/presentation/app.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationSupportDirectory();

  // Open Isar in the UI isolate
  final Isar isar = await Isar.open(
    schemas: [ProductSchema],
    directory: dir.path,
  );

  runApp(App.create(isar: isar));
}
