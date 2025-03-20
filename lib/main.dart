import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/Core/resources_manager/app_colors.dart';
import 'package:to_do_app/features/addtask/manager/get_task_cubit/get_tasks_cubit.dart';
import 'package:to_do_app/features/start/views/logo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GetTasksCubit()..getTasks()),
      ],
      child: MaterialApp(
        color: MyColors.backgroundColor,
        debugShowCheckedModeBanner: false,
        title: 'To_Do_App',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const SplashPage(),
      ),
    );
  }
}

