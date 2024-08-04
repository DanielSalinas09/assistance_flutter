


class AppException implements Exception{

  final int _code;
  final String _message;
  final String _prefix;

  const AppException(this._code,this._message,this._prefix);

  int get code=>_code;
  String get message=>_message;
  String get prefix=>_prefix;

}
class SuccesRequesetExcetion extends AppException{
   SuccesRequesetExcetion():super(400,'ok','success: ');
}
class BadRequestException extends AppException{
  BadRequestException(String message):super(400,message,'Invalid Request: ');
}

class FetchDataException extends AppException {
  FetchDataException(String message):super(400,message,'Error During Communication: ');
}
class UnauthorizedException extends AppException {
  UnauthorizedException(String message):super(401,message,'Unauthorized: ');
}

class NotFoundException extends AppException {
  NotFoundException(String message):super(404,message,'Not found: ');
}

class InternalServerException extends AppException {
  InternalServerException(String message):super(500,message,'Internal Server Error: ');
}