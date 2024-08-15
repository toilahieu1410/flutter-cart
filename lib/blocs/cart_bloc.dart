// lib/blocs/cart_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
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
  CartBloc() : super(CartState()) {
    on<AddToCartEvent>((event, emit) {
      final items = Map<Product, int>.from(state.items);
      if (items.containsKey(event.product)) {
        items[event.product] = items[event.product]! + event.quantity;
      } else {
        items[event.product] = event.quantity;
      }
      emit(CartState(items: items));
    });

    on<UpdateQuantityEvent>((event, emit) {
      final items = Map<Product, int>.from(state.items);
      if (event.newQuantity > 0) {
        items[event.product] = event.newQuantity;
      } else {
        items.remove(event.product);
      }
      emit(CartState(items: items));
    });

    on<RemoveFromCartEvent>((event, emit) {
      final items = Map<Product, int>.from(state.items);
      items.remove(event.product);
      emit(CartState(items: items));
    });

    on<ClearCartEvent>((event, emit) {
      emit(CartState(items: {}));
    });
  }
}
