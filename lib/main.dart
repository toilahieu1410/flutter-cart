import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cart/blocs/cart_bloc.dart';
import 'package:flutter_cart/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartBloc(),
      child: MaterialApp(
        title: 'Shopping Cart',
         debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
