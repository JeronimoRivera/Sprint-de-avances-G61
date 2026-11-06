import 'package:flutter/material.dart';

import 'app_services.dart';
import 'error_messages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  bool _register = false;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      if (_register) {
        await authRepository.register(
          email: _email.text.trim(),
          password: _password.text,
          name: _name.text.trim(),
        );
      } else {
        await authRepository.signIn(
          email: _email.text.trim(),
          password: _password.text,
        );
      }
    } catch (error) {
      _show(errorMessage(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _show(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Reservas de espacios')),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _register ? 'Crear cuenta' : 'Iniciar sesión',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    if (_register)
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(labelText: 'Nombre'),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Escribe tu nombre.'
                                : null,
                      ),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Correo'),
                      validator: (value) => value == null ||
                              !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)
                          ? 'Escribe un correo válido.'
                          : null,
                    ),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      decoration:
                          const InputDecoration(labelText: 'Contraseña'),
                      validator: (value) => value == null || value.length < 6
                          ? 'Usa al menos 6 caracteres.'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: _busy ? null : _submit,
                      child: Text(_busy
                          ? 'Procesando...'
                          : _register
                              ? 'Registrarme'
                              : 'Entrar'),
                    ),
                    TextButton(
                      onPressed: _busy
                          ? null
                          : () => setState(() => _register = !_register),
                      child: Text(_register
                          ? 'Ya tengo una cuenta'
                          : 'Crear una cuenta de usuario'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
