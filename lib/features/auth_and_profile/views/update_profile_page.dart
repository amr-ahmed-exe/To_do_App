import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/Core/resources_manager/app_colors.dart';
import 'package:to_do_app/Core/resources_manager/app_images.dart';
import 'package:to_do_app/core/resources_manager/app_strings.dart';
import 'package:to_do_app/core/widgets/my_text_form_field.dart';
import 'package:to_do_app/features/auth_and_profile/manager/update_cubit/update_cubit.dart';
import 'package:to_do_app/features/auth_and_profile/manager/update_cubit/update_state.dart';
import 'package:to_do_app/features/home/views/new_home_page.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateCubit(),
      child: Scaffold(
        body: Builder(
          builder: (context) {
            final updateCubit = BlocProvider.of<UpdateCubit>(context);
            return Form(
              key: updateCubit.formKey,
              child: SingleChildScrollView(
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
                    const SizedBox(height: 50),
                    MyTextFormField(
                      controller: updateCubit.username,
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
                    const SizedBox(height: 20),
                    BlocConsumer<UpdateCubit, UpdateState>(
                      listener: (context, state) {
                        if (state is UpdateSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.msg),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewHomepage(),
                            ),
                          );
                        } else if (state is UpdateError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is UpdateLoading) {
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
                                color: MyColors.gray2.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: TextButton(
                            onPressed: () {
                              updateCubit.upDate();
                            },
                            child: Text(
                              MyAppStrings.save,
                              style: const TextStyle(
                                color: MyColors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}