import 'package:equatable/equatable.dart';

/// ─────────────────────────────────────────────────────────────
/// Generic pagination model used across features.
/// ─────────────────────────────────────────────────────────────
class Pagination<T> extends Equatable {
  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool isLoading;

  const Pagination({
    this.items = const [],
    this.currentPage = 1,
    this.lastPage = 1,
    this.total = 0,
    this.isLoading = false,
  });

  bool get hasMore => currentPage < lastPage;
  bool get isEmpty => items.isEmpty && !isLoading;
  int get nextPage => currentPage + 1;

  Pagination<T> copyWith({
    List<T>? items,
    int? currentPage,
    int? lastPage,
    int? total,
    bool? isLoading,
  }) {
    return Pagination<T>(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Append new page of items.
  Pagination<T> appendPage(List<T> newItems, int page, int last, int tot) {
    return Pagination<T>(
      items: [...items, ...newItems],
      currentPage: page,
      lastPage: last,
      total: tot,
      isLoading: false,
    );
  }

  /// Reset to initial state.
  static Pagination<T> initial<T>() => const Pagination();

  @override
  List<Object?> get props => [items, currentPage, lastPage, total, isLoading];
}
