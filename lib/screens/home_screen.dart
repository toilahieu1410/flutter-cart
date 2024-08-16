import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/blocs/cart_bloc.dart';
import 'package:flutter_cart/models/product.dart';
import 'package:flutter_cart/screens/cart_screen.dart';
import 'package:flutter_cart/widgets/bottom_sheet_quantity_selector.dart';
import 'package:flutter_cart/widgets/product_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Product> products = [];
  bool isLoadingMore = false;
  int currentPage = 1; // Lưu trữ trang hiện tại
  final int pageSize = 10; // Số lượng sản phẩm mỗi lần tải

  @override
  void initState() {
    super.initState();
    _loadProducts(isRefresh: true); // Tải sản phẩm lần đầu tiên
    _scrollController.addListener(() {
      if(_scrollController.position.extentAfter < 500 && !isLoadingMore) {
        _loadMoreProducts(); // Tải thêm sản phẩm khi cuộn gần cuối danh sách
      }
    });
  }

  // Chỗ này mình làm thành 2 kiểu: 
  // - Trường hợp 1: đủ sản phẩm ( 9 sản phẩm ), thì mình hiển thị đủ sẽ không cần load thêm sản phẩm => hiển thị đủ 9 sản phẩm
  // - Trường hợp 2: mình comment ở dòng 49-50: Mình dùng vòng for để lặp 50 items => khi đó sẽ thỏa mãn điểu kiện ( vì sẽ hiển thị 10 sản phẩm ban đầu và khi scroll xuống sẽ load 10 sản phẩm 1 lần)
  // Vì ở trường hợp 2 mình dùng vòng for tăng dần nên hình ảnh từ product_10 trở đi là không có => mình làm để test đúng điều kiện thôi
  
  // => Nếu đúng điều kiện thì chỉ cần mở comemnt vòng lặp for và đóng comment list 9 items => thỏa mãn điều kiện
  final List<Product> allProducts = [
    Product(id: 1, name: 'Product #1', imageUrl: 'assets/images/product_1.jpg', price: 10000),
    Product(id: 2, name: 'Product #2', imageUrl: 'assets/images/product_2.jpg', price: 20000),
    Product(id: 3, name: 'Product #3', imageUrl: 'assets/images/product_3.jpg', price: 30000),
    Product(id: 4, name: 'Product #4', imageUrl: 'assets/images/product_4.jpg', price: 40000),
    Product(id: 5, name: 'Product #5', imageUrl: 'assets/images/product_5.jpg', price: 50000),
    Product(id: 6, name: 'Product #6', imageUrl: 'assets/images/product_6.jpg', price: 60000),
    Product(id: 7, name: 'Product #7', imageUrl: 'assets/images/product_7.jpg', price: 70000),
    Product(id: 8, name: 'Product #8', imageUrl: 'assets/images/product_8.jpg', price: 80000),
    Product(id: 9, name: 'Product #9', imageUrl: 'assets/images/product_9.jpg', price: 90000),
  ];

//  final List<Product> allProducts = [
//     for (var i = 1; i <= 50; i++) 
//       Product(id: i, name: 'Product #$i', imageUrl: 'assets/images/product_$i.jpg', price: 10000 * i),
//   ];

  Future<void> _loadProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      setState(() {
        currentPage = 1; 
        products.clear(); // Xóa danh sách sản phẩm hiện tại khi làm mới
      });
    }

    // Giả lập việc tải dữ liệu từ server
    await Future.delayed(const Duration(seconds: 2), () {
      final startIndex = (currentPage - 1) * pageSize;
      if (startIndex >= allProducts.length) return; // Nếu không còn sản phẩm nào nữa, dừng lại.
      final newProduct = allProducts.skip(startIndex).take(pageSize).toList();

      if(mounted) {
        setState(() {
          products.addAll(newProduct); //Thêm sản phẩm mới vào danh sách hiện tại
          currentPage++; // Tăng trang hiện tại lên để tải trang tiếp
        });
      }
    });
  }

  Future<void> _loadMoreProducts() async {
    if (isLoadingMore || products.length >= allProducts.length) return;

    setState(() {
      isLoadingMore = true;
    });

    await _loadProducts();

    setState(() {
      isLoadingMore = false;
      });
    }
 
  Future<void> _refreshProducts() async {
    await _loadProducts(isRefresh: true); // Tải lại sp từ đầu khi pull-to-refresh
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final hotProductItemCount = isTablet ? 4.5 : 2.5;
    final allProductItemCount = isTablet ? 4 : 2;

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
                  )
              ],
            );
          }),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: ListView(
          controller: _scrollController ,
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
            // Hiển thị sản phẩm hot
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / hotProductItemCount,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: ProductTile(
                              product: product,
                              showHotIcon: true,
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
              padding: EdgeInsets.all(12.0),
              child: Text('All Products', 
              style: TextStyle(
                fontSize: 18, 
                color:Colors.orange
                ),
              ),
            ),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: allProductItemCount.toInt(),
              childAspectRatio: MediaQuery.of(context).size.width /
                (MediaQuery.of(context).size.height / 1.6),
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                return SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ProductTile(
                      product: product, 
                      imageHeight: 180,
                      onAddToCart: () {
                        showModalBottomSheet(
                          context: context, 
                          builder: (_) => QuantitySelectorBottomSheet(
                            product: product, 
                            onAddToCart: (quantity) {
                              context.read<CartBloc>().add(
                                AddToCartEvent(product, quantity)
                              );
                            }
                          ),
                        );
                      }
                    ),
                  ),
                );
              },
            ),
            if (isLoadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
  }


