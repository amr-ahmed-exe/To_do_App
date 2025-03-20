import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/Core/resources_manager/app_colors.dart';
import 'package:to_do_app/Core/resources_manager/app_images.dart';
import 'package:to_do_app/core/resources_manager/app_strings.dart';
import 'package:to_do_app/core/widgets/my_text_form_field.dart';
import 'package:to_do_app/features/auth_and_profile/manager/login_cubit/login_cubit.dart';
import 'package:to_do_app/features/auth_and_profile/views/register_page.dart';
import 'package:to_do_app/features/home/views/home_page_before_adding_task.dart';

import '../manager/login_cubit/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Builder(
            builder: (context) {
              final loginCubit = BlocProvider.of<LoginCubit>(context);
              return Form(
                key: loginCubit.formKey,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 298,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        image: DecorationImage(
                          image: AssetImage(MyImages.palastine),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    MyTextFormField(
                      top: 23,
                      controller: loginCubit.username,
                      maxlines: 1,
                      hinttext: MyAppStrings.namehint,
                      labeltext: MyAppStrings.name,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Username must not be empty';
                        } else if (text.length < 4) {
                          return 'Username must be at least 4 characters long';
                        }
                        return null;
                      },
                    ),
                    MyTextFormField(
                      controller: loginCubit.password,
                      maxlines: 1,
                      hinttext: MyAppStrings.passwordhint,
                      labeltext: MyAppStrings.password,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Password must not be empty';
                        } else if (text.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state is LoginSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Login Success')),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeBeforTasks(),
                            ),
                          );
                        } else if (state is LoginError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.error)),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is LoginLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 48,
                          margin: const EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                            color: MyColors.green,
                            boxShadow: [
                              BoxShadow(
                                color: MyColors.gray.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextButton(
                            onPressed: () {
                              loginCubit.onloginPressed();
                            },
                            child: Text(
                              MyAppStrings.login.toUpperCase(),
                              style: const TextStyle(color: MyColors.white),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(MyAppStrings.nohaveacc),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: Text(
                            MyAppStrings.register,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}