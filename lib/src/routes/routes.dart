import 'dart:core';
import 'package:flutter/material.dart';
import 'package:futgolazo/src/models/resume_book.model.dart';
import 'package:futgolazo/src/pages/my_results/my_results.page.dart';
import 'package:futgolazo/src/pages/plays/pages/plays.page.dart';
import 'package:futgolazo/src/pages/settings/settings.page.dart';

import 'package:get_it/get_it.dart';

import '../models/book.model.dart';
import '../services/pool_services.dart';

import '../pages/signin/signin.dart';
import '../pages/signup/welcome.dart';
import '../pages/home/home_page.dart';
import '../pages/signup/sign_up.dart';
import '../pages/loading/loading.dart';
import '../pages/error/error_page.dart';
import '../pages/signin/signin_menu.dart';
import '../pages/my_books/my_books.page.dart';
import '../pages/select_team/select_team.dart';
import '../pages/game_menu/game_menu_page.dart';
import '../pages/signup/signup_buttons_menu.dart';
import '../pages/simple_signin/simple_signin.dart';
import '../pages/start_menu_page/start_menu_page.dart';
import '../pages/onboarding_page/onboarding_page_view.dart';
import '../pages/recover_password/recover_password_page.dart';
import '../pages/accept_requirements/accept_requirements.dart';
import '../pages/mini_card/pages/mini_card_play/mini_card.dart';
import '../pages/mini_card/pages/mini_card_pay/pay_mini_card.page.dart';
import '../pages/mini_card/pages/mini_card_info/mini_card_info.page.dart';
import '../pages/mini_card/pages/mini_card_list/mini_card_list.page.dart';
import '../pages/simple_signin/terms_conditions_page/terms_politics_page.dart';
import '../pages/mini_card/pages/mini_card_preview/mini_card_preview.page.dart';
import '../pages/mini_card/pages/mini_card_sent_success/mini_card_sent_success.dart';

class NavigationRoute {
  static const String HOME = "/home";
  static const String SHOP = "/shop";
  static const String ERROR = "/error";
  static const String PLAYS = "/plays";
  static const String INTRO = "/intro";
  static const String SIGNIN = "/singin";
  static const String SIGNUP = "/signup";
  static const String WELCOME = "/welcome";
  static const String LOADING = "/loading";
  static const String SETTINGS = "/settings";
  static const String MINI_CARD = "/mini_card";
  static const String GAME_MENU = "/game-menu";
  static const String USER_TEAM = "/user_team";
  static const String START_MENU = "/start-menu";
  static const String SIGNIN_MENU = "/signin-menu";
  static const String MY_BOOKS = "/results_my_Cards";
  static const String MY_RESULTS = "/my_results";
  static const String MINI_CARD_PAY = "/mini_card_pay";
  static const String SIMPLE_SIGNIN = "/simple_singin";
  static const String MINI_CARD_INFO = "/mini_card_info";
  static const String MINI_CARD_LIST = "/mini_card_list";
  static const String MINI_CARD_PREVIEW = "/mini_card_preview";
  static const String MINI_CARD_SENT_SUCCESS = "/mini_card_sent_success";

  static const String TERMS_POLITICS = '/terms_politics';
  static const String RECOVER_PASSWORD = "/recover_password";
  static const String SIGNUP_BUTTONS_MENU = "/signup-btns-menu";
  static const String ACCEPT_REQUIREMENTS = "/accept_requirements";
}

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    final List<String> pathElements = settings.name.split('/');
    final gas = GetIt.I<PoolServices>().googleAnalyticsServices;
    if (pathElements[1] == '') {
      return null;
    }
    gas.setCurrentScreen(settings.name);

    switch (settings.name) {
      case NavigationRoute.INTRO:
        return MaterialPageRoute(builder: (context) => OnboardingPageView());
        break;
      case NavigationRoute.HOME:
        return MaterialPageRoute(builder: (context) => HomePage());
        break;
      case NavigationRoute.SIGNIN:
        return MaterialPageRoute(builder: (context) => SignIn());
        break;
      case NavigationRoute.USER_TEAM:
        return MaterialPageRoute(builder: (context) => SelectTeam());
        break;
      case NavigationRoute.MINI_CARD:
        return MaterialPageRoute(builder: (context) => MiniCardPlay());
        break;
      case NavigationRoute.MINI_CARD_PAY:
        return MaterialPageRoute(builder: (context) => PayMiniCard());
        break;
      case NavigationRoute.MINI_CARD_PREVIEW:
        return MaterialPageRoute(builder: (context) => MiniCardPreviewPage());
        break;
      case NavigationRoute.MY_BOOKS:
        Map arguments = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (context) => MyBooksPage(
            resumeBookModel: arguments['resumeBookModel'],
            myBooksBloc: arguments['myBooksBloc'],
          ),
        );
        break;
      case NavigationRoute.MY_RESULTS:
        ResumeBookModel resumeBookModel = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => MyresultsPage(
            resumeBookModel: resumeBookModel,
          ),
        );
        break;
      case NavigationRoute.MINI_CARD_SENT_SUCCESS:
        return MaterialPageRoute(builder: (context) => MiniCardSentSuccess());
        break;
      case NavigationRoute.SIGNUP:
        Map<String, dynamic> params = settings.arguments ?? {};
        return MaterialPageRoute(
          builder: (context) => SignUp(
            page: params['page'],
          ),
        );
        break;
      case NavigationRoute.WELCOME:
        return MaterialPageRoute(builder: (context) => WelcomePage());
        break;
      case NavigationRoute.START_MENU:
        return MaterialPageRoute(builder: (context) => StartMenuPage());
        break;
      case NavigationRoute.LOADING:
        return MaterialPageRoute(builder: (context) => Loading());
        break;
      case NavigationRoute.SETTINGS:
        return MaterialPageRoute(builder: (context) => SettingsPage());
        break;
      case NavigationRoute.MINI_CARD_LIST:
        return MaterialPageRoute(builder: (context) => MiniCardListPage());
        break;
      case NavigationRoute.MINI_CARD_INFO:
        BookModel params = settings.arguments;
        return MaterialPageRoute(
          builder: (context) => MiniCardInfoPage(
            book: params,
          ),
        );
      case NavigationRoute.GAME_MENU:
        return MaterialPageRoute(builder: (context) => GameMenuPage());
        break;
      case NavigationRoute.SIMPLE_SIGNIN:
        return MaterialPageRoute(builder: (context) => SimpleSignin());
        break;
      case NavigationRoute.SIGNIN_MENU:
        return MaterialPageRoute(builder: (context) => SigninMenu());
        break;
      case NavigationRoute.PLAYS:
        return MaterialPageRoute(builder: (context) => PlaysPage());
        break;
      case NavigationRoute.SIGNUP_BUTTONS_MENU:
        return MaterialPageRoute(builder: (context) => SignupButtonsMenu());
        break;
      case NavigationRoute.TERMS_POLITICS:
        return MaterialPageRoute(
            builder: (context) => TermsPoliticsPage(settings.arguments));
        break;
      case NavigationRoute.ACCEPT_REQUIREMENTS:
        return MaterialPageRoute(builder: (context) => AcceptRequiriments());
        break;
      case NavigationRoute.RECOVER_PASSWORD:
        return MaterialPageRoute(builder: (context) => RecoverPasswordPage());
        break;
      default:
        return MaterialPageRoute(builder: (context) => ErrorPage());
        break;
    }
  }
}
