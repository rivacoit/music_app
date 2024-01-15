String removeErrorCode(String fullErrorMessage) {
  if (fullErrorMessage.startsWith('[') && fullErrorMessage.contains(']')) {
    int closingBracketIndex = fullErrorMessage.indexOf(']');
    return fullErrorMessage.substring(closingBracketIndex + 1).trim();
  } else {
    return fullErrorMessage;
  }
}
