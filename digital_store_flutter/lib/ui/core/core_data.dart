import 'package:digital_store_flutter/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CoreData {
  final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) => WelcomePage(
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/registerPage',
        builder: (BuildContext context, GoRouterState state) => RegisterPage(
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/loginPage',
        builder: (BuildContext context, GoRouterState state) => LoginPage(
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/forgotPasswordPage',
        builder: (BuildContext context, GoRouterState state) =>
            ForgotPasswordPage(
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/verificationPage',
        builder: (BuildContext context, GoRouterState state) =>
            VerificationPage(
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/resetPasswordPage',
        builder: (BuildContext context, GoRouterState state) =>
            ResetPasswordPage(
          key: state.pageKey,
        ),
      ),
      GoRoute(
        path: '/changedPasswordPage',
        builder: (BuildContext context, GoRouterState state) =>
            ChangedPasswordPage(
          key: state.pageKey,
        ),
      ),
    ],
  );
}
