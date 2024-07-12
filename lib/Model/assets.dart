import 'package:challenge/Model/locations.dart';

class Assets {
  String? gatewayId;
  String? id;
  String? locationId;
  String? name;
  String? parentId;
  String? sensorId;
  String? sensorType;
  String? status;
  bool expandido = false;
  List<Assets>? subAssets = [];
  List<Assets>? componentes = [];
  Locations? location;
  Locations? subLocation;

  Assets({this.gatewayId, this.id, this.locationId, this.name, this.parentId, this.sensorId, this.sensorType, this.status, this.subAssets, this.componentes, this.location, this.subLocation});
}
