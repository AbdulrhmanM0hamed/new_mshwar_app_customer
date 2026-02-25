import 'package:new_mshwar_app_customer/core/error/failure.dart';

/// ─────────────────────────────────────────────────────────────
/// A functional Result type — eliminates the need for try/catch
/// at the repository boundary.
///
/// Usage:
///   Future<Result<UserModel>> getUser(int id) async {
///     try {
///       final user = await api.fetchUser(id);
///       return Result.success(user);
///     } on ServerException catch (e) {
///       return Result.failure(ServerFailure(message: e.message));
///     }
///   }
///
///   // In the Cubit:
///   final result = await repo.getUser(1);
///   result.when(
///     success: (user) => emit(Loaded(user)),
///     failure: (f)    => emit(Error(f)),
///   );
/// ─────────────────────────────────────────────────────────────
sealed class Result<T> {
  const Result._();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = ResultFailure<T>;

  /// Pattern‑match both branches.
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Success<T> s => success(s.data),
      ResultFailure<T> f => failure(f.failure),
    };
  }

  /// Transform the success value.
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success<T>(:final data) => Result.success(transform(data)),
      ResultFailure<T>(:final failure) => Result.failure(failure),
    };
  }

  /// Chain another async operation on success.
  Future<Result<R>> flatMap<R>(
    Future<Result<R>> Function(T data) transform,
  ) async {
    return switch (this) {
      Success<T>(:final data) => transform(data),
      ResultFailure<T>(:final failure) => Result.failure(failure),
    };
  }

  /// Quick getters
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;

  T? get dataOrNull => switch (this) {
    Success<T>(:final data) => data,
    _ => null,
  };

  Failure? get failureOrNull => switch (this) {
    ResultFailure<T>(:final failure) => failure,
    _ => null,
  };
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data) : super._();
}

final class ResultFailure<T> extends Result<T> {
  final Failure failure;
  const ResultFailure(this.failure) : super._();
}
