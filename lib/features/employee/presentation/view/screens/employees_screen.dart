import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../setup/routes/route_names.dart';
import '../../../../../setup/service_locator/service_locator_imp.dart';
import '../../blocs/employees/employees_bloc.dart';
import '../../blocs/employees/employees_state.dart';

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
          title: Text('Hi, ${employeesBloc.getUserName()}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                // TODO: Implement logout
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteNames.login,
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<EmployeesBloc, EmployeesState>(
          bloc: employeesBloc,
          builder: (context, state) {
            if (state is EmployeesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is EmployeesSuccess) {
              return RefreshIndicator(
                onRefresh: () async {
                  employeesBloc.getEmployees();
                },
                child: ListView.builder(
                  itemCount: state.employees.length,
                  itemBuilder: (context, index) {
                    final employee = state.employees[index];
                    return ListTile(
                      title: Text(employee.name),
                      minVerticalPadding: 24,
                      subtitle: Text(employee.personalId.toString()),
                    );
                  },
                ),
              );
            } else if (state is EmployeesError) {
              return RefreshIndicator(
                  onRefresh: () async {
                    employeesBloc.getEmployees();
                  },
                  child: ListView(
                    children: [
                      Center(
                        child: Center(
                          child: Text(state.message),
                        ),
                      ),
                    ],
                  ));
            } else {
              return const SizedBox();
            }
          },
        ),
      );
}
