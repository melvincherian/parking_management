// ignore_for_file: await_only_futures

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_management/features/presentation/bloc/bloc/authentication_bloc.dart';
import 'package:parking_management/features/presentation/bloc/bloc/slot_bloc.dart';
import 'package:parking_management/features/presentation/provider/bottom_navbar.dart';
import 'package:parking_management/features/presentation/screens/login_screen.dart';
import 'package:parking_management/firebase/auth_repository.dart';
import 'package:parking_management/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
              create: (context) =>
                  AuthenticationBloc(authrepository: AuthRepository())),
          BlocProvider<SlotBloc>(create: (context) => SlotBloc())
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<BottomNavbarprovider>(
                create: (_) => BottomNavbarprovider())
          ],
          child:const MaterialApp(
            home: LoginScreen(),
            debugShowCheckedModeBanner: false,
          ),
        ));
  }
}
