import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/blocs/cart_bloc.dart';
import 'package:flutter_cart/models/product.dart';
import 'package:flutter_cart/screens/cart_screen.dart';
import 'package:flutter_cart/widgets/bottom_sheet_quantity_selector.dart';
import 'package:flutter_cart/widgets/product_tile.dart';

class HomeScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
      id: 1,
      name: 'Product #1',
      imageUrl: 'assets/images/product_1.jpg',
      price: 10000,
    ),
    Product(
      id: 2,
      name: 'Product #2',
      imageUrl: 'assets/images/product_2.jpg',
      price: 20000,
    ),
    Product(
      id: 3,
      name: 'Product #3',
      imageUrl: 'assets/images/product_3.jpg',
      price: 30000,
      isHot: true,
    ),
    Product(
      id: 4,
      name: 'Product #4',
      imageUrl: 'assets/images/product_4.jpg',
      price: 40000,
    ),
    Product(
      id: 5,
      name: 'Product #5',
      imageUrl: 'assets/images/product_5.jpg',
      price: 50000,
    ),
    Product(
      id: 6,
      name: 'Product #6',
      imageUrl: 'assets/images/product_6.jpg',
      price: 60000,
      isHot: true,
    ),
    Product(
      id: 7,
      name: 'Product #7',
      imageUrl: 'assets/images/product_7.jpg',
      price: 70000,
    ),
    Product(
      id: 8,
      name: 'Product #8',
      imageUrl: 'assets/images/product_8.jpg',
      price: 70000,
    ),
    Product(
      id: 9,
      name: 'Product #9',
      imageUrl: 'assets/images/product_9.jpg',
      price: 70000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: const Text('HomePage - Cart', style: TextStyle(color: Colors.white)),
        actions: [
          BlocBuilder<CartBloc, CartState>(builder: (context, state) {
            return Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CartScreen()),
                    );
                  },
                ),
                if (state.totalItems > 0)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        state.totalItems.toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  )
              ],
            );
          }),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('HOT Products',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.w700
                    )
                  ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 210,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: ProductTile(
                              product: product,
                              onAddToCart: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (_) => QuantitySelectorBottomSheet(
                                    product: product,
                                    onAddToCart: (quantity) {
                                      context
                                          .read<CartBloc>()
                                          .add(AddToCartEvent(product, quantity));
                                    },
                                  ),
                                );
                              }),
                        ),
                      );
                    }),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
              child: Text('All Products', 
              style: TextStyle(
                fontSize: 18, 
                color:Colors.orange
                ),
              ),
            ),
          
        ],
      ),
    );
  }
}
