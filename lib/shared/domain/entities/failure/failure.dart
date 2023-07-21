class Failure implements Exception {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([String? message]) : super(message ?? 'Erro interno no servidor');

  @override
  String toString() => 'ServerFailure($message)';
}

class BadRequestFailure extends Failure {
  const BadRequestFailure([String? message]) : super(message ?? 'Requisição inválida');

  @override
  String toString() => 'BadRequestFailure($message)';
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String? message]) : super(message ?? 'Não encontrado');

  @override
  String toString() => 'NotFoundFailure($message)';
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([String? message]) : super(message ?? 'Não autorizado');

  @override
  String toString() => 'UnauthorizedFailure($message)';
}

class OfflineFailure extends Failure {
  const OfflineFailure([String? message]) : super(message ?? 'Sem conexão com a internet');

  @override
  String toString() => 'OfflineFailure($message)';
}

class UnmappedFailure extends Failure {
  const UnmappedFailure([String? message]) : super(message ?? 'Ops, algo deu errado');

  @override
  String toString() => 'UnmappedFailure($message)';
}
