import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

final supabase = Supabase.instance.client;

// Auth State Provider — watches real-time Supabase auth events
final authStateProvider = StreamProvider<AuthState>((ref) {
  return supabase.auth.onAuthStateChange;
});

// Current session
final currentSessionProvider = Provider<Session?>((ref) {
  return supabase.auth.currentSession;
});

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Profile Provider
final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final session = ref.watch(currentSessionProvider);
  if (session == null) return null;

  try {
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', session.user.id)
        .single();
    return response;
  } catch (e) {
    return null;
  }
});

class AuthService {
  final _supabase = Supabase.instance.client;

  // ─── Email & Password ────────────────────────────────────────

  Future<AuthResponse> signUpTraveler({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'role': 'traveler',
      },
    );
  }

  Future<AuthResponse> signUpBusiness({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'role': 'business',
        'phone_number': phoneNumber,
      },
    );
  }

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // ─── Google Sign In (Native App Flow) ───────────────────────

  Future<bool> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        serverClientId: '894592171360-cfcah5n82m1slvqdac80ucrkd107cpqd.apps.googleusercontent.com',
      );
      
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        return false;
      }

      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      
      return true;
    } catch (e) {
      // Fallback for Web platform where google_sign_in might not be configured fully
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.travelbd.app://login-callback',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      return true;
    }
  }

  // ─── Sign Out ─────────────────────────────────────────────────

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // ─── Get User Role ────────────────────────────────────────────

  Future<String?> getUserRole() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _supabase
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .single();

    return response['role'] as String?;
  }

  // ─── Save Business Profile ─────────────────────────────────────

  Future<void> saveBusinessProfile({
    required String businessName,
    required String businessType,
    required String businessAddress,
    required String district,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.from('business_profiles').upsert({
      'user_id': userId,
      'business_name': businessName,
      'business_type': businessType,
      'business_address': businessAddress,
      'district': district,
      'is_pending': true,
      'is_verified': false,
    });
  }

  bool get isLoggedIn => _supabase.auth.currentUser != null;
}
