import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_cart/blocs/cart_bloc.dart';
import 'package:flutter_cart/database/cart_database.dart';
import 'package:flutter_cart/models/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_bloc_test.mocks.dart';

@GenerateMocks([CartDatabase])
void main() {
  group('CartBloc', () {
    late CartBloc cartBloc;
    late MockCartDatabase mockCartDatabase;

    setUp(() {
      mockCartDatabase = MockCartDatabase();
      cartBloc = CartBloc(mockCartDatabase);
    });

    test('Initial state is CartState with empty items', () {
      expect(cartBloc.state, CartState());
    });

    blocTest<CartBloc, CartState>(
      'emits [CartState] when LoadCartEvent is added',
      build: () {
        when(mockCartDatabase.getCartItems()).thenAnswer(
          (_) async => {
            Product(id: 1, name: 'Product 1', imageUrl: 'url', price: 10000): 1,
          },
        );
        return CartBloc(mockCartDatabase);
      },
      act: (bloc) => bloc.add(LoadCartEvent()),
      expect: () => [
        CartState(
          items: {
            Product(id: 1, name: 'Product 1', imageUrl: 'url', price: 10000): 1,
          },
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [CartState] with updated items when AddToCartEvent is added',
      build: () => cartBloc,
      act: (bloc) {
        final product = Product(id: 1, name: 'Product 1', imageUrl: 'url', price: 10000);
        bloc.add(AddToCartEvent(product, 1));
      },
      expect: () => [
        CartState(
          items: {
            Product(id: 1, name: 'Product 1', imageUrl: 'url', price: 10000): 1,
          },
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [CartState] with empty items when RemoveFromCartEvent is added',
      build: () {
        final product = Product(id: 1, name: 'Product 1', imageUrl: 'url', price: 10000);
        return CartBloc(mockCartDatabase)..add(AddToCartEvent(product, 1));
      },
      act: (bloc) {
        final product = Product(id: 1, name: 'Product 1', imageUrl: 'url', price: 10000);
        bloc.add(RemoveFromCartEvent(product));
      },
      expect: () => [
        CartState(
          items: {
            Product(id: 1, name: 'Product 1', imageUrl: 'url', price: 10000): 1,
          },
        ),
        CartState(items: {}),
      ],
    );
  });
}
