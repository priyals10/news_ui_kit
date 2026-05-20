import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart' as picker;

import 'package:news_ui_kit/features/splash/splash_screen.dart';
import 'package:news_ui_kit/features/onboarding/onboarding_screen.dart';
import 'package:news_ui_kit/features/auth/login/login_screen.dart';
import 'package:news_ui_kit/features/auth/signup/signup_screen.dart';
import 'package:news_ui_kit/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:news_ui_kit/features/auth/otp/otp_verification_screen.dart';
import 'package:news_ui_kit/features/auth/reset_password/reset_password_screen.dart';
import 'package:news_ui_kit/features/auth/success/reset_success_screen.dart';
import 'package:news_ui_kit/features/home/select_country/select_country_screen.dart';
import 'package:news_ui_kit/features/home/topics/choose_topics_screen.dart';
import 'package:news_ui_kit/features/home/news_sources/choose_news_sources_screen.dart';
import 'package:news_ui_kit/features/home/fill_profile/fill_profile_screen.dart';
import 'package:news_ui_kit/features/home/presentation/main_screen.dart';
import 'package:news_ui_kit/features/home/presentation/trending_screen.dart';
import 'package:news_ui_kit/features/home/presentation/article_detail_screen.dart';
import 'package:news_ui_kit/features/home/presentation/latest_screen.dart';
import 'package:news_ui_kit/features/home/presentation/search_screen.dart';
import 'package:news_ui_kit/features/home/presentation/edit_profile_screen.dart';
import 'package:news_ui_kit/features/home/presentation/settings_screen.dart';
import 'package:news_ui_kit/features/home/domain/entities/news_article.dart';
import 'package:news_ui_kit/features/auth/domain/entities/user.dart';
import 'package:news_ui_kit/features/home/data/models/user_news_model.dart';
import 'package:news_ui_kit/features/home/presentation/create_news_screen.dart';
import 'package:news_ui_kit/features/auth/success/welcome_success_screen.dart';

class AppRouter {
  AppRouter._();

  // Route names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String resetPassword = '/reset-password';
  static const String resetSuccess = '/reset-success';
  static const String selectCountry = '/select-country';
  static const String chooseTopics = '/choose-topics';
  static const String chooseNewsSources = '/choose-news-sources';
  static const String fillProfile = '/fill-profile';
  static const String home = '/home';
  static const String trending = '/trending';
  static const String articleDetail = '/article-detail';
  static const String latest = '/latest';
  static const String searchNews = '/search-news';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String createNews = '/create-news';
  static const String welcome = '/welcome';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(const SplashScreen());

      case onboarding:
        return _buildRoute(const OnboardingScreen());

      case login:
        return _buildRoute(const LoginScreen());

      case signup:
        return _buildRoute(const SignupScreen());

      case forgotPassword:
        return _buildRoute(const ForgotPasswordScreen());

      case otpVerification:
        final contact = settings.arguments as String;
        return _buildRoute(OtpVerificationScreen(contact: contact));

      case resetPassword:
        return _buildRoute(const ResetPasswordScreen());

      case resetSuccess:
        return _buildRoute(const ResetSuccessScreen());

      case selectCountry:
        return _buildRoute(const SelectCountryScreen());

      case chooseTopics:
        final country = settings.arguments as picker.Country;
        return _buildRoute(ChooseTopicsScreen(selectedCountry: country));

      case chooseNewsSources:
        return _buildRoute(const ChooseNewsSourceScreen(), settings: settings);

      case fillProfile:
        return _buildRoute(const FillProfileScreen(), settings: settings);

      case home:
        return _buildRoute(const MainScreen());

      case trending:
        final articles = settings.arguments as List<NewsArticle>;
        return _buildRoute(TrendingScreen(articles: articles));

      case articleDetail:
        final article = settings.arguments as NewsArticle;
        return _buildRoute(ArticleDetailScreen(article: article));

      case latest:
        return _buildRoute(const LatestScreen());

      case searchNews:
        return _buildRoute(const SearchScreen());

      case editProfile:
        final user = settings.arguments as User;
        return _buildRoute(EditProfileScreen(user: user));

      case AppRouter.settings:
        return _buildRoute(const SettingsScreen());

      case createNews:
        final existingNews = settings.arguments as UserNewsModel?;
        return _buildRoute(CreateNewsScreen(existingNews: existingNews));

      case AppRouter.welcome:
        return _buildRoute(const WelcomeSuccessScreen());

      default:
        return _buildRoute(const SplashScreen());
    }
  }

  static MaterialPageRoute _buildRoute(Widget page, {RouteSettings? settings}) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }
}
