import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/repositories/user_repository.dart';
import 'package:wearway_flutter/features/auth/auth_validators.dart';
import 'package:wearway_flutter/features/auth/providers/auth_controller.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Layar login. ConsumerStatefulWidget = butuh state lokal untuk
/// TextEditingController + FormState (kasus sah pakai State di Flutter).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // Navigasi setelah sukses ditangani redirect router (loggedIn + /auth).
    unawaited(
      ref
          .read(authControllerProvider.notifier)
          .login(_emailCtrl.text.trim(), _passwordCtrl.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final errorText = authState.hasError ? _mapError(authState.error) : null;

    return Scaffold(
      key: const ValueKey(TestKeys.loginScreen),
      appBar: AppBar(title: const Text('Masuk')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.pagePadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Selamat datang 👋', style: theme.textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Masuk untuk checkout & lihat riwayat pesanan.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                TextFormField(
                  key: const ValueKey(TestKeys.loginEmailInput),
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'customer@example.com',
                  ),
                  validator: AuthValidators.email,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  key: const ValueKey(TestKeys.loginPasswordInput),
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  enabled: !isLoading,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: AuthValidators.password,
                ),
                if (errorText != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    errorText,
                    key: const ValueKey(TestKeys.loginErrorMessage),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  key: const ValueKey(TestKeys.loginSubmitButton),
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Masuk'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  key: const ValueKey(TestKeys.loginRegisterLink),
                  onPressed: isLoading
                      ? null
                      : () => context.go('/auth/register'),
                  child: const Text('Belum punya akun? Daftar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _mapError(Object? error) {
    if (error is AuthException) return error.message;
    return 'Gagal masuk. Coba lagi.';
  }
}
