import 'package:e_catalog/data/datasources/local_datasource.dart';
import 'package:e_catalog/data/models/request/login_request_model.dart';
import 'package:e_catalog/presentation/home_page.dart';
import 'package:e_catalog/presentation/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? emailC;
  TextEditingController? passwordC;

  @override
  void initState() {
    checkAuth(context);
    emailC = TextEditingController();
    passwordC = TextEditingController();
    super.initState();
  }

  void checkAuth(context) async {
    await Future.delayed(const Duration(seconds: 1));
    final auth = await LocalDataSource.getToken();
    if (auth.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
    }
  }

  @override
  void dispose() {
    emailC!.dispose();
    passwordC!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(child: Text('Login User')),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: passwordC,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(
              height: 16.0,
            ),
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                if (state is LoginLoaded) {
                  LocalDataSource.saveToken(state.model.accessToken);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Login sukses'),
                    backgroundColor: Colors.blue,
                  ));
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const HomePage();
                    },
                  ));
                }
              },
              builder: (context, state) {
                if (state is LoginLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ElevatedButton(
                  onPressed: () async {
                    final requestModel = LoginRequestModel(
                      email: emailC!.text,
                      password: passwordC!.text,
                    );
                    context.read<LoginBloc>().add(
                          DoLoginEvent(
                            model: requestModel,
                          ),
                        );
                  },
                  child: const Text('Login'),
                );
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterPage(),
                  ),
                );
              },
              child: const Text('Belum punya akun? register'),
            )
          ],
        ),
      ),
    );
  }
}
