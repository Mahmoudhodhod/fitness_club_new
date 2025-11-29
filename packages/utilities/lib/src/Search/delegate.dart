import 'package:flutter/material.dart' hide showSearch, SearchDelegate;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../locale.dart';
import 'SearchController/search_cubit.dart';
import 'localization.dart';
import 'logic.dart';

//TODO: test pagination

typedef WidgetBuilder<E> = Widget Function(BuildContext context, E value);

///A very universal search delegate which can be used with any controller to provider
///iterable data like a list.
class Search<E> extends SearchDelegate<E> {
  ///The main delegate controller which displays a several ui elements
  ///which indicates the current status.
  ///
  final SearchCubit<E> cubit;

  ///Use to change the current displayed data widget.
  ///
  final WidgetBuilder<E> itemBuilder;

  ///Triggered when the search query is changed.
  ///
  final ValueChanged<String>? onChanged;

  ///Triggered when a search result widget is selected or tapped.
  ///
  final ValueChanged<E>? onSelected;

  ///Triggered when the scrollable view reaches the bottom and ask the
  ///parent controller for more data to be displayed.
  ///
  final VoidCallback? fetchMore;

  ///The loading indicator which be used to indicate loading state.
  ///
  final Widget? loadingIndicator;

  ///This widget is shown when the search query returns an empty set of data.
  ///
  final Widget? notFoundWidget;

  ///This widget is shown when the search query returns an exception.
  ///
  final Widget? errorWidget;

  ///Localization delegate by which you can change the displayed search screen text.
  ///
  final SearchLocalization? localizationDelegate;

  ///The current app locale, defaults to `Locale('ar', 'EG')`.
  final Locale locale;

  ///A very universal search delegate which can be used with any controller to provider
  ///iterable data like a list.
  Search({
    required this.cubit,
    required this.itemBuilder,
    this.onChanged,
    this.onSelected,
    this.fetchMore,
    this.loadingIndicator,
    this.notFoundWidget,
    this.localizationDelegate,
    this.errorWidget,
    this.locale = const Locale('ar', 'EG'),
  });

  String _prevQuery = '';

  @override
  void queryChanged(String query) {
    if (_prevQuery == query || query.isEmpty) return;
    onChanged?.call(query);
    _prevQuery = query;
  }

  @override
  void bottomReached() {
    if (!cubit.state.hasNextPageUrl) return;
    fetchMore?.call();
  }

  @override
  List<Widget>? buildActions(BuildContext context) => null;

  @override
  Widget? buildLeading(BuildContext context) => BackButton(
        onPressed: () {
          Navigator.pop(context);
          cubit.clear();
        },
      );

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) => _body(context);

  Widget _body(BuildContext context) {
    final SearchLocalization localization;
    if (localizationDelegate != null) {
      localization = localizationDelegate!;
    } else {
      localization = locale.isArabic ? const ArabicLocalization() : const SearchLocalization();
    }

    Widget builderSeparator(BuildContext context, SearchState state, int index) {
      final len = state.data.length;
      if (index <= len && state.hasNextPageUrl) return const SizedBox.shrink();
      return const Divider(indent: 20, endIndent: 10);
    }

    Widget buildPaginationLoader() {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SizedBox.fromSize(
          size: const Size.square(50),
          child: Center(child: loadingIndicator ?? const CircularProgressIndicator()),
        ),
      );
    }

    final localizationStyle = Theme.of(context).textTheme.headlineMedium;

    return BlocBuilder<SearchCubit<E>, SearchState<E>>(
      bloc: cubit,
      builder: (context, state) {
        if (state.sState == SearchStateEnum.loading) {
          return Center(child: loadingIndicator ?? const CircularProgressIndicator.adaptive());
        } else if (state.sState == SearchStateEnum.initial) {
          return Center(
            child: Text(
              localization.startSearch,
              style: localizationStyle,
            ),
          );
        } else if (state.sState == SearchStateEnum.succeeded) {
          final data = state.data;
          if (data.isEmpty) {
            return Center(
              child: notFoundWidget ??
                  Text(
                    localization.queryNotFound,
                    style: localizationStyle,
                  ),
            );
          }
          return ListView.separated(
            controller: scrollController,
            itemCount: state.hasNextPageUrl ? data.length + 1 : data.length,
            padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight, top: 20),
            separatorBuilder: (context, index) => builderSeparator(context, state, index),
            itemBuilder: (context, index) {
              if (index >= data.length) return buildPaginationLoader();
              final value = data.elementAt(index);
              return GestureDetector(
                onTap: () {
                  if (onSelected == null) return;
                  onSelected!.call(value);
                  cubit.clear();
                },
                child: itemBuilder(context, value),
              );
            },
          );
        } else if (state.sState == SearchStateEnum.failed) {
          return Center(
            child: errorWidget ??
                Text(
                  localization.errorMessage,
                  style: localizationStyle,
                ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
