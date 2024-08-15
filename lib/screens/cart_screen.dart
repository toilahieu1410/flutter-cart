import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/widgets/quantity_input_modal.dart';
import 'package:intl/intl.dart';
import '../blocs/cart_bloc.dart';
import '../models/product.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0, // Không hiển thị phần thập phân
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return Text(
              'Cart (${state.totalItems})',
              style: const TextStyle(color: Colors.white),
            );
          },
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return Center(child: Text('No items in the cart'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final product = state.items.keys.elementAt(index);
                    final quantity = state.items[product]!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),

                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                 BoxShadow(
                                  color: Color.fromARGB(3, 0, 0, 0),
                                  blurRadius: 8,
                                  offset: Offset(0, 4), // Điều chỉnh hướng của bóng
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              leading: SizedBox(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    product.imageUrl,
                                 width: 100,
                                height: 100,
                                    fit: BoxFit.cover),
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                     Text(
                                  product.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                     Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            const Color.fromARGB(255, 190, 189, 189),
                                      ),
                                      borderRadius: BorderRadius.circular(6), // Bo góc nút xóa
                                    ),
                                    child: IconButton(
                                      iconSize: 24,
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        context
                                            .read<CartBloc>()
                                            .add(RemoveFromCartEvent(product));
                                      },
                                    ),
                                  ),
                                
                                ],
                              ),
                             
                              subtitle:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min, 
                                      children: [
                                    // Nút giảm số lượng
                                    Container(
                                      width: 32, // Điều chỉnh chiều rộng của nút
                                      height: 32,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 190, 189, 189)),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                      ),
                                      child: IconButton(
                                        iconSize: 16,
                                        icon: Icon(Icons.remove),
                                        onPressed: () {
                                          if (quantity > 1) {
                                            context.read<CartBloc>().add(
                                                UpdateQuantityEvent(
                                                    product, quantity - 1));
                                          } else {
                                            context
                                                .read<CartBloc>()
                                                .add(RemoveFromCartEvent(product));
                                          }
                                        },
                                      ),
                                    ),
                                    // Hiển thị số lượng và mở modal khi click
                                    GestureDetector(
                                      onTap: () async {
                                        final newQuantity = await showDialog<int>(
                                          context: context,
                                          builder: (context) => ProductQuantityModal(
                                            initialQuantity: quantity,
                                            productName: product.name,
                                          ),
                                        );
                                                                
                                        if (newQuantity != null) {
                                          context.read<CartBloc>().add(
                                              UpdateQuantityEvent(
                                                  product, newQuantity));
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 4),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                                color:
                                                    Color.fromARGB(255, 190, 189, 189)),
                                            bottom: BorderSide(
                                                color:
                                                    Color.fromARGB(255, 190, 189, 189)),
                                          ),
                                        ),
                                        child: Text(
                                          quantity.toString(),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                                                
                                    // Nút tăng số lượng
                                    Container(
                                      width: 32, // Điều chỉnh chiều rộng của nút
                                      height: 32,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 190, 189, 189)),
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                      ),
                                      child: IconButton(
                                        iconSize: 16,
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          context.read<CartBloc>().add(
                                              UpdateQuantityEvent(
                                                  product, quantity + 1));
                                        },
                                      ),
                                    ),
                                  ]),
                                  ),
                                   Text(
                                      priceFormat.format(product.price * quantity),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Tổng tiền thanh toán: ${priceFormat.format(state.totalPrice)}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(ClearCartEvent());
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Order Thành công rồi'),
                          content: const Text('Cảm ơn bạn đã mua hàng!'),
                          actions: [
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Back to Home',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Order',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
