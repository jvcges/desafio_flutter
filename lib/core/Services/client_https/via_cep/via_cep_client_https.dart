import 'package:desafio_flutter/core/Services/client_https/base/client_base_impl.dart';
import 'package:desafio_flutter/core/Services/client_https/interceptors/error_handler_interceptors.dart';
import 'package:desafio_flutter/core/Services/client_https/interceptors/loggers_interceptors.dart';
import 'package:dio/dio.dart';

//Essa estrutura me permite criar um client http reutilizável e com tratamentos de exceção já configurados
//No caso do via cep nessa aplicação não seria necessário pois será utilizado uma única vez, mas fiz para mostrar a implementação
class ViaCepClientHttps extends ClientHttpsBaseImpl {
  ViaCepClientHttps({
    List<Interceptor>? interceptors,
  }) : super(
            BaseOptions(
              //Aqui é definida a url base do client, em uma aplicação real seria possível reaproveitar para todos os UCs do app que utilizassem a mesma API
              //Também é possível definir a URL base por meio de configuração remota, permitindo a troca do provedor de API sem necessidade de gerar uma nova build da aplicação
              baseUrl: "https://viacep.com.br/ws/",
            ),
            interceptors: [
              //Se essa API precisasse de Header, Authentication ou outras configurações, seria possível definir mais interceptors
              //O caso do Authentication é clássico, com um header interceptor o app seria capaz de interceptar uma chamada antes dela acontecer e inserir o token definido globalmente, eliminando a necessidade de colocar em cada UC
              ErrorsHandleInterceptors(),
              LoggersInterceptors(),
            ]);
}
