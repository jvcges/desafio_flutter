//Uma exceção customizada permite que o app normalize os erros recebidos em uma mesma estrutura
//Ela pode ser adaptada na implementação do client para atender a requisitos específicos da API utilizada
//Costumo criar nos meus projetos pois fica reutilizável e bem legível no código
class CustomException implements Exception {
  final String? message;
  final String? error;
  final String? title;
  final int? statusCode;
  final StackTrace? stackTrace;
  final dynamic exception;

  CustomException({
    this.title,
    this.message,
    this.error,
    this.statusCode,
    this.stackTrace,
    this.exception,
  });
}
