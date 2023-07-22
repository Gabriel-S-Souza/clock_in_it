// Mocks generated by Mockito 5.4.2 from annotations
// in clock_in_it/test/features/auth/presentation/login_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:clock_in_it/features/auth/domain/entities/login_credentials_entity.dart'
    as _i6;
import 'package:clock_in_it/features/auth/domain/use_cases/auth_use_case.dart'
    as _i3;
import 'package:clock_in_it/shared/domain/entities/result/result.dart' as _i2;
import 'package:clock_in_it/shared/domain/entities/user/user_entity.dart'
    as _i5;
import 'package:clock_in_it/shared/domain/use_cases/local_storage_use_case.dart'
    as _i7;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeResult_0<T> extends _i1.SmartFake implements _i2.Result<T> {
  _FakeResult_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AuthUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthUseCase extends _i1.Mock implements _i3.AuthUseCase {
  MockAuthUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Result<_i5.UserEntity>> login(
          _i6.LoginCredentialsEntity? credentials) =>
      (super.noSuchMethod(
        Invocation.method(
          #login,
          [credentials],
        ),
        returnValue: _i4.Future<_i2.Result<_i5.UserEntity>>.value(
            _FakeResult_0<_i5.UserEntity>(
          this,
          Invocation.method(
            #login,
            [credentials],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.UserEntity>>);
}

/// A class which mocks [LocalStorageUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalStorageUseCase extends _i1.Mock
    implements _i7.LocalStorageUseCase {
  MockLocalStorageUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> saveUser(_i5.UserEntity? user) => (super.noSuchMethod(
        Invocation.method(
          #saveUser,
          [user],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<bool> set(
    String? key, {
    required String? value,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #set,
          [key],
          {#value: value},
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<bool> setList(
    String? key, {
    required List<String>? value,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #setList,
          [key],
          {#value: value},
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  String? get(String? key) => (super.noSuchMethod(Invocation.method(
        #get,
        [key],
      )) as String?);
  @override
  List<String>? getList(String? key) => (super.noSuchMethod(Invocation.method(
        #getList,
        [key],
      )) as List<String>?);
  @override
  _i4.Future<bool> delete(String? key) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [key],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
  @override
  _i4.Future<bool> deleteAll() => (super.noSuchMethod(
        Invocation.method(
          #deleteAll,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}
