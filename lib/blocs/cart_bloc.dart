// lib/blocs/cart_bloc.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/database/cart_database.dart';
import '../models/product.dart';

void main() {}

// Định nghĩa trạng thái của giỏ hàng, được so sánh bằng Equatable
class CartState extends Equatable{
  final Map<Product, int> items;

  CartState({this.items = const {}});

  double get totalPrice =>
      items.entries.fold(0, (total, entry) => total + entry.key.price * entry.value);

  int get totalItems => items.values.fold(0, (total, quantity) => total + quantity);
  @override
  List<Object?> get props => [items];
}

class CartEvent {}

// Sự kiện để tải giỏ hàng từ cơ sở dữ liệu
class LoadCartEvent extends CartEvent {}

// Sự kiện để thêm sản phẩm vào giỏ hàng
class AddToCartEvent extends CartEvent {
  final Product product;
  final int quantity;

  AddToCartEvent(this.product, this.quantity);
}

// Sự kiện để cập nhật số lượng sản phẩm trong giỏ hàng
class UpdateQuantityEvent extends CartEvent {
  final Product product;
  final int newQuantity;

  UpdateQuantityEvent(this.product, this.newQuantity);
}

// Sự kiện để xóa sản phẩm khỏi giỏ hàng
class RemoveFromCartEvent extends CartEvent {
  final Product product;

  RemoveFromCartEvent(this.product);
}

// Sự kiện để xóa toàn bộ giỏ hàng
class ClearCartEvent extends CartEvent {}

// Bloc quản lý giỏ hàng
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartDatabase _cartDatabase; // Tham chiếu đến cơ sở dữ liệu giỏ hàng

  CartBloc(this._cartDatabase) : super(CartState()) {
    on<LoadCartEvent>((event, emit) async {
      // Lấy giỏ hàng từ DB
      final cartItems = await _cartDatabase.getCartItems();
       if(cartItems != null) {
        emit(CartState(items: cartItems));
      } else {
        emit(CartState(items: {}));
      }
          
    });

    // Xử lý sự kiện AddToCartEvent
    on<AddToCartEvent>((event, emit) async {
      final items = Map<Product, int>.from(state.items);
      if (items.containsKey(event.product)) {
        items[event.product] = items[event.product]! + event.quantity;
        await _cartDatabase.updateQuantity(event.product.id, items[event.product]!);
      } else {
        items[event.product] = event.quantity;
        await _cartDatabase.addToCart(event.product, event.quantity);
      }
      emit(CartState(items: items));
    });

    // Xử lý sự kiện UpdateQuantityEvent
    on<UpdateQuantityEvent>((event, emit) async {
      // Sao chép giỏ hàng hiện tại
      final items = Map<Product, int>.from(state.items);
      if (event.newQuantity > 0) {
        items[event.product] = event.newQuantity;
         // Cập nhật số lượng trong DB
        await _cartDatabase.updateQuantity(event.product.id, event.newQuantity);
      } else {
        items.remove(event.product);
        // Xóa sản phẩm khỏi DB
         await _cartDatabase.removeFromCart(event.product.id);
      }
      emit(CartState(items: items));
    });

    // Xử lý sự kiện RemoveFromCartEvent
    on<RemoveFromCartEvent>((event, emit) async {
      final items = Map<Product, int>.from(state.items);
      items.remove(event.product);
      await _cartDatabase.removeFromCart(event.product.id);
      emit(CartState(items: items));
    });

    on<ClearCartEvent>((event, emit) async {
      await _cartDatabase.clearCart();
      emit(CartState(items: {}));
    });
  }
}
