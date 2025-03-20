import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/features/auth_and_profile/data/repo/profile_repo.dart';
import 'package:to_do_app/features/auth_and_profile/manager/update_cubit/update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  UpdateCubit() : super(UpdateInit());

  final TextEditingController username = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  final ProfileRepo repo = ProfileRepo();

  void upDate() async {
    if (validate()) {
      emit(UpdateLoading());
      try {
        var response = await repo.update(username: username.text);

        response.fold(
          (error) {
            emit(UpdateError(error));
          },
          (result) {
            emit(UpdateSuccess(result!));
          },
        );
      } catch (e) {
        emit(UpdateError("An unexpected error occurred: ${e.toString()}"));
      }
    }
  }

  bool validate() {
    return formKey.currentState?.validate() ?? false;
  }

  @override
  Future<void> close() {
    username.dispose();
    return super.close();
  }
}