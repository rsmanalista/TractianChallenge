import 'package:challenge/Model/assets.dart';
import 'package:challenge/Model/companies.dart';
import 'package:challenge/Model/locations.dart';

class Retorno {
  bool erro = false;
  String? desc_erro;
  List<Companies> companies = [];
  List<Locations> locations = [];
  List<Assets> assets = [];
}
