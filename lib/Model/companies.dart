import 'package:challenge/Model/assets.dart';
import 'package:challenge/Model/locations.dart';

class Companies {
  String? id;
  String? name;
  List<Assets>? assets = [];
  List<Locations>? locations = [];

  Companies({this.id, this.name, this.assets, this.locations});
}
