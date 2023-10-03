import 'package:e_catalog/bloc/add_product/add_product_bloc.dart';
import 'package:e_catalog/bloc/cubit/product_update_cubit.dart';
import 'package:e_catalog/bloc/login/login_bloc.dart';
import 'package:e_catalog/bloc/register/register_bloc.dart';
import 'package:e_catalog/bloc/update_product/update_product_bloc.dart';
import 'package:e_catalog/data/datasources/auth_datasource.dart';
import 'package:e_catalog/data/datasources/product_datasource.dart';
import 'package:e_catalog/presentation/login_page.dart';
import 'package:e_catalog/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/products/products_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(AuthDataSource()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(AuthDataSource()),
        ),
        BlocProvider(
          create: (context) => ProductsBloc(ProductDataSource()),
        ),
        BlocProvider(
          create: (context) => AddProductBloc(ProductDataSource()),
        ),
        BlocProvider(
          create: (context) => UpdateProductBloc(ProductDataSource()),
        ),
        BlocProvider(
          create: (context) => ProductUpdateCubit(ProductDataSource()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light.copyWith(useMaterial3: true),
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
        home: const LoginPage(),
      ),
    );
  }
}
