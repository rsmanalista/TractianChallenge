import 'package:challenge/Classes/retorno.dart';
import 'package:challenge/Model/assets.dart';
import 'package:challenge/Model/companies.dart';
import 'package:challenge/Model/locations.dart';
import 'package:dio/dio.dart';

class TractianApi {
  static Future<Retorno> getCompanies() async {
    Retorno retorno = Retorno();
    try {
      var dio = Dio();
      Response response =
          await dio.get("https://fake-api.tractian.com/companies");
      List<dynamic> ret = response.data;
      List<Companies> companies = [];
      for (int i = 0; i < ret.length; i++) {
        Companies companie = Companies();
        companie.id = ret[i]["id"].toString();
        companie.name = ret[i]["name"].toString();

        companies.add(companie);
      }
      if (companies.length > 0) {
        retorno.companies = companies;
      }
    } catch (ex) {
      retorno.erro = true;
      retorno.desc_erro = "Falha ao trazer companias: " + ex.toString();
    }
    return retorno;
  }

  static Future<Retorno> getLocations(String idCompanie) async {
    Retorno retorno = Retorno();
    try {
      var dio = Dio();
      Response response = await dio
          .get("https://fake-api.tractian.com/companies/$idCompanie/locations");
      List<dynamic> ret = response.data;
      List<Locations> locations = [];
      for (int i = 0; i < ret.length; i++) {
        Locations location = Locations();
        location.id = ret[i]["id"].toString();
        location.name = ret[i]["name"].toString();
        location.parentId = ret[i]["parentId"].toString();
        locations.add(location);
      }
      if (locations.length > 0) {
        retorno.locations = locations;
      }
    } catch (ex) {
      retorno.erro = true;
      retorno.desc_erro = "Falha ao trazer localizacoes: " + ex.toString();
    }
    return retorno;
  }

  static Future<Retorno> getAssets(String idCompanie) async {
    Retorno retorno = Retorno();
    try {
      var dio = Dio();
      Response response = await dio
          .get("https://fake-api.tractian.com/companies/$idCompanie/assets");
      List<dynamic> ret = response.data;
      List<Assets> assets = [];
      for (int i = 0; i < ret.length; i++) {
        Assets asset = Assets();
        asset.gatewayId = ret[i]["gatewayId"].toString();
        asset.id = ret[i]["id"].toString();
        asset.locationId = ret[i]["locationId"].toString();
        asset.name = ret[i]["name"].toString();
        asset.parentId = ret[i]["parentId"].toString();
        asset.sensorId = ret[i]["sensorId"].toString();
        asset.sensorType = ret[i]["sensorType"].toString();
        asset.status = ret[i]["status"].toString();

        assets.add(asset);
      }
      if (assets.length > 0) {
        retorno.assets = assets;
      }
    } catch (ex) {
      retorno.erro = true;
      retorno.desc_erro = "Falha ao trazer assets: " + ex.toString();
    }
    return retorno;
  }
}
