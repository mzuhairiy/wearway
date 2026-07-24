import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wearway_flutter/core/theme/app_spacing.dart';
import 'package:wearway_flutter/data/repositories/user_repository.dart';
import 'package:wearway_flutter/features/auth/auth_validators.dart';
import 'package:wearway_flutter/features/auth/providers/auth_controller.dart';
import 'package:wearway_flutter/utils/test_keys.dart';

/// Layar register (email + password + konfirmasi + nama).
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    unawaited(
      ref
          .read(authControllerProvider.notifier)
          .register(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
            name: _nameCtrl.text.trim(),
            createdAtMs: DateTime.now().millisecondsSinceEpoch,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final errorText = authState.hasError ? _mapError(authState.error) : null;

    return Scaffold(
      key: const ValueKey(TestKeys.registerScreen),
      appBar: AppBar(title: const Text('Daftar')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.pagePadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Buat akun', style: theme.textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.xl),
                TextFormField(
                  key: const ValueKey(TestKeys.registerNameInput),
                  controller: _nameCtrl,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: AuthValidators.name,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  key: const ValueKey(TestKeys.registerEmailInput),
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: AuthValidators.email,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  key: const ValueKey(TestKeys.registerPasswordInput),
                  controller: _passwordCtrl,
                  obscureText: _obscure,
                  enabled: !isLoading,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    helperText:
                        'Minimal ${AuthValidators.minPasswordLength} '
                        'karakter',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: AuthValidators.password,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  key: const ValueKey(TestKeys.registerConfirmInput),
                  controller: _confirmCtrl,
                  obscureText: _obscure,
                  enabled: !isLoading,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(
                    labelText: 'Konfirmasi Password',
                  ),
                  validator: (v) =>
                      AuthValidators.confirmPassword(v, _passwordCtrl.text),
                ),
                if (errorText != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    errorText,
                    key: const ValueKey(TestKeys.registerErrorMessage),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  key: const ValueKey(TestKeys.registerSubmitButton),
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Daftar'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: isLoading ? null : () => context.go('/auth/login'),
                  child: const Text('Sudah punya akun? Masuk'),
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
    return 'Gagal mendaftar. Coba lagi.';
  }
}
