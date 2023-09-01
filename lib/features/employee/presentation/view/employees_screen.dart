import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../setup/routes/route_names.dart';
import '../../../../setup/service_locator/service_locator_imp.dart';
import '../../../../shared/data/services/notifications/notification_imp.dart';
import '../../../../shared/presentation/widgets/responsive_padding.dart';
import '../blocs/employees/employees_bloc.dart';
import '../blocs/employees/employees_state.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final employeesBloc = ServiceLocatorImp.I.get<EmployeesBloc>();

  @override
  void initState() {
    super.initState();
    employeesBloc.getEmployees();
    NotificationServiceImp.I.activatePeriodicNotification();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Clock In It'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                NotificationServiceImp.I.cancelPeriodicNotification();
                context.pushReplacement(RouteNames.login);
              },
            ),
          ],
        ),
        body: ResponsivePadding(
          isScreenWrapper: true,
          innerPadding: 0,
          child: BlocListener<EmployeesBloc, EmployeesState>(
            bloc: employeesBloc,
            listener: (context, state) {
              if (state.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.messageError!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: RefreshIndicator(
              onRefresh: () async {
                employeesBloc.getEmployees();
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
                    flexibleSpace: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Olá, ${employeesBloc.getUserName()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Estes são os seus funcionários:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ResponsivePadding(
                      widthPaddingFactor: 0.2,
                      child: BlocBuilder<EmployeesBloc, EmployeesState>(
                        bloc: employeesBloc,
                        builder: (context, state) {
                          if (state.isLoading) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 60),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 20),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.employees.length,
                            itemBuilder: (context, index) {
                              final employee = state.employees[index];
                              return Card(
                                child: ListTile(
                                  title: Text(employee.name),
                                  minVerticalPadding: 20,
                                  subtitle: Text(employee.personalId.toString()),
                                  trailing: CircleAvatar(
                                    backgroundImage: MemoryImage(employee.pic),
                                  ),
                                  onTap: () => context.goNamed(
                                    RouteNames.employeeDetails,
                                    pathParameters: {'employeeId': employee.id},
                                  ),
                                ),
                              );
                            },
                          );
                        },
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
