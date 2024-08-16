import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add item to cart and check cart screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Nhấn vào nút thêm vào giỏ hàng cho sản phẩm đầu tiên
    await tester.tap(find.text('Add to cart').first);
    await tester.pumpAndSettle();

    // Nhấn vào biểu tượng giỏ hàng
    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();

    // Kiểm tra xem sản phẩm đã được thêm vào giỏ hàng
    expect(find.text('Product #1'), findsOneWidget);
  });
}