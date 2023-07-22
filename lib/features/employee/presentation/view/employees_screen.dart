import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../setup/routes/route_names.dart';
import '../../../../setup/service_locator/service_locator_imp.dart';
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
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Clock In It'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.pushReplacement(RouteNames.login);
              },
            ),
          ],
        ),
        body: BlocListener<EmployeesBloc, EmployeesState>(
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
                  collapsedHeight: 90,
                  toolbarHeight: 90,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
                  flexibleSpace: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Olá, ${employeesBloc.getUserName()}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Selecione o funcionário para registrar o ponto',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                    child: BlocBuilder<EmployeesBloc, EmployeesState>(
                      bloc: employeesBloc,
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(38.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.employees.length,
                          itemBuilder: (context, index) {
                            final employee = state.employees[index];
                            return ListTile(
                              title: Text(employee.name),
                              minVerticalPadding: 24,
                              subtitle: Text(employee.personalId.toString()),
                              trailing: CircleAvatar(
                                backgroundImage: MemoryImage(employee.pic),
                              ),
                              onTap: () => context.pushNamed(
                                RouteNames.employeeDetails,
                                pathParameters: {'employeeId': employee.id},
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
      );
}
