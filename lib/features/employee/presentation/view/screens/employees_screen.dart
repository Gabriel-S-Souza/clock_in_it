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
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteNames.login,
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
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
            child: BlocBuilder<EmployeesBloc, EmployeesState>(
              bloc: employeesBloc,
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
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
                        trailing: CircleAvatar(
                          backgroundImage: MemoryImage(employee.pic),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );
}
