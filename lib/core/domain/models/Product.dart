import 'package:isar/isar.dart';
part 'Product.g.dart';

@Collection()
class Product {
  @Id()
  int id = Isar.autoIncrement;
  final String name;

  Product({
    required this.name,
  });
}
