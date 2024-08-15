// lib/widgets/bottom_sheet_quantity_selector.dart
import 'package:flutter/material.dart';
import 'package:flutter_cart/widgets/quantity_input_modal.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';

class QuantitySelectorBottomSheet extends StatefulWidget {
  final Product product;
  final void Function(int quantity) onAddToCart;

  const QuantitySelectorBottomSheet({
    Key? key,
    required this.product,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  _QuantitySelectorBottomSheetState createState() =>
      _QuantitySelectorBottomSheetState();
}

class _QuantitySelectorBottomSheetState
    extends State<QuantitySelectorBottomSheet> {
  int quantity = 1;

  void _updateQuantity(int value) {
    setState(() {
      quantity = value.clamp(1, 999);
    });
  }

  Future<void> _openQuantityInputDialog() async {
    final newQuantity = await showDialog<int>(
        context: context,
        builder: (context) => ProductQuantityModal(
              initialQuantity: quantity,
              productName: widget.product.name,
            ));
    if (newQuantity != null) {
      _updateQuantity(newQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Định dạng số tiền với dấu chấm phân cách hàng nghìn
    final priceFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0, // Không hiển thị phần thập phân
    );
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Thêm hình ảnh
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 16),

              // Thông tin sản phẩm
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                  icon: const Icon(Icons.remove),
                                  onPressed: () =>
                                      _updateQuantity(quantity - 1),
                                ),
                              ),

                              // Hiển thị số lượng
                              GestureDetector(
                                onTap: _openQuantityInputDialog,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  decoration: BoxDecoration(
                                      border: const Border(
                                        top: BorderSide(
                                            color: Color.fromARGB(
                                                255, 190, 189, 189)),
                                        bottom: BorderSide(
                                            color: Color.fromARGB(
                                                255, 190, 189, 189)),
                                        left: BorderSide
                                            .none, // Loại bỏ border ở bên trái
                                        right: BorderSide
                                            .none, // Loại bỏ border ở bên phải
                                      ),
                                      borderRadius: BorderRadius.circular(0)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      quantity.toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
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
                                  icon: const Icon(Icons.add),
                                  onPressed: () =>
                                      _updateQuantity(quantity + 1),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Giá tiền sản phẩm
                        Text(
                          priceFormat.format(widget.product.price * quantity),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onAddToCart(quantity);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 20),
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
    );
  }
}
