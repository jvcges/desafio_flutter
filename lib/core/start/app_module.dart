import 'package:desafio_flutter/app/data/datasources/get_address_by_cep/get_address_by_cep_datasource.dart';
import 'package:desafio_flutter/app/data/datasources/get_saved_addresses/get_saved_addresses_datasource.dart';
import 'package:desafio_flutter/app/data/datasources/save_address/save_address_datasource.dart';
import 'package:desafio_flutter/app/data/repositories/get_address_by_cep/get_address_by_cep_imp_repository.dart';
import 'package:desafio_flutter/app/data/repositories/get_saved_addresses/get_saved_addresses_imp_repository.dart';
import 'package:desafio_flutter/app/data/repositories/save_address/save_address_imp_repository.dart';
import 'package:desafio_flutter/app/domain/repositories/get_address_by_cep/get_address_by_cep_repository.dart';
import 'package:desafio_flutter/app/domain/repositories/get_saved_addresses/get_saved_addresses_repository.dart';
import 'package:desafio_flutter/app/domain/repositories/save_address/save_address_repository.dart';
import 'package:desafio_flutter/app/domain/usecases/get_address_by_cep/get_address_by_cep_imp_usecase.dart';
import 'package:desafio_flutter/app/domain/usecases/get_address_by_cep/get_address_by_cep_usecase.dart';
import 'package:desafio_flutter/app/domain/usecases/get_saved_addresses/get_saved_addresses_imp_usecase.dart';
import 'package:desafio_flutter/app/domain/usecases/get_saved_addresses/get_saved_addresses_usecase.dart';
import 'package:desafio_flutter/app/domain/usecases/save_address/save_address_imp_usecase.dart';
import 'package:desafio_flutter/app/domain/usecases/save_address/save_address_usecase.dart';
import 'package:desafio_flutter/app/external/get_address_by_cep/get_address_by_cep_imp_datasource.dart';
import 'package:desafio_flutter/app/external/get_saved_addresses/get_saved_addresses_imp_datasource.dart';
import 'package:desafio_flutter/app/external/save_address/save_address_imp_datasource.dart';
import 'package:desafio_flutter/app/presentation/pages/locations_list_page/bloc/locations_list_bloc.dart';
import 'package:desafio_flutter/app/presentation/pages/main_wrapper/bloc/main_wrapper_bloc.dart';
import 'package:desafio_flutter/app/presentation/pages/main_wrapper/main_wrapper.dart';
import 'package:desafio_flutter/app/presentation/pages/map_page/bloc/map_page_bloc.dart';
import 'package:desafio_flutter/app/presentation/pages/save_location_page/bloc/save_location_bloc.dart';
import 'package:desafio_flutter/app/presentation/pages/save_location_page/save_location_page.dart';
import 'package:desafio_flutter/core/Services/client_https/via_cep/via_cep_client_https.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(i) => [
        //Usecases
        i.addLazySingleton<GetAddressByCepUsecase>(
          GetAddressByCepImpUsecase.new,
        ),
        i.addLazySingleton<SaveAddressUsecase>(
          SaveAddressImpUsecase.new,
        ),
        i.addLazySingleton<GetSavedAddressesUsecase>(
          GetSavedAddressesImpUsecase.new,
        ),

        //Repositories
        i.addLazySingleton<GetAddressByCepRepository>(
          GetAddressByCepImpRepository.new,
        ),
        i.addLazySingleton<SaveAddressRepository>(
          SaveAddressImpRepository.new,
        ),
        i.addLazySingleton<GetSavedAddressesRepository>(
          GetSavedAddressesImpRepository.new,
        ),

        //Datasources
        i.addLazySingleton<GetAddressByCepDatasource>(
          GetAddressByCepImpDatasource.new,
        ),
        i.addLazySingleton<SaveAddressDatasource>(
          SaveAddressImpDatasource.new,
        ),
        i.addLazySingleton<GetSavedAddressesDatasource>(
          GetSavedAddressesImpDatasource.new,
        ),

        //Clients http
        i.addLazySingleton(ViaCepClientHttps.new),

        //Blocs
        i.addLazySingleton(MainWrapperBloc.new),
        i.addLazySingleton(MapPageBloc.new),
        i.addLazySingleton(LocationsListBloc.new),
        i.add(SaveLocationBloc.new),
      ];

  @override
  void routes(r) => [
        r.child(
          '/',
          child: (context) => const MainWrapper(),
        ),
        r.child(
          '/saveLocation',
          child: (context) => SaveLocationPage(
            selectedAddress: r.args.data['selectedAddress'],
            isEditing: r.args.data['isEditing'],
          ),
        ),
      ];
}
