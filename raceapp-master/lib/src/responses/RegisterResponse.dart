enum RegisterResponseStatus {
  Success,
  UserAlreadyExists,
  PasswordShort,
  EmailInvalid,
  EmailPasswordRequired,
  NetworkError,
  UnknowError
}

class RegisterResponse {
  RegisterResponseStatus status;
  String errorMessage;
  String token;

  RegisterResponse(this.status, this.errorMessage, [this.token]);

  RegisterResponse.success(token, errorMessage)
      : this(RegisterResponseStatus.Success, errorMessage, token);

  RegisterResponse.userDuplicate(errorMessage)
      : this(RegisterResponseStatus.UserAlreadyExists, errorMessage);

  RegisterResponse.passwordShort(errorMessage)
      : this(RegisterResponseStatus.PasswordShort, errorMessage);

  RegisterResponse.emailInvalid(errorMessage)
      : this(RegisterResponseStatus.EmailInvalid, errorMessage);

  RegisterResponse.emailPasswordRequired(errorMessage)
      : this(RegisterResponseStatus.EmailPasswordRequired, errorMessage);

  RegisterResponse.networkError(errorMessage)
      : this(RegisterResponseStatus.NetworkError, errorMessage);

  RegisterResponse.unknowError(errorMessage)
      : this(RegisterResponseStatus.UnknowError, errorMessage);
}
