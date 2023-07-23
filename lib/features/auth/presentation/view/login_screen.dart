import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../setup/routes/route_names.dart';
import '../../../../setup/service_locator/service_locator_imp.dart';
import '../../../../setup/utils/assets.dart';
import '../../../../shared/domain/use_cases/local_storage_use_case.dart';
import '../../../../shared/presentation/widgets/responsive_padding.dart';
import '../blocs/login_bloc.dart';
import '../blocs/login_state.dart';
import 'widgets/text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final loginBloc = ServiceLocatorImp.I.get<LoginBloc>();
  final _storage = ServiceLocatorImp.I.get<LocalStorageUseCase>();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final keyUserName = 'keyUserName';
  final keyPassword = 'keyPassword';
  final keyLocalAuthActive = 'keyLocalAuthActive';
  final bool _savePassword = true;

  final _formKey = GlobalKey<FormState>();

  final localAuth = LocalAuthentication();

  Future<void> _readFromStorage() async {
    if (kIsWeb) return;
    final isLocalAuthEnabled = _storage.get('keyLocalAuthActive');

    if (isLocalAuthEnabled != null) {
      bool didAuthenticate;

      try {
        didAuthenticate =
            await localAuth.authenticate(localizedReason: 'Please authenticate to sign in');
      } catch (e) {
        print(e);
        didAuthenticate = false;
      }

      if (didAuthenticate) {
        usernameController.text = _storage.get(keyUserName) ?? '';
        passwordController.text = _storage.get(keyPassword) ?? '';
        if (usernameController.text.isNotEmpty && passwordController.text.isNotEmpty) {
          loginBloc.login(
            usernameController.text,
            passwordController.text,
          );
        }
      }
    }
  }

  Future<void> _onFormSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_savePassword && !kIsWeb) {
        await _storage.set(keyUserName, value: usernameController.text);
        await _storage.set(keyPassword, value: passwordController.text);

        final isVerificationEnabled = _storage.get(keyLocalAuthActive) ?? 'false';

        if (isVerificationEnabled == 'false' && await localAuth.canCheckBiometrics) {
          if (!mounted) return;
          await showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) => BottomSheet(
              onClosing: () {},
              builder: (BuildContext context) => Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Ativar autenticação por biometria?',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.maxFinite,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _onEnableLocalAuth,
                        child: const Text('Ativar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
      loginBloc.login(
        usernameController.text,
        passwordController.text,
      );
    }
  }

  Future<void> _onEnableLocalAuth() async {
    if (kIsWeb) return;
    await _storage.set(keyLocalAuthActive, value: 'true');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Autenticação por biometria ativada'),
    ));
    context.pop();
  }

  @override
  void initState() {
    super.initState();
    _readFromStorage();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: ResponsivePadding(
          isScreenWrapper: true,
          child: BlocListener(
            bloc: loginBloc,
            listener: (context, state) {
              if (state is LoginError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is LoginSuccess) {
                context.goNamed(RouteNames.employees);
              }
            },
            child: BlocBuilder(
              bloc: loginBloc,
              builder: (context, state) => Stack(
                alignment: Alignment.center,
                children: [
                  ResponsivePadding(
                    widthPaddingFactor: 0.3,
                    child: Form(
                      key: _formKey,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 52,
                                child: Image.memory(
                                  imageClock64,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withOpacity(0.6),
                                ),
                              ),
                              Text(
                                'Clock In It',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 52),
                              TextFieldWidget(
                                controller: usernameController,
                                hint: 'Username',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Digite o nome de usuário';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              TextFieldWidget(
                                controller: passwordController,
                                hint: 'Password',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Digite a senha';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.maxFinite,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _onFormSubmit,
                                  child: state is LoginLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text('Login'),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
