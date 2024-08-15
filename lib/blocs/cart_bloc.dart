// lib/blocs/cart_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/database/cart_database.dart';
import 'package:flutter_cart/main.dart';
import '../models/product.dart';

class CartState {
  final Map<Product, int> items;

  CartState({this.items = const {}});

  double get totalPrice =>
      items.entries.fold(0, (total, entry) => total + entry.key.price * entry.value);

  int get totalItems => items.values.fold(0, (total, quantity) => total + quantity);
}

class CartEvent {}

class AddToCartEvent extends CartEvent {
  final Product product;
  final int quantity;

  AddToCartEvent(this.product, this.quantity);
}

class UpdateQuantityEvent extends CartEvent {
  final Product product;
  final int newQuantity;

  UpdateQuantityEvent(this.product, this.newQuantity);
}

class RemoveFromCartEvent extends CartEvent {
  final Product product;

  RemoveFromCartEvent(this.product);
}

class ClearCartEvent extends CartEvent {}

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartDatabase _cartDatabase = CartDatabase();

  CartBloc() : super(CartState()) {
    on<LoadCartEvent>((event, emit) async {
      final cartItems = await _cartDatabase.getCartItems();
      final items = {
        for (var item in cartItems)
        Product(
          id: item['id'], 
          name: item['name'], 
          imageUrl: item['imageUrl'], 
          price: item['price'],
        ) : item['quantity'],
      };
      emit(CartState(items: items));
    });

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

    on<UpdateQuantityEvent>((event, emit) async {
      final items = Map<Product, int>.from(state.items);
      if (event.newQuantity > 0) {
        items[event.product] = event.newQuantity;
        await _cartDatabase.updateQuantity(event.product.id, event.newQuantity);
      } else {
        items.remove(event.product);
         await _cartDatabase.removeFromCart(event.product.id);
      }
      emit(CartState(items: items));
    });

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
