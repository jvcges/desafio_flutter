import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/app/domain/usecases/save_address/save_address_usecase.dart';
import 'package:desafio_flutter/shared/exceptions/custom_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'save_location_event.dart';
part 'save_location_state.dart';

class SaveLocationBloc extends Bloc<SaveLocationEvent, SaveLocationState> {
  final SaveAddressUsecase _saveAddressUsecase;
  SaveLocationBloc(
    this._saveAddressUsecase,
  ) : super(SaveLocationInitial()) {
    on<SaveNewLocation>((event, emit) async {
      try {
        emit(SaveLocationLoading());
        await _saveAddressUsecase(event.newLocation);
        emit(SaveLocationSuccess());
      } on CustomException catch (e) {
        emit(SaveLocationError(e.message ?? 'Ocorreu um erro!'));
      }
    });
  }
}
