extension StringExtensions on String {
  bool isEmail() {
    if (this == null || this == "") return false;

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
    print(emailValid);
    return emailValid;
  }
}
