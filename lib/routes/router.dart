import 'package:go_router/go_router.dart';

import 'package:path_mobile/utils/http_client.dart';
import 'package:path_mobile/routes/slide_transition.dart';
import 'package:path_mobile/ui/auth/auth_screen.dart';
import 'package:path_mobile/ui/core/layout_screen.dart';
import 'package:path_mobile/ui/dashboard/dashboard_screen.dart';

import 'package:path_mobile/data/kalender/kalender_repository.dart';
import 'package:path_mobile/ui/kalender/kalender_controller.dart';
import 'package:path_mobile/ui/kalender/kalender_screen.dart';

import 'package:path_mobile/data/pengajar/pengajar_repository.dart';
import 'package:path_mobile/ui/pengajar/pengajar_controller.dart';
import 'package:path_mobile/ui/pengajar/pengajar_screen.dart';

import 'package:path_mobile/data/register/register_repository.dart';
import 'package:path_mobile/ui/register/register_controller.dart';
import 'package:path_mobile/ui/register/register_screen.dart';

import 'package:path_mobile/data/kelas/kelas_repository.dart';
import 'package:path_mobile/ui/kelas/kelas_controller.dart';
import 'package:path_mobile/ui/kelas/kelas_screen.dart';

import 'package:path_mobile/data/login/login_repository.dart';
import 'package:path_mobile/ui/login/forgot_password_screen.dart';
import 'package:path_mobile/ui/login/login_controller.dart';
import 'package:path_mobile/ui/login/login_screen.dart';

import 'package:path_mobile/data/profil/profil_repository.dart';
import 'package:path_mobile/ui/profil/profil_controller.dart';
import 'package:path_mobile/ui/profil/profil_screen.dart';

final _httpClient = HttpClient();

final _loginRepo = LoginRepository(_httpClient);
final _profilRepo = ProfilRepository(_httpClient);
final _pengajarRepo = PengajarRepository(_httpClient);
final _kelasRepo = KelasRepository(
  _httpClient,
  extraClassesProvider: () => _pengajarRepo.teachingClasses,
);
final _kalenderRepo = KalenderRepository(
  _httpClient,
  kelasRepo: _kelasRepo,
  pengajarRepo: _pengajarRepo,
);
final _registerRepo = RegisterRepository(_httpClient);

final _kelasController = KelasController(_kelasRepo);
final _pengajarController = PengajarController(_pengajarRepo);
final _kalenderController = KalenderController(_kalenderRepo);
final _profilController = ProfilController(_profilRepo);

Future<void> _loadInitialSessionData() async {
  await Future.wait([
    _profilRepo.fetchProfile(),
    _kelasRepo.fetchJoinedClasses(),
    _pengajarRepo.fetchTeachingClasses(),
  ]);
}

final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => LayoutScreen(child: child),
      routes: [
        GoRoute(
          path: '/beranda',
          builder: (context, state) =>
              DashboardScreen(controller: _kelasController),
        ),
        GoRoute(
          path: '/pengajar',
          builder: (context, state) =>
              PengajarScreen(controller: _pengajarController),
        ),
        GoRoute(
          path: '/kelas',
          builder: (context, state) =>
              KelasScreen(controller: _kelasController),
        ),
        GoRoute(
          path: '/kalender',
          builder: (context, state) =>
              KalenderScreen(controller: _kalenderController),
        ),
        GoRoute(
          path: '/profil',
          builder: (context, state) =>
              ProfilScreen(controller: _profilController),
        ),
      ],
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthScreen(),
      routes: [
        GoRoute(
          path: 'login',
          pageBuilder: (context, state) => slideUpPage(
            state,
            LoginScreen(
              controller: LoginController(
                _loginRepo,
                onAuthenticated: _loadInitialSessionData,
              ),
            ),
          ),
        ),
        GoRoute(
          path: 'register',
          pageBuilder: (context, state) => slideUpPage(
            state,
            RegisterScreen(
              controller: RegisterController(
                _registerRepo,
                onAuthenticated: _loadInitialSessionData,
              ),
            ),
          ),
        ),
        GoRoute(
          path: 'forgot-password',
          pageBuilder: (context, state) =>
              slideUpPage(state, const ForgotPasswordScreen()),
        ),
      ],
    ),
  ],
);
