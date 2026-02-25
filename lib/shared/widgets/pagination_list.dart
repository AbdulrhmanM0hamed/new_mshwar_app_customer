import 'package:flutter/material.dart';
import 'package:new_mshwar_app_customer/core/theme/spacing.dart';

/// ─────────────────────────────────────────────────────────────
/// Generic paginated list with auto‑load on scroll.
///
/// Usage:
///   PaginationList<ItemModel>(
///     items: state.items,
///     isLoading: state.isLoadingMore,
///     hasMore: state.hasMore,
///     onLoadMore: () => cubit.loadMore(),
///     itemBuilder: (item) => ItemCard(item),
///   )
/// ─────────────────────────────────────────────────────────────
class PaginationList<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final VoidCallback onLoadMore;
  final bool isLoading;
  final bool hasMore;
  final Widget? separator;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;
  final double loadMoreThreshold;

  const PaginationList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onLoadMore,
    required this.isLoading,
    required this.hasMore,
    this.separator,
    this.emptyWidget,
    this.loadingWidget,
    this.padding,
    this.scrollController,
    this.loadMoreThreshold = 200,
  });

  @override
  State<PaginationList<T>> createState() => _PaginationListState<T>();
}

class _PaginationListState<T> extends State<PaginationList<T>> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!widget.hasMore || widget.isLoading) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (maxScroll - currentScroll <= widget.loadMoreThreshold) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty && !widget.isLoading) {
      return widget.emptyWidget ?? const SizedBox.shrink();
    }

    return ListView.separated(
      controller: _scrollController,
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(
            horizontal: Spacing.screenH,
            vertical: Spacing.sm,
          ),
      itemCount: widget.items.length + (widget.hasMore ? 1 : 0),
      separatorBuilder: (_, __) =>
          widget.separator ?? const SizedBox(height: Spacing.sm),
      itemBuilder: (context, index) {
        if (index >= widget.items.length) {
          // Loading indicator at bottom
          return widget.loadingWidget ??
              const Padding(
                padding: EdgeInsets.all(Spacing.base),
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              );
        }
        return widget.itemBuilder(widget.items[index]);
      },
    );
  }
}
