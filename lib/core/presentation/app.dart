import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_9/core/domain/models/Product.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App._({Key? key}) : super(key: key);

  static Widget create({
    required Isar isar,
  }) =>
      Provider.value(
        value: isar,
        child: const App._(),
      );

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
    final dir = await getApplicationSupportDirectory();
    await compute(_loaded, dir.path);
    setState(() {
      load = false;
    });
  }

  static void _loaded(String path) async {
    final isar = await Isar.open(
      schemas: [ProductSchema],
      directory: path,
    );

    final products = List.generate(1000000, (i) => Product(name: 'Product $i'));

    log(DateTime.now().toString());

    await isar.writeTxn((isar) async {
      await isar.products.putAll(products);
    });

    log(DateTime.now().toString());
  }

  @override
  Widget build(BuildContext context) {
    Widget _body() {
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

    return Scaffold(
      appBar: AppBar(
        title: const TitleWidget(),
      ),
      body: _body(),
    );
  }
}

class TitleWidget extends StatefulWidget {
  const TitleWidget({Key? key}) : super(key: key);

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  late final StreamSubscription<void> productChanged;

  int count = 0;

  @override
  void initState() {
    final isar = context.read<Isar>();
    isar.products.count().then((value) => setState(() => count = value));
    productChanged = isar.products.watchLazy().listen((_) async {
      log('event');
      count = await isar.products.count();
      setState(() {});
    });
    super.initState();

    isar.products.watchObject(0) as Stream<Product>;
  }

  @override
  void dispose() {
    productChanged.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(count.toString());
  }
}
