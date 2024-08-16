import 'package:flutter/material.dart';

class ProductQuantityModal extends StatefulWidget {
  final int initialQuantity;
  final String productName;
  // final String product;
  // constructor cho widget , nhận vào giá trị số lượng ban đầu
  const ProductQuantityModal({
    super.key,
    required this.initialQuantity,
    required this.productName, 
  });

  @override
  _ProductQuantityModalState createState() => _ProductQuantityModalState();
}

// quản lý trạng thái của modal
class _ProductQuantityModalState extends State<ProductQuantityModal> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  bool _isSubmit = false;

// Hàm khởi tạo (initState) được gọi khi widget được khởi tạo.
  @override
  void initState() {
    super.initState();
    _quantityController.text = widget.initialQuantity.toString();
  }

  // Hàm dispose được gọi khi widget bị hủy bỏ để giải phóng tài nguyên.
  @override
  void dispose() {
    // Giải phóng controller khi không cần thiết nữa.
    _quantityController.dispose();
    super.dispose();
  }

  // Hàm kiểm tra giá trị nhập vào và gửi lại kết quả khi hợp lệ
  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      // Nếu form hợp lệ => đóng modal và trả về giá trị số lượng
      Navigator.pop(context, int.parse(_quantityController.text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.productName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _quantityController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final quantity = int.tryParse(value ?? '');
                  if (quantity == null || quantity <= 0) {
                    return 'Nhập giá trị vào';
                  } else if (quantity > 999) {
                    return 'Quantity cannot exceed 999';
                  } else {
                    return null; // hợp lệ
                  }
                },
                onChanged: (value) {
                  // Cập nhật trạng thái của submit mỗi khi giá trị thay đổi
                  setState(() {
                    _isSubmit = !_formKey.currentState!.validate();
                  });
                },
              ),
              const SizedBox(height: 20),

              // Tạo nút submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmit ? null : _validateAndSubmit,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _isSubmit ? Colors.grey : Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
