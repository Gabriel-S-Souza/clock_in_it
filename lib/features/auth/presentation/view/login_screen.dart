import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../setup/routes/route_names.dart';
import '../../../../setup/service_locator/service_locator_imp.dart';
import '../../../../setup/utils/assets.dart';
import '../../../../shared/presentation/widgets/responsive_padding.dart';
import '../blocs/login_bloc.dart';
import '../blocs/login_state.dart';
import 'widgets/text_field_widget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final loginBloc = ServiceLocatorImp.I.get<LoginBloc>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      loginBloc.login(
                                        usernameController.text,
                                        passwordController.text,
                                      );
                                    }
                                  },
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
