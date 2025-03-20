import 'package:flutter/material.dart';
import 'package:to_do_app/Core/resources_manager/app_icons.dart';
import 'package:to_do_app/core/widgets/custom_appbar.dart';
import 'package:to_do_app/core/widgets/profile_container.dart';
import 'package:to_do_app/features/auth_and_profile/views/change_password.dart';
import 'package:to_do_app/features/auth_and_profile/views/update_profile_page.dart';
import 'package:to_do_app/features/settings/views/settings_page.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),

      body: Column(
        children: [
          ProfileContainer(
            icon1p: Myicons.profile,
            textp: '   Update Profile',
            nextscreen: UpdateProfilePage(),
          ),
          ProfileContainer(
            icon1p: Myicons.lock,
            textp: "    Chagce Password",
            nextscreen: ChangePasswordPage(),
          ),
          ProfileContainer(
            icon1p: Myicons.setting,
            textp: "    Settings",
            nextscreen: Settingspage(),
          ),
        ],
      ),
    );
  }
}
