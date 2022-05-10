import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_9/core/domain/models/Product.dart';
import 'package:isar/isar.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool? res;
  bool load = false;
  
  void loaded() async {
    setState(() {
      load = true;
    });
    await compute(_loaded, 10000);
    setState(() {
      load = false;
    });
  }

  static void _loaded(int col) async {
    final isar = await Isar.open(
      schemas: [],
    );

    final products = List.generate(col, (i) => Product(name: 'Product $i'));

    await isar.products.putAll(products);
  }

  @override
  Widget build(BuildContext context) {
    if (load == true) {
      return const Center(child: CircularProgressIndicator());
    }

    if (res == null) {
      return Center(
        child: TextButton(
          onPressed: loaded,
          child: const Text('data'),
        ),
      );
    } else {
      return const Center(
        child: Text('data'),
      );
    }
  }
}
