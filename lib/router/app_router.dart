import 'package:go_router/go_router.dart';

import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/movies/movie_form_screen.dart';
import '../screens/movies/movies_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/sessions/session_detail_screen.dart';
import '../screens/sessions/session_form_screen.dart';
import '../screens/sessions/sessions_screen.dart';
import '../screens/theaters/theater_form_screen.dart';
import '../screens/theaters/theaters_screen.dart';
import 'app_routes.dart';
import 'app_shell.dart';
import 'auth_notifier.dart';

final _authNotifier = AuthNotifier();

final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  refreshListenable: _authNotifier,
  redirect: (context, state) {
    final logado = _authNotifier.isLoggedIn;
    final loc = state.matchedLocation;
    final naAuth = loc == AppRoutes.login ||
        loc == AppRoutes.register ||
        loc == AppRoutes.forgotPassword;

    if (!logado && !naAuth) return AppRoutes.login; // deslogado: só telas de auth
    if (logado && naAuth) return AppRoutes.home;    // logado: sai das telas de auth
    return null;
  },
  routes: [
    // ---- Autenticação ----
    GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
    GoRoute(
      path: AppRoutes.register,
      builder: (_, _) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (_, _) => const ForgotPasswordScreen(),
    ),

    // ---- Abas com barra inferior ----
    StatefulShellRoute.indexedStack(
      builder: (_, _, shell) => AppShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (_, _) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.movies,
              builder: (_, _) => const MoviesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.theaters,
              builder: (_, _) => const TheatersScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.sessions,
              builder: (_, _) => const SessionsScreen(),
            ),
          ],
        ),
      ],
    ),

    // ---- Telas por cima das abas (sem barra inferior) ----
    GoRoute(path: AppRoutes.profile, builder: (_, _) => const ProfileScreen()),

    GoRoute(
      path: AppRoutes.movieNew,
      builder: (_, _) => const MovieFormScreen(),
    ),
    GoRoute(
      path: AppRoutes.movieEditPath,
      builder: (_, state) => MovieFormScreen(id: state.pathParameters['id']),
    ),

    GoRoute(
      path: AppRoutes.theaterNew,
      builder: (_, _) => const TheaterFormScreen(),
    ),
    GoRoute(
      path: AppRoutes.theaterEditPath,
      builder: (_, state) => TheaterFormScreen(id: state.pathParameters['id']),
    ),

    // ATENÇÃO à ordem: '/sessions/new' PRECISA vir antes de '/sessions/:id',
    // senão "new" seria interpretado como um id.
    GoRoute(
      path: AppRoutes.sessionNew,
      builder: (_, _) => const SessionFormScreen(),
    ),
    GoRoute(
      path: AppRoutes.sessionDetailPath,
      builder: (_, state) =>
          SessionDetailScreen(id: state.pathParameters['id']!),
    ),
    GoRoute(
      path: AppRoutes.sessionEditPath,
      builder: (_, state) => SessionFormScreen(id: state.pathParameters['id']),
    ),
  ],
);
