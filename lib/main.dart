import 'package:e_commerce_app/Constants/app_routes.dart';
import 'package:e_commerce_app/firebase_options.dart';
import 'package:e_commerce_app/utils/app_router.dart';
import 'package:e_commerce_app/view_model/auth_cubit/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = AuthCubit();
        cubit.checkAuthentication();
        return cubit;
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        buildWhen: (previous, current) =>
            current is AuthAuthenticated || current is AuthUnauthenticated,

        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'E-Commerce',
            onGenerateRoute: AppRouter.onGenerateRoute,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            initialRoute: state is AuthAuthenticated
                ? AppRoutes.home
                : AppRoutes.login,
          );
        },
      ),
    );
  }
}
