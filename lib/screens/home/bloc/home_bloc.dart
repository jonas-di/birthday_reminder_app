import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:tier_birthday/core/models/contact_model.dart';
import 'package:tier_birthday/core/repositoies/contact_repository.dart';
import 'package:tier_birthday/utils/result.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ContactRepository _contactRepository = ContactRepository();
  HomeBloc() : super(HomeLoadingState()) {
    on<HomeInitialEvent>(homeInitialEvent);

    on<HomeOptionsButtonClickedEvent>(homeOptionsButtonClickedEvent);

    on<HomeRefreshAfterErrorClickedEvent>(homeRefreshAfterErrorClickedEvent);
  }

  FutureOr<void> homeInitialEvent(
    HomeInitialEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    final Result<List<Contact>> resultContacts = await _contactRepository
        .fetchAllContacts();
    switch (resultContacts) {
      case Ok ok:
        emit(HomeLoadedSucsessState(contacts: ok.value));
      case Error error:
        emit(HomeErrorState(exception: error.error));
    }
  }

  FutureOr<void> homeOptionsButtonClickedEvent(
    HomeOptionsButtonClickedEvent event,
    Emitter<HomeState> emit,
  ) {
    debugPrint('Options Button Clicked');
    emit(HomeNavigateToOptionsPageActionState());
  }

  FutureOr<void> homeRefreshAfterErrorClickedEvent(
    HomeRefreshAfterErrorClickedEvent event,
    Emitter<HomeState> emit,
  ) async {
    await homeInitialEvent(HomeInitialEvent(), emit);
  }
}
