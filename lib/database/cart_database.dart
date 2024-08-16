
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';

void main() {}

class CartDatabase {
  static final CartDatabase _instance = CartDatabase._internal();
  static Database? _database;

  CartDatabase._internal();

  factory CartDatabase() {
    return _instance;
  }

  Future<Database> get database async {
     // Nếu cơ sở dữ liệu đã được khởi tạo, trả về nó.
    if (_database != null) return _database!;

    // Nếu chưa, khởi tạo cơ sở dữ liệu.
    _database = await _initDatabase();
    return _database!;
  }

 // Phương thức riêng để khởi tạo cơ sở dữ liệu.
   Future<Database> _initDatabase() async {
    // Lấy đường dẫn đến tệp cơ sở dữ liệu trên thiết bị.
    String path = join(await getDatabasesPath(), 'cart.db');

    // Mở cơ sở dữ liệu và tạo các bảng cần thiết nếu chúng chưa tồn tại.
    return await openDatabase(
      path,
      onCreate: (db, version) async {
         // Câu lệnh SQL để tạo bảng `cart_items`.
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

  // Phương thức thêm sản phẩm vào giỏ hàng.
  Future<void> addToCart(Product product, int quantity) async {
    final db = await database;
    await db.insert(
      'cart_items',
      {
        'id': product.id,
        'name': product.name,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isHot': product.isHot ? 1 : 0, // SQLite không có kiểu boolean, vì vậy 1 là true, 0 là false.
        'quantity': quantity,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Nếu sản phẩm đã tồn tại trong giỏ, thay thế nó.
    );
}

Future<Map<Product, int>> getCartItems() async {
  final db = await database; // Lấy kết nối cơ sở dữ liệu.

  // Truy vấn bảng `cart_items` và trả về tất cả các hàng.
  final List<Map<String, dynamic>> maps = await db.query('cart_items');
  
  // Tạo một map rỗng để lưu trữ sản phẩm và số lượng của chúng.
  Map<Product, int> cartItems = {};

  // Duyệt qua từng hàng trong bảng và chuyển đổi nó thành đối tượng Product với số lượng tương ứng.
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

 // Cập nhật số lượng của sản phẩm với id cụ thể.
Future<void> updateQuantity(int id, int quantity) async {
  final db = await database;
  await db.update(
    'cart_items',
    {'quantity': quantity},
    where: 'id = ?',
    whereArgs: [id],
  );
}

 // Phương thức xóa một sản phẩm khỏi giỏ hàng.
Future<void> removeFromCart(int id) async {
    final db = await database;
    await db.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Phương thức xóa tất cả sản phẩm khỏi giỏ hàng.
Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart_items');
  }
}

