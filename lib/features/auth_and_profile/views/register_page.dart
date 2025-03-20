import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:to_do_app/Core/resources_manager/app_colors.dart';
import 'package:to_do_app/Core/resources_manager/app_images.dart';
import 'package:to_do_app/core/resources_manager/app_strings.dart';
import 'package:to_do_app/core/widgets/image_manager/image_manager_view.dart';
import 'package:to_do_app/core/widgets/my_text_button.dart';
import 'package:to_do_app/core/widgets/my_text_form_field.dart';
import 'package:to_do_app/features/auth_and_profile/manager/register_cubit/register_cubit.dart';
import 'package:to_do_app/features/auth_and_profile/manager/register_cubit/register_state.dart';
import 'package:to_do_app/features/auth_and_profile/views/login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: Builder(
        builder: (context) {
          final registerCubit = RegisterCubit.get(context);
          final confirmPassController = TextEditingController();
          
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Form(
                  key: registerCubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageManagerView(
                        onSelected: (XFile image) {
                          // Save the selected image to the cubit
                          registerCubit.setProfileImage(image);
                        },
                        selectedImageBuilder: (XFile image) {
                          return Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              image: DecorationImage(
                                image: FileImage(File(image.path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CircleAvatar(
                                    backgroundColor: MyColors.green.withOpacity(0.7),
                                    radius: 24,
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        unSelectedImageBuilder: () {
                          return Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              image: const DecorationImage(
                                image: AssetImage(MyImages.palastine),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CircleAvatar(
                                    backgroundColor: MyColors.green.withOpacity(0.7),
                                    radius: 24,
                                    child: const Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              MyAppStrings.register,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Create your account to get started",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      
                      MyTextFormField(
                        validator: (String? text) {
                          if (text == null || text.isEmpty) {
                            return 'Username must not be empty';
                          }
                          if (text.length < 4) {
                            return 'Username must be at least 4 characters';
                          }
                          return null;
                        },
                        top: 5,
                        controller: registerCubit.username,
                        maxlines: 1,
                        hinttext: MyAppStrings.namehint,
                        labeltext: MyAppStrings.name,
                      ),
                      
                      MyTextFormField(
                        validator: (String? textpass) {
                          if (textpass == null || textpass.isEmpty) {
                            return 'Password must not be empty';
                          }
                          if (textpass.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        controller: registerCubit.password,
                        maxlines: 1,
                        hinttext: MyAppStrings.passwordhint,
                        labeltext: MyAppStrings.password,
                      ),
                      
                      MyTextFormField(
                        validator: (String? textcon) {
                          if (textcon == null || textcon.isEmpty) {
                            return 'Confirm password must not be empty';
                          }
                          if (textcon != registerCubit.password.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        controller: confirmPassController,
                        maxlines: 1,
                        hinttext: MyAppStrings.confirmpasshint,
                        labeltext: MyAppStrings.confirmpass,
                      ),
                      
                      const SizedBox(height: 30),
                      
                      BlocConsumer<RegisterCubit, RegisterState>(
                        builder: (context, state) {
                          if (state is RegisterLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: MyTextButton(
                              onpressed: () {
                                if (registerCubit.formKey.currentState?.validate() ?? false) {
                                  registerCubit.onRegister();
                                }
                              },
                              offsety: 4,
                              shadowcolor: MyColors.gray,
                              buttontext: MyAppStrings.register.toUpperCase(),
                              newscreen: LoginPage(),
                            ),
                          );
                        },
                        listener: (context, state) {
                          if (state is RegisterSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.msg),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          } else if (state is RegisterError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 20),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(MyAppStrings.haveacc),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              MyAppStrings.login,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: MyColors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}