import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/app/domain/usecases/get_saved_addresses/get_saved_addresses_usecase.dart';
import 'package:desafio_flutter/shared/exceptions/custom_exception.dart';
import 'package:desafio_flutter/shared/extensions/e_string.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'locations_list_event.dart';
part 'locations_list_state.dart';

class LocationsListBloc extends Bloc<LocationsListEvent, LocationsListState> {
  final GetSavedAddressesUsecase _getSavedAddressesUsecase;
  LocationsListBloc(
    this._getSavedAddressesUsecase,
  ) : super(LocationsListInitial(locationsList: [])) {
    on<GetSavedAddressesList>((event, emit) async {
      try {
        emit(LocationsListLoading(locationsList: state.locationsList));
        final list = await _getSavedAddressesUsecase();
        emit(LocationsLoaded(
          locationsList: list,
          filteredList: list,
        ));
      } on CustomException catch (e) {
        emit(
          LocationsListError(
            locationsList: state.locationsList,
            errorMessage: e.message ?? 'Ocorreu um erro!',
          ),
        );
      }
    });

    on<SearchCEP>((event, emit) async {
      final filteredList = state.locationsList.where(
        (element) =>
            element.cep != null &&
            element.cep!
                .justNumbers()
                .contains(event.searchString.justNumbers()),
      );
      emit(
        LocationsLoaded(
            filteredList: filteredList.toList(),
            locationsList: state.locationsList),
      );
    });

    on<ResetLocationsBloc>((event, emit) {
      emit(LocationsListInitial(locationsList: []));
    });
  }
}
