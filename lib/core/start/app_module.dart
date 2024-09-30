import 'package:desafio_flutter/app/data/datasources/get_address_by_cep/get_address_by_cep_datasource.dart';
import 'package:desafio_flutter/app/data/repositories/get_address_by_cep/get_address_by_cep_imp_repository.dart';
import 'package:desafio_flutter/app/domain/repositories/get_address_by_cep/get_address_by_cep_repository.dart';
import 'package:desafio_flutter/app/domain/usecases/get_address_by_cep/get_address_by_cep_imp_usecase.dart';
import 'package:desafio_flutter/app/domain/usecases/get_address_by_cep/get_address_by_cep_usecase.dart';
import 'package:desafio_flutter/app/external/get_address_by_cep/get_address_by_cep_imp_datasource.dart';
import 'package:desafio_flutter/app/presentation/pages/main_wrapper/bloc/main_wrapper_bloc.dart';
import 'package:desafio_flutter/app/presentation/pages/main_wrapper/main_wrapper.dart';
import 'package:desafio_flutter/app/presentation/pages/map_page/bloc/map_page_bloc.dart';
import 'package:desafio_flutter/core/Services/client_https/via_cep/via_cep_client_https.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(i) => [
        //Usecases
        i.addLazySingleton<GetAddressByCepUsecase>(
            GetAddressByCepImpUsecase.new),

        //Repositories
        i.addLazySingleton<GetAddressByCepRepository>(
            GetAddressByCepImpRepository.new),

        //Datasources
        i.addLazySingleton<GetAddressByCepDatasource>(
            GetAddressByCepImpDatasource.new),

        //Clients http
        i.addLazySingleton(ViaCepClientHttps.new),

        //Blocs
        i.addLazySingleton(MainWrapperBloc.new),
        i.addLazySingleton(MapPageBloc.new),
      ];

  @override
  void routes(r) => [
        r.child(
          '/',
          child: (context) => const MainWrapper(),
        ),
      ];
}
