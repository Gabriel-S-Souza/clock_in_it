import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../setup/routes/route_names.dart';
import '../../../../setup/service_locator/service_locator_imp.dart';
import '../../../../shared/presentation/widgets/responsive_padding.dart';
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
          title: const Text('Detalhes do funcionário'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.goNamed(RouteNames.employees);
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
        body: ResponsivePadding(
          isScreenWrapper: true,
          innerPadding: 0,
          child: BlocBuilder<EmployeeDetailsBloc, EmployeeDetailsState>(
            bloc: employeeDetailsBloc,
            builder: (context, state) {
              if (state is EmployeeDetailsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is EmployeeDetailsSuccess) {
                return ResponsivePadding(
                  widthPaddingFactor: 0.2,
                  child: ListView(
                    children: [
                      Container(
                        height: 72,
                        margin: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: MemoryImage(state.details.pic),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      RichText(
                        text: TextSpan(
                          text: 'Nome: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: state.details.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          text: 'Id: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: state.details.personalId.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          text: 'Criado em: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: dateBrFormat(state.details.createdAt),
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Biometria:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: state.details.biometric.map(
                          (biometric) {
                            final biometricString = biometric.join(', ');
                            return Text(
                              biometricString,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      const SizedBox(height: 16),
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

  String dateBrFormat(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }
}
