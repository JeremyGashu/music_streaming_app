import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class BaseDataProvider{
  final http.Client client;
  BaseDataProvider({@required this.client});
}