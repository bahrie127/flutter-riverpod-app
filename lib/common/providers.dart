import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/quotes_list_notifier.dart';
import '../providers/quotes_list_state.dart';
import '../providers/submit_quote_notifier.dart';
import '../providers/submit_quote_state.dart';
import '../repositories/quote_repository.dart';
import 'constants.dart';

final dioProvider = Provider<Dio>(
  (ref) => Dio(
    BaseOptions(
      headers: {
        'apikey': kApiKey,
        'Prefer': 'return=representation',
      },
      baseUrl: kBaseUrl,
    ),
  ),
);

final repositoryProvider = Provider<QuoteRepository>(
  (ref) => QuoteRepositoryImpl(ref.read(dioProvider)),
);

final quotesListNotifier =
    StateNotifierProvider<QuotesListNotifier, QuotesListState>(
  (ref) => QuotesListNotifier(ref.read(repositoryProvider)),
);

final submitQuoteNotifier =
    StateNotifierProvider<SubmitQuoteNotifier, SubmitQuoteState>(
  (ref) {
    final notifier = ref.read(quotesListNotifier.notifier);
    return SubmitQuoteNotifier(ref.read(repositoryProvider), notifier);
  },
);