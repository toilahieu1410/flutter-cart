import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/screens/home_screen.dart';
import 'package:flutter_cart/widgets/quantity_input_modal.dart';
import 'package:intl/intl.dart';
import '../blocs/cart_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
            return const Center(child: Text('No items in the cart'));
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
                        horizontal: 8, vertical: 8),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: Padding(
                           padding: const EdgeInsets.all(12), 
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
                            child: Row(
                              children: [
                                // Hình ảnh sản phẩm
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: product.imageUrl.startsWith('http')
                                  ? Image.network(
                                      product.imageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      product.imageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                ),
                                const SizedBox(width: 10), // Khoảng cách giữa ảnh và thông tin
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                product.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              width: 38,
                                              height: 38,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color.fromARGB(255, 190, 189, 189),
                                                ),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Center(
                                                child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  iconSize: 24,
                                                  icon: const Icon(Icons.close),
                                                  onPressed: () {
                                                    context.read<CartBloc>().add(RemoveFromCartEvent(product));
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10), // Khoảng cách giữa title và subtitle
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                // Nút giảm số lượng
                                                Container(
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: const Color.fromARGB(255, 190, 189, 189),
                                                    ),
                                                    borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(10),
                                                      bottomLeft: Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: IconButton(
                                                    iconSize: 16,
                                                    icon: const Icon(Icons.remove),
                                                    onPressed: () {
                                                      if (quantity > 1) {
                                                        context.read<CartBloc>().add(UpdateQuantityEvent(product, quantity - 1));
                                                      } else {
                                                        context.read<CartBloc>().add(RemoveFromCartEvent(product));
                                                      }
                                                    },
                                                  ),
                                                ),
                                                // Hiển thị số lượng
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
                                                      context.read<CartBloc>().add(UpdateQuantityEvent(product, newQuantity));
                                                    }
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                                                    decoration: const BoxDecoration(
                                                      border: Border(
                                                        top: BorderSide(
                                                          color: Color.fromARGB(255, 190, 189, 189),
                                                        ),
                                                        bottom: BorderSide(
                                                          color: Color.fromARGB(255, 190, 189, 189),
                                                        ),
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
                                                  width: 32,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: const Color.fromARGB(255, 190, 189, 189),
                                                    ),
                                                    borderRadius: const BorderRadius.only(
                                                      topRight: Radius.circular(10),
                                                      bottomRight: Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: IconButton(
                                                    iconSize: 16,
                                                    icon: const Icon(Icons.add),
                                                    onPressed: () {
                                                      context.read<CartBloc>().add(UpdateQuantityEvent(product, quantity + 1));
                                                    },
                                                  ),
                                                ),
                                              ],
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
                                      ],
                                    ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                    'Tổng tiền thanh toán',
                    style:  TextStyle(fontSize: 20),
                  ),
                  Text(
                     priceFormat.format(state.totalPrice),
                     style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                     ),
                  )
                  ],
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
                                  // quay lại màn hình trước đó
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                     MaterialPageRoute(
                                      builder: (context) => const HomeScreen(), // Đảm bảo điều hướng về HomeScreen
                                    ),
                                    (route) => false,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Back to Home',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
