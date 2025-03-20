import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/Core/resources_manager/app_images.dart';
import 'package:to_do_app/core/resources_manager/app_colors.dart';
import 'package:to_do_app/core/resources_manager/app_strings.dart';
import 'package:to_do_app/core/widgets/my_text_form_field.dart';
import 'package:to_do_app/features/addtask/manager/add_task_cubit/add_task_cubit.dart';
import 'package:to_do_app/features/addtask/manager/add_task_cubit/add_task_state.dart';
import 'package:to_do_app/features/addtask/manager/get_task_cubit/get_tasks_cubit.dart';
import 'package:to_do_app/features/home/views/new_home_page.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddTaskCubit(),
      child: Builder(
        builder: (context) {
          final addTaskCubit = AddTaskCubit.get(context);
          final formKey = GlobalKey<FormState>();
          
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(MyAppStrings.addtasktitle),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: 261,
                      height: 207,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage(MyImages.palastine),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    MyTextFormField(
                      validator: (String? title) {
                        if (title == null || title.trim().isEmpty) {
                          return "Title can't be empty";
                        }
                        return null;
                      },
                      controller: addTaskCubit.title,
                      maxlines: 1,
                      hinttext: MyAppStrings.titlehint,
                      labeltext: MyAppStrings.title,
                      // Remove prefixIcon if your MyTextFormField doesn't support it
                    ),
                    MyTextFormField(
                      validator: (String? description) {
                        if (description == null || description.trim().isEmpty) {
                          return "Description can't be empty";
                        }
                        return null;
                      },
                      controller: addTaskCubit.describtion,
                      maxlines: 3, // Changed to multiline for description
                      hinttext: MyAppStrings.descriptionhint,
                      labeltext: MyAppStrings.description,
                      top: 10, // Add spacing between fields
                      // Remove prefixIcon if your MyTextFormField doesn't support it
                    ),
                    const SizedBox(height: 30),
                    BlocConsumer<AddTaskCubit, AddTaskState>(
                      listener: (context, state) {
                        if (state is AddTaskSucsses) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Task added successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          GetTasksCubit.get(context).getTasks();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const NewHomepage()),
                          );
                        } else if (state is AddTaskError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Container(
                          width: 331,
                          height: 48,
                          margin: const EdgeInsets.symmetric(horizontal: 22),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: MyColors.gray.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(14),
                            color: MyColors.green,
                          ),
                          child: TextButton(
                            onPressed: state is AddTaskLoading 
                              ? null 
                              : () {
                                  if (formKey.currentState?.validate() ?? false) {
                                    addTaskCubit.addTask();
                                  }
                                },
                            style: TextButton.styleFrom(
                              foregroundColor: MyColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: state is AddTaskLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  MyAppStrings.addtasktitle,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}