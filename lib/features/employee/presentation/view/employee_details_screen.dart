import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../setup/routes/route_names.dart';
import '../../../../setup/service_locator/service_locator_imp.dart';
import '../blocs/employee_details/employee_details_bloc.dart';
import '../blocs/employee_details/employee_details_state.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final String employeeId;
  const EmployeeDetailsScreen({super.key, required this.employeeId});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  final employeeDetailsBloc = ServiceLocatorImp.I.get<EmployeeDetailsBloc>();
  @override
  void initState() {
    super.initState();
    employeeDetailsBloc.getDetails(widget.employeeId);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Employee Details'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.goNamed(RouteNames.login);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<EmployeeDetailsBloc, EmployeeDetailsState>(
            bloc: employeeDetailsBloc,
            builder: (context, state) {
              if (state is EmployeeDetailsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is EmployeeDetailsSuccess) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 72,
                        margin: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: MemoryImage(state.details.pic),
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Nome: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: state.details.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          text: 'Id: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: state.details.personalId.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          text: 'Criado em: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '${state.details.createdAt.day}/${state.details.createdAt.month}/${state.details.createdAt.year}',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 24,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Biometria:',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: state.details.biometric.map(
                          (biometric) {
                            final biometricString = biometric.join(', ');
                            return Text(
                              biometricString,
                              textAlign: TextAlign.center,
                            );
                          },
                        ).toList(),
                      )
                    ],
                  ),
                );
              }
              if (state is EmployeeDetailsError) {
                return Center(
                  child: Text(state.message),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      );
}
