import 'package:flutter/material.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/datasources/recipe_api_service.dart';
import '../../data/models/request_history_item_dto.dart';
import '../widgets/request_history/history_error_view.dart';
import '../widgets/request_history/request_history_card.dart';
import '../widgets/request_history/request_history_detail_sheet.dart';

class RequestHistoryPage extends StatefulWidget {
  final RecipeApiService? apiService;

  const RequestHistoryPage({
    super.key,
    this.apiService,
  });

  @override
  State<RequestHistoryPage> createState() => _RequestHistoryPageState();
}

class _RequestHistoryPageState extends State<RequestHistoryPage> {
  static const _historyLimit = 60;

  late final RecipeApiService _apiService;
  late Future<List<RequestHistoryItemDto>> _future;

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService ?? RecipeApiService(DioClient());
    _future = _load();
  }

  Future<List<RequestHistoryItemDto>> _load() {
    return _apiService.getRequestHistory(
      limit: _historyLimit,
      includeRecipe: true,
    );
  }

  Future<void> _reloadAndAwaitSafely() async {
    final next = _load();
    setState(() {
      _future = next;
    });

    try {
      await next;
    } catch (_) {
      // FutureBuilder renders error state.
    }
  }

  void _reload() {
    final next = _load();
    setState(() {
      _future = next;
    });
  }

  void _openDetails(RequestHistoryItemDto item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: AppTheme.surfaceColor,
      builder: (_) => RequestHistoryDetailSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Tarif Gecmisi'),
        actions: [
          IconButton(
            onPressed: _reload,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Yenile',
          ),
        ],
      ),
      body: FutureBuilder<List<RequestHistoryItemDto>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return HistoryErrorView(onRetry: _reload);
          }

          final items = snapshot.data ?? const <RequestHistoryItemDto>[];
          final recipeItems = items
              .where((item) => item.recipe != null)
              .toList(growable: false);

          if (recipeItems.isEmpty) {
            return const Center(
              child: Text(
                'Henuz olusturulmus tarif bulunmuyor.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reloadAndAwaitSafely,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              itemCount: recipeItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => RequestHistoryCard(
                item: recipeItems[index],
                onTap: () => _openDetails(recipeItems[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
