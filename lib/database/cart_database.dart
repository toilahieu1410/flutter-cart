
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

class CartDatabase {
  static final CartDatabase _instance = CartDatabase._internal();
  static Database? _database;

  CartDatabase._internal();

  factory CartDatabase() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

   Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cart.db');
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart_items (
            id INTEGER PRIMARY KEY,
            name TEXT,
            imageUrl TEXT,
            price INTEGER,
            isHot INTEGER,
            quantity INTEGER
          )
        ''');
      },
      version: 1,
    );
  }
  Future<void> addToCart(Product product, int quantity) async {
    final db = await database;
    await db.insert(
      'cart',
      {
        'id': product.id,
        'name': product.name,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isHot': product.isHot ? 1 : 0,
        'quantity': quantity,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
}

Future<List<Map<String, dynamic>>> getCartItems() async {
  final db = await database;
  return await db.query('cart');
}

Future<void> updateQuantity(int id, int quantity) async {
  final db = await database;
  await db.update(
    'cart',
    {'quantity': quantity},
    where: 'id = ?',
    whereArgs: [id],
  );
}

Future<void> removeFromCart(int id) async {
    final db = await database;
    await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart');
  }
  Future<Map<Product, int>> getCartItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cart_items');

    Map<Product, int> cartItems = {};
    for (var map in maps) {
      cartItems[Product(
        id: map['id'],
        name: map['name'],
        imageUrl: map['imageUrl'],
        price: map['price'],
        isHot: map['isHot'] == 1,
      )] = map['quantity'];
    }

    return cartItems;
  }
}

