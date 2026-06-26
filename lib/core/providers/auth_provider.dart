import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

// Re-export authStateProvider and authServiceProvider from auth_service
export '../services/auth_service.dart' show authStateProvider, authServiceProvider, currentSessionProvider;

// Auth loading + action state
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthNotifierState>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthNotifier(service);
});

class AuthNotifierState {
  final bool isLoading;
  final String? error;

  const AuthNotifierState({this.isLoading = false, this.error});

  AuthNotifierState copyWith({bool? isLoading, String? error}) {
    return AuthNotifierState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthNotifierState> {
  final AuthService _service;

  AuthNotifier(this._service) : super(const AuthNotifierState());

  Future<bool> loginWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _service.signInWithEmail(email: email, password: password);
      state = state.copyWith(isLoading: false);
      return res.user != null;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('AuthException: ', ''));
      return false;
    }
  }

  Future<bool> registerTraveler(String fullName, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _service.signUpTraveler(email: email, password: password, fullName: fullName);
      state = state.copyWith(isLoading: false);
      return res.user != null;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('AuthException: ', ''));
      return false;
    }
  }

  Future<bool> registerBusiness({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String businessName,
    required String businessType,
    required String businessAddress,
    required String district,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _service.signUpBusiness(
        email: email, password: password, fullName: fullName, phoneNumber: phoneNumber,
      );
      if (res.user != null) {
        await _service.saveBusinessProfile(
          businessName: businessName, businessType: businessType,
          businessAddress: businessAddress, district: district,
        );
      }
      state = state.copyWith(isLoading: false);
      return res.user != null;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('AuthException: ', ''));
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.signInWithGoogle();
      // OAuth redirect launched — auth state will update automatically via stream
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _service.sendPasswordResetEmail(email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await _service.signOut();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
