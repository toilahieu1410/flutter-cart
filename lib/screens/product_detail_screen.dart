import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/blocs/cart_bloc.dart';
import 'package:flutter_cart/models/product.dart';
import 'package:flutter_cart/screens/cart_screen.dart';
import 'package:flutter_cart/widgets/quantity_input_modal.dart';
import 'package:intl/intl.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final void Function(int quantity) onAddToCart;
  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool isIncrementPressed = false;
  bool isDecrementPressed = false;

  Future<void> _showQuantityInputModal() async {
    final newQuantity = await showDialog(
      context: context,
      builder: (context) => ProductQuantityModal(
          initialQuantity: quantity, productName: widget.product.name),
    );

    if (newQuantity != null) {
      setState(() {
        quantity = newQuantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final priceFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: const Text(
          'Product Detail', 
          style: TextStyle(
            color: Colors.white
            ),
          ),
        actions: [
          BlocBuilder<CartBloc, CartState>(builder: (context, state) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
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
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hình ảnh sản phẩm
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: widget.product.imageUrl.startsWith('http')
                        ? Image.network(
                            widget.product.imageUrl,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            widget.product.imageUrl,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                      ),
                    ),
                    const SizedBox(height: 16),
            
                    // Tên sản phẩm
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
            
                    // Giá sản phẩm
                    Text(
                      priceFormat.format(widget.product.price),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            
                    const SizedBox(height: 10),
                    // Mô tả sản phẩm (dữ liệu test)
                    const Text(
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'
                      'It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, '
                      'and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Nút tăng giảm số lượng và thêm giỏ hàng
         
               Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tăng giảm số lượng
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 190, 189, 189),
                        ),
                        borderRadius: BorderRadius.circular(4)),
                      child: IconButton(
                        iconSize: 16,
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: _showQuantityInputModal,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                        child: Text(
                          quantity.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 190, 189, 189),
                        ),
                        borderRadius: BorderRadius.circular(4)),
                      child: IconButton(
                        iconSize: 16,
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 40),
                    // Nút thêm giỏ hàng
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onAddToCart(quantity);
                          // Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Add to cart',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
