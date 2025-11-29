import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_state.dart';

///The main search controller which helps to show and display deferent elements indicating
///loading and loaded search query result status.
///
class SearchCubit<E> extends Cubit<SearchState<E>> {
  ///The main search controller which helps to show and display deferent elements indicating
  ///loading and loaded search query result status.
  SearchCubit() : super(SearchState<E>());

  ///Resets the current controller to initial state
  void clear() {
    emit(state.copyWith(sState: SearchStateEnum.initial));
  }

  ///Show a loading indicator in the search screen.
  ///
  void showLoadingIndicator() {
    emit(state.copyWith(sState: SearchStateEnum.loading));
  }

  ///Displays an error widget to search screen
  void showError() {
    emit(state.copyWith(sState: SearchStateEnum.failed));
  }

  ///Displays the query search results returned from another controller.
  ///
  ///* [data] is the list of items to be displayed.
  ///* [hasNexPageUrl] helps to display a bottom loading indicator, to inform the user
  ///about the new data fetching.
  ///
  void showResults(List<E> data, {bool? hasNexPageUrl}) {
    emit(
      state.copyWith(
        sState: SearchStateEnum.succeeded,
        data: data,
        hasNextPageUrl: hasNexPageUrl,
      ),
    );
  }
}
