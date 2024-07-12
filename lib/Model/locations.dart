import 'package:challenge/Model/assets.dart';

class Locations {
  String? id;
  String? name;
  String? parentId;
  bool expandido = false;
  List<Locations> subLocations = [];
  List<Assets> assets = [];
}
