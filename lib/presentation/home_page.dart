import 'package:e_catalog/bloc/products/products_bloc.dart';
import 'package:e_catalog/data/datasources/local_datasource.dart';
import 'package:e_catalog/presentation/login_page.dart';
import 'package:e_catalog/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_product_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? titleC;
  TextEditingController? priceC;
  TextEditingController? descriptionC;

  final scrollC = ScrollController();

  @override
  void initState() {
    titleC = TextEditingController();
    priceC = TextEditingController();
    descriptionC = TextEditingController();
    super.initState();
    context.read<ProductsBloc>().add(GetProductEvent());
    scrollC.addListener(() {
      if (scrollC.position.maxScrollExtent == scrollC.offset) {
        context.read<ProductsBloc>().add(NextProductEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              await LocalDataSource.removeToken();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoaded) {
            debugPrint('total data: ${state.data.length}');

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                controller: scrollC,
                //reverse: true,
                itemBuilder: (context, index) {
                  if (state.isNext && index == state.data.length) {
                    return const Card(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return Card(
                    child: ListTile(
                      title:
                          Text(state.data.reversed.toList()[index].title ?? ''),
                      subtitle: Text('${state.data[index].price}\$'),
                    ),
                  );
                },
                itemCount:
                    state.isNext ? state.data.length + 1 : state.data.length,
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.theme.appColors.primary,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return const AddProductPage();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
