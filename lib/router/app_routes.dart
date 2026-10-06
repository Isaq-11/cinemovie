abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';

  static const home = '/home';
  static const movies = '/movies';
  static const theaters = '/theaters';
  static const sessions = '/sessions';

  static const profile = '/profile';

  static const movieNew = '/movies/new';
  static const movieEditPath = '/movies/:id/edit';
  static String movieEdit(String id) => '/movies/$id/edit';

  static const theaterNew = '/theaters/new';
  static const theaterEditPath = '/theaters/:id/edit';
  static String theaterEdit(String id) => '/theaters/$id/edit';

  static const sessionNew = '/sessions/new';
  static const sessionDetailPath = '/sessions/:id';
  static String sessionDetail(String id) => '/sessions/$id';
  static const sessionEditPath = '/sessions/:id/edit';
  static String sessionEdit(String id) => '/sessions/$id/edit';
}
