import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/view/login_screen.dart';
import '../../features/employee/presentation/view/employee_details_screen.dart';
import '../../features/employee/presentation/view/employees_screen.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: RouteNames.login,
      name: RouteNames.login,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.initial,
      redirect: (context, state) => RouteNames.login,
    ),
    GoRoute(
      path: RouteNames.employees,
      name: RouteNames.employees,
      builder: (context, state) => const EmployeesScreen(),
    ),
    GoRoute(
      path: '${RouteNames.employeeDetails}/:employeeId',
      name: RouteNames.employeeDetails,
      builder: (context, state) => EmployeeDetailsScreen(
        employeeId: state.pathParameters['employeeId']!,
      ),
    ),
  ],
  initialLocation: RouteNames.login,
);
