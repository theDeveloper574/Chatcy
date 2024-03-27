import 'package:chatcy/screens/chat_view.dart';
import 'package:chatcy/screens/invite_users_screen.dart';
import 'package:chatcy/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';

import '../../screens/contacts_view.dart';
import '../../screens/delete_status_view.dart';
import '../../screens/home_settings_view.dart';
import '../../screens/home_view.dart';
import '../../screens/login_view.dart';
import '../../screens/my_profile_view.dart';
import '../../screens/sign_up_view.dart';
import '../../screens/splash_view.dart';
import '../../screens/user_profile_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.signUp:
        return MaterialPageRoute(builder: (context) => const SignUpView());
      case RouteName.logIn:
        return MaterialPageRoute(builder: (context) => const LogInView());
      case RouteName.home:
        return MaterialPageRoute(builder: (context) => HomeView());
      case RouteName.contact:
        return MaterialPageRoute(builder: (context) => const ContactView());
      // case RouteName.singleChatView:
      //   return MaterialPageRoute(builder: (context) => const SingleChatView());
      case RouteName.userProfileView:
        return MaterialPageRoute(builder: (context) => const UserProfileView());
      // case RouteName.callInfoView:
      //   return MaterialPageRoute(builder: (context) => const CallInfoView());
      case RouteName.homeSettingsView:
        return MaterialPageRoute(builder: (context) => HomeSettingsView());
      case RouteName.myProfileView:
        return MaterialPageRoute(builder: (context) => const MyProfileView());

      case RouteName.userContactsView:
        return MaterialPageRoute(
            builder: (context) => const InviteUsersScreen());
      case RouteName.deleteStatus:
        return MaterialPageRoute(
            builder: (context) => const DeleteStatusView());
      case RouteName.splash:
        return MaterialPageRoute(builder: (context) => const SplashView());
      // case RouteName.newChatView:
      // return MaterialPageRoute(builder: (context) => const NewChatView());
      case RouteName.newChatViewNotifi:
        return MaterialPageRoute(
          builder: (_) => HomeView(
            index: 1,
            screenNav: const ChatView(),
          ),
        );
      default:
        return MaterialPageRoute(builder: (context) {
          return const Scaffold(
            body: Center(child: Text("no route defined")),
          );
        });
    }
  }
}
