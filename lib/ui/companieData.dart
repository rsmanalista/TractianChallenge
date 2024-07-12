import 'package:challenge/Api/TractianApi.dart';
import 'package:challenge/Classes/arvore.dart';
import 'package:challenge/Classes/retorno.dart';
import 'package:challenge/Classes/threeView.dart';
import 'package:challenge/Model/assets.dart';
import 'package:challenge/Model/companies.dart';
import 'package:challenge/Model/locations.dart';
import 'package:flutter/material.dart';

class CompanieData extends StatefulWidget {
  final Companies? companie;
  const CompanieData({super.key, this.companie});

  @override
  State<CompanieData> createState() => _CompanieDataState();
}

class _CompanieDataState extends State<CompanieData> {
  var _pesquisa = TextEditingController();
  Color colorLabel = Colors.grey[500]!;
  Color colorIcon = Colors.grey[500]!;
  bool sensorEnergia = false, critico = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Image(image: AssetImage("assets/logo.png"))],
        ),
        backgroundColor: Color.fromRGBO(26, 45, 106, 1),
      ),
      body: FutureBuilder<ThreeView>(
        future: getDados(widget.companie!.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            ThreeView tRetorno = snapshot.data!;
            return StatefulBuilder(builder: (builder, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _pesquisa,
                      onChanged: (value) {
                        //_pagingControllerEventos.refresh();
                      },
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                          labelText: "Pesquisar Evento",
                          labelStyle: TextStyle(color: colorLabel),
                          prefixIconColor: colorIcon,
                          prefixIcon: Icon(Icons.search),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colorLabel, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          style: sensorEnergia ? const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blueAccent)) : null,
                          onPressed: () async {
                            sensorEnergia = !sensorEnergia;
                            if (sensorEnergia) {
                              critico = false;
                            }
                            tRetorno = await FiltrarDados(widget.companie!.id!, "");
                            state(() {});
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bolt,
                                color: Colors.black,
                              ),
                              Text(
                                "Sensor de Energia",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                            child: ElevatedButton(
                          style: critico ? const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blueAccent)) : null,
                          onPressed: () async {
                            critico = !critico;
                            if (critico) {
                              sensorEnergia = false;
                            }
                            tRetorno = await FiltrarDados(widget.companie!.id!, "");
                            state(() {});
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.dangerous,
                                color: Colors.black,
                              ),
                              Text(
                                "Crítico",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var value in tRetorno.locations!)
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    value.expandido = !value.expandido;
                                    state(() {});
                                  },
                                  child: Card(
                                    color: value.expandido ? Colors.amberAccent : null,
                                    elevation: 10,
                                    child: ListTile(
                                      leading: const Image(
                                        image: AssetImage("assets/location.png"),
                                      ),
                                      title: Text(
                                        value.name!.toUpperCase(),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                if (value.expandido)
                                  for (var valueProx in value.subLocations)
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 20),
                                          child: InkWell(
                                            onTap: () {
                                              valueProx.expandido = !valueProx.expandido;
                                              state(() {});
                                            },
                                            child: Card(
                                              color: valueProx.expandido ? Colors.amberAccent : null,
                                              elevation: 10,
                                              child: ListTile(
                                                leading: const Image(
                                                  image: AssetImage("assets/location.png"),
                                                ),
                                                title: Text(
                                                  valueProx.name!.toUpperCase(),
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (valueProx.expandido)
                                          for (var valueProxAsset in valueProx.assets)
                                            Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(left: 40),
                                                  child: InkWell(
                                                    onTap: () {
                                                      valueProxAsset.expandido = !valueProxAsset.expandido;
                                                      state(() {});
                                                    },
                                                    child: Card(
                                                      color: valueProxAsset.expandido ? Colors.amberAccent : null,
                                                      elevation: 10,
                                                      child: ListTile(
                                                        leading: Image(
                                                          image: valueProxAsset.sensorType == "null" ? AssetImage("assets/asset.png") : AssetImage("assets/component.png"),
                                                        ),
                                                        title: Text(
                                                          valueProxAsset.name!.toUpperCase(),
                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        trailing: valueProxAsset.status == "alert"
                                                            ? Icon(
                                                                Icons.dangerous,
                                                                color: Colors.red,
                                                              )
                                                            : valueProxAsset.sensorType == "energy"
                                                                ? Icon(
                                                                    Icons.bolt,
                                                                    color: Colors.green,
                                                                  )
                                                                : null,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (valueProxAsset.expandido && valueProxAsset.subAssets != null)
                                                  for (var valueProxSubAsset in valueProxAsset.subAssets!)
                                                    Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.only(left: 60),
                                                          child: InkWell(
                                                            onTap: () {
                                                              valueProxSubAsset.expandido = !valueProxSubAsset.expandido;
                                                              state(() {});
                                                            },
                                                            child: Card(
                                                              color: valueProxSubAsset.expandido ? Colors.amberAccent : null,
                                                              elevation: 10,
                                                              child: ListTile(
                                                                leading: const Image(
                                                                  image: AssetImage("assets/asset.png"),
                                                                ),
                                                                title: Text(
                                                                  valueProxSubAsset.name!.toUpperCase(),
                                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        if (valueProxSubAsset.expandido && valueProxSubAsset.componentes != null)
                                                          for (var valueProxSubAssetComponent in valueProxSubAsset.componentes!)
                                                            Container(
                                                              padding: EdgeInsets.only(left: 80),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  valueProxSubAssetComponent.expandido = !valueProxSubAssetComponent.expandido;
                                                                  state(() {});
                                                                },
                                                                child: Card(
                                                                  color: valueProxSubAssetComponent.expandido ? Colors.amberAccent : null,
                                                                  elevation: 10,
                                                                  child: ListTile(
                                                                    leading: const Image(
                                                                      image: AssetImage("assets/component.png"),
                                                                    ),
                                                                    title: Text(
                                                                      valueProxSubAssetComponent.name!.toUpperCase(),
                                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                                    ),
                                                                    trailing: valueProxSubAssetComponent.status == "alert"
                                                                        ? Icon(
                                                                            Icons.dangerous,
                                                                            color: Colors.red,
                                                                          )
                                                                        : valueProxSubAssetComponent.sensorType == "energy"
                                                                            ? Icon(
                                                                                Icons.bolt,
                                                                                color: Colors.green,
                                                                              )
                                                                            : null,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                      ],
                                                    ),
                                                if (valueProxAsset.expandido && valueProxAsset.componentes != null)
                                                  for (var valueProxAssetCompnent in valueProxAsset.componentes!)
                                                    Container(
                                                      padding: EdgeInsets.only(left: 40),
                                                      child: InkWell(
                                                        onTap: () {
                                                          valueProxAssetCompnent.expandido = !valueProxAssetCompnent.expandido;
                                                          state(() {});
                                                        },
                                                        child: Card(
                                                          color: valueProxAssetCompnent.expandido ? Colors.amberAccent : null,
                                                          elevation: 10,
                                                          child: ListTile(
                                                            leading: const Image(
                                                              image: AssetImage("assets/component.png"),
                                                            ),
                                                            title: Text(
                                                              valueProxAssetCompnent.name!.toUpperCase(),
                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                            trailing: valueProxAssetCompnent.status == "alert"
                                                                ? Icon(
                                                                    Icons.dangerous,
                                                                    color: Colors.red,
                                                                  )
                                                                : valueProxAssetCompnent.sensorType == "energy"
                                                                    ? Icon(
                                                                        Icons.bolt,
                                                                        color: Colors.green,
                                                                      )
                                                                    : null,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                              ],
                                            ),
                                      ],
                                    ),
                                if (value.expandido)
                                  for (var valueProxAssets in value.assets)
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 30),
                                          child: InkWell(
                                            child: Card(
                                              color: valueProxAssets.expandido ? Colors.amberAccent : null,
                                              elevation: 10,
                                              child: ListTile(
                                                leading: Image(
                                                  image: valueProxAssets.sensorType == "null" ? AssetImage("assets/asset.png") : AssetImage("assets/component.png"),
                                                ),
                                                title: Text(
                                                  valueProxAssets.name!.toUpperCase(),
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                trailing: valueProxAssets.status == "alert"
                                                    ? Icon(
                                                        Icons.dangerous,
                                                        color: Colors.red,
                                                      )
                                                    : valueProxAssets.sensorType == "energy"
                                                        ? Icon(
                                                            Icons.bolt,
                                                            color: Colors.green,
                                                          )
                                                        : null,
                                              ),
                                            ),
                                            onTap: () {
                                              valueProxAssets.expandido = !valueProxAssets.expandido;
                                              state(() {});
                                            },
                                          ),
                                        ),
                                        if (valueProxAssets.expandido && valueProxAssets.subAssets != null)
                                          for (var valueProxSubAssets in valueProxAssets.subAssets!)
                                            Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(left: 70),
                                                  child: InkWell(
                                                    child: Card(
                                                      color: valueProxSubAssets.expandido ? Colors.amberAccent : null,
                                                      elevation: 10,
                                                      child: ListTile(
                                                        leading: const Image(
                                                          image: AssetImage("assets/asset.png"),
                                                        ),
                                                        title: Text(
                                                          valueProxSubAssets.name!.toUpperCase(),
                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      valueProxSubAssets.expandido = !valueProxSubAssets.expandido;
                                                      state(() {});
                                                    },
                                                  ),
                                                ),
                                                if (valueProxSubAssets.expandido && valueProxSubAssets.componentes != null)
                                                  for (var valueProxComp in valueProxSubAssets.componentes!)
                                                    Container(
                                                      padding: EdgeInsets.only(left: 70),
                                                      child: InkWell(
                                                        child: Card(
                                                          color: valueProxSubAssets.expandido ? Colors.amberAccent : null,
                                                          elevation: 10,
                                                          child: ListTile(
                                                            leading: const Image(
                                                              image: AssetImage("assets/component.png"),
                                                            ),
                                                            title: Text(
                                                              valueProxComp.name!.toUpperCase(),
                                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                            trailing: valueProxComp.status == "alert"
                                                                ? Icon(
                                                                    Icons.dangerous,
                                                                    color: Colors.red,
                                                                  )
                                                                : valueProxComp.sensorType == "energy"
                                                                    ? Icon(
                                                                        Icons.bolt,
                                                                        color: Colors.green,
                                                                      )
                                                                    : null,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          valueProxSubAssets.expandido = !valueProxSubAssets.expandido;
                                                          state(() {});
                                                        },
                                                      ),
                                                    ),
                                              ],
                                            ),
                                        if (valueProxAssets.expandido && valueProxAssets.componentes != null)
                                          for (var valueProxAssetsComponentes in valueProxAssets.componentes!)
                                            Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(left: 60),
                                                  child: InkWell(
                                                    child: Card(
                                                      color: valueProxAssetsComponentes.expandido ? Colors.amberAccent : null,
                                                      elevation: 10,
                                                      child: ListTile(
                                                        leading: const Image(
                                                          image: AssetImage("assets/component.png"),
                                                        ),
                                                        title: Text(
                                                          valueProxAssetsComponentes.name!.toUpperCase(),
                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                        trailing: valueProxAssetsComponentes.status == "alert"
                                                            ? Icon(
                                                                Icons.dangerous,
                                                                color: Colors.red,
                                                              )
                                                            : valueProxAssetsComponentes.sensorType == "energy"
                                                                ? Icon(
                                                                    Icons.bolt,
                                                                    color: Colors.green,
                                                                  )
                                                                : null,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      valueProxAssetsComponentes.expandido = !valueProxAssetsComponentes.expandido;
                                                      state(() {});
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                      ],
                                    ),
                              ],
                            ),
                          for (var valueProxAssets in tRetorno.assets!)
                            Column(
                              children: [
                                Container(
                                  child: Card(
                                    elevation: 10,
                                    child: ListTile(
                                      leading: Image(
                                        image: valueProxAssets.sensorType != "null" ? AssetImage("assets/component.png") : AssetImage("assets/component.png"),
                                      ),
                                      title: Text(
                                        valueProxAssets.name!.toUpperCase(),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      trailing: valueProxAssets.status == "alert"
                                          ? Icon(
                                              Icons.dangerous,
                                              color: Colors.red,
                                            )
                                          : valueProxAssets.sensorType == "energy"
                                              ? Icon(
                                                  Icons.bolt,
                                                  color: Colors.green,
                                                )
                                              : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<ThreeView> getDados(String idCompanie) async {
    List<Companies> retorno = [];
    Retorno retLocations = await TractianApi.getLocations(idCompanie);
    Retorno retAssets = await TractianApi.getAssets(idCompanie);
    retorno.add(Companies(id: idCompanie, locations: retLocations.locations, assets: retAssets.assets));

    return await montarDados2(retorno[0]);
  }

  Future<ThreeView> montarDados(Companies companie) async {
    ThreeView threeView = ThreeView();
    for (Assets asset in companie.assets!) {
      if (asset.parentId == "null" && asset.locationId == "null") {
        threeView.assets!.add(asset);
      }
    }
    for (Locations location in companie.locations!) {
      if (location.parentId == "null") {
        threeView.locations!.add(location);
      }
    }
    for (Locations location in threeView.locations!) {
      if (companie.locations!.where((v) => v.parentId == location.id).isNotEmpty) {
        for (Locations sublocation in companie.locations!.where((v) => v.parentId == location.id).toList()) {
          if (companie.assets!.where((v) => v.locationId == sublocation.id).isNotEmpty) {
            for (Assets asset in companie.assets!.where((v) => v.locationId == sublocation.id).toList()) {
              if (companie.assets!.where((v) => v.parentId == asset.id).isNotEmpty) {
                for (Assets subasset in companie.assets!.where((v) => v.parentId == asset.id).toList()) {
                  if (subasset.sensorType != "null") {
                    subasset.subAssets == null ? subasset.subAssets = [asset] : subasset.subAssets!.add(asset);
                  } else {
                    subasset.componentes == null ? subasset.componentes = [asset] : subasset.componentes!.add(asset);
                  }
                }
              }
              sublocation.assets.add(asset);
            }
          }
          location.subLocations.add(sublocation);
        }
      }
      if (companie.assets!.where((v) => v.locationId == location.id).isNotEmpty) {
        for (Assets asset in companie.assets!.where((v) => v.locationId == location.id).toList()) {
          if (companie.assets!.where((v) => v.parentId == asset.id).isNotEmpty) {
            for (Assets subasset in companie.assets!.where((v) => v.parentId == asset.id).toList()) {
              if (subasset.sensorType != "null") {
                subasset.subAssets == null ? subasset.subAssets = [asset] : subasset.subAssets!.add(asset);
              } else {
                subasset.componentes == null ? subasset.componentes = [asset] : subasset.componentes!.add(asset);
              }
            }
          }
          location.assets.add(asset);
        }
      }
    }
    return threeView;
  }

  Future<ThreeView> montarDados2(Companies companie) async {
    List<Locations> locations = [];
    List<Assets> assets = [];

    if (companie.locations!.where((v) => v.parentId == "null").isNotEmpty) {
      for (Locations l in companie.locations!.where((v) => v.parentId == "null").toList()) {
        if (companie.locations!.where((v) => v.parentId == l.id).isNotEmpty) {
          for (Locations subl in companie.locations!.where((v) => v.parentId == l.id).toList()) {
            l.subLocations.isEmpty ? l.subLocations = [subl] : l.subLocations.add(subl);
          }
        }
        locations.isEmpty ? locations = [l] : locations.add(l);
      }
    }

    if (companie.assets!.where((v) => v.parentId == "null" && v.locationId == "null").isNotEmpty) {
      for (Assets a in companie.assets!.where((v) => v.parentId == "null" && v.locationId == "null").toList()) {
        if (companie.assets!.where((v) => v.parentId == a.id).isNotEmpty) {
          for (Assets suba in companie.assets!.where((v) => v.parentId == a.id).toList()) {
            if (suba.sensorType == "null") {
              a.subAssets == null || a.subAssets!.isEmpty ? a.subAssets = [suba] : a.subAssets!.add(suba);
            } else {
              a.componentes == null || a.componentes!.isEmpty ? a.componentes = [suba] : a.componentes!.add(suba);
            }
          }
        }
        assets.isEmpty ? assets = [a] : assets.add(a);
      }
    }
    if (companie.assets!.where((v) => v.locationId != "null").isNotEmpty) {
      for (Assets a in companie.assets!.where((v) => v.locationId != "null").toList()) {
        if (companie.assets!.where((v) => v.parentId == a.id).isNotEmpty) {
          for (Assets suba in companie.assets!.where((v) => v.parentId == a.id).toList()) {
            if (suba.sensorType == "null") {
              a.subAssets == null || a.subAssets!.isEmpty ? a.subAssets = [suba] : a.subAssets!.add(suba);
            } else {
              a.componentes == null || a.componentes!.isEmpty ? a.componentes = [suba] : a.componentes!.add(suba);
            }
          }
        }

        Locations lId = companie.locations!.where((v) => v.id == a.locationId).first;
        for (Locations lOriginal in locations) {
          if (lOriginal == lId) {
            lOriginal.assets.isEmpty ? lOriginal.assets = [a] : lOriginal.assets.add(a);
          } else if (lOriginal.subLocations.where((v) => v.id == lId.id).isNotEmpty) {
            lOriginal.subLocations.where((v) => v.id == lId.id).first.assets.isEmpty ? lOriginal.subLocations.where((v) => v.id == lId.id).first.assets = [a] : lOriginal.subLocations.where((v) => v.id == lId.id).first.assets.add(a);
          }
        }
      }
    }

    if (companie.assets!.where((v) => v.parentId != "null").isNotEmpty) {
      for (Assets a in companie.assets!.where((v) => v.parentId != "null").toList()) {
        if (companie.assets!.where((v) => v.parentId == a.id).isNotEmpty) {
          for (Assets suba in companie.assets!.where((v) => v.parentId == a.id).toList()) {
            if (suba.sensorType == "null") {
              a.subAssets == null || a.subAssets!.isEmpty ? a.subAssets = [suba] : a.subAssets!.add(suba);
            } else {
              a.componentes == null || a.componentes!.isEmpty ? a.componentes = [suba] : a.componentes!.add(suba);
            }
          }
        }
        /*
        for (Locations l in locations) {
          if (l.assets.where((v) => v.id == a.parentId).isNotEmpty) {
            if (l.assets.where((v) => v.id == a.parentId).first.sensorType == "null") {
              l.assets.where((v) => v.id == a.parentId).first.subAssets == null || l.assets.where((v) => v.id == a.parentId).first.subAssets!.isEmpty ? l.assets.where((v) => v.id == a.parentId).first.subAssets = [a] : l.assets.where((v) => v.id == a.parentId).first.subAssets!.add(a);
            } else {
              l.assets.where((v) => v.id == a.parentId).first.componentes == null || l.assets.where((v) => v.id == a.parentId).first.componentes!.isEmpty ? l.assets.where((v) => v.id == a.parentId).first.componentes = [a] : l.assets.where((v) => v.id == a.parentId).first.componentes!.add(a);
            }
          } else {
            for (Assets asub in l.assets) {
              if (asub.subAssets != null && asub.subAssets!.where((v) => v.id == a.parentId).isNotEmpty) {
                if (asub.subAssets!.where((v) => v.id == a.parentId).first.sensorType == "null") {
                  asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets == null || asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets!.isEmpty ? asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets = [a] : asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets!.add(a);
                } else {
                  asub.subAssets!.where((v) => v.id == a.parentId).first.componentes == null || asub.subAssets!.where((v) => v.id == a.parentId).first.componentes!.isEmpty ? asub.subAssets!.where((v) => v.id == a.parentId).first.componentes = [a] : asub.subAssets!.where((v) => v.id == a.parentId).first.componentes!.add(a);
                }
              }
            }
            for (Locations subl in l.subLocations) {
              if (subl.assets.where((v) => v.id == a.parentId).isNotEmpty) {
                if (subl.assets.where((v) => v.id == a.parentId).first.sensorType == "null") {
                  subl.assets.where((v) => v.id == a.parentId).first.subAssets == null || subl.assets.where((v) => v.id == a.parentId).first.subAssets!.isEmpty ? subl.assets.where((v) => v.id == a.parentId).first.subAssets = [a] : subl.assets.where((v) => v.id == a.parentId).first.subAssets!.add(a);
                } else {
                  subl.assets.where((v) => v.id == a.parentId).first.componentes == null || subl.assets.where((v) => v.id == a.parentId).first.componentes!.isEmpty ? subl.assets.where((v) => v.id == a.parentId).first.componentes = [a] : subl.assets.where((v) => v.id == a.parentId).first.componentes!.add(a);
                }
              } else
                for (Assets asub in subl.assets) {
                  if (asub.subAssets != null && asub.subAssets!.where((v) => v.id == a.parentId).isNotEmpty) {
                    if (asub.subAssets!.where((v) => v.id == a.parentId).first.sensorType == "null") {
                      asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets == null || asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets!.isEmpty ? asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets = [a] : asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets!.add(a);
                    } else {
                      asub.subAssets!.where((v) => v.id == a.parentId).first.componentes == null || asub.subAssets!.where((v) => v.id == a.parentId).first.componentes!.isEmpty ? asub.subAssets!.where((v) => v.id == a.parentId).first.componentes = [a] : asub.subAssets!.where((v) => v.id == a.parentId).first.componentes!.add(a);
                    }
                  }
                }
            }
          }
        }
      */
      }
    }

    return ThreeView(locations: locations, assets: assets);
  }

  Future<ThreeView> FiltrarDados(String idCompanie, String pesquisa) async {
    List<Companies> retorno = [];
    Retorno retLocations = await TractianApi.getLocations(idCompanie);
    Retorno retAssets = await TractianApi.getAssets(idCompanie);
    retorno.add(Companies(id: idCompanie, locations: retLocations.locations, assets: retAssets.assets));
    Companies companie = retorno[0];

    List<Locations> locationsPesquisa = [];
    List<Assets> assetsPesquisa = [];
    if (sensorEnergia) {
      if (companie.assets!.where((v) => v.sensorType == "energy").isNotEmpty) {
        for (Assets asst in companie.assets!.where((v) => v.sensorType == "energy").toList()) {
          asst.expandido = true;
          assetsPesquisa.isEmpty
              ? assetsPesquisa = [asst]
              : assetsPesquisa.where((v) => v.id == asst.id).isEmpty
                  ? assetsPesquisa.add(asst)
                  : null;
          if (companie.assets!.where((v) => v.id == asst.parentId).isNotEmpty) {
            for (Assets asstId in companie.assets!.where((v) => v.id == asst.parentId).toList()) {
              asstId.expandido = true;
              assetsPesquisa.where((v) => v.id == asstId.id).isEmpty ? assetsPesquisa.add(asstId) : null;
              if (companie.locations!.where((v) => v.id == asstId.locationId).isNotEmpty) {
                for (Locations locId in companie.locations!.where((v) => v.id == asstId.locationId).toList()) {
                  locId.expandido = true;
                  locationsPesquisa.isEmpty
                      ? locationsPesquisa = [locId]
                      : locationsPesquisa.where((v) => v.id == locId.id).isEmpty
                          ? locationsPesquisa.add(locId)
                          : null;
                  if (companie.locations!.where((v) => v.parentId == locId.id).isNotEmpty) {
                    for (Locations locIdParent in companie.locations!.where((v) => v.parentId == locId.id).toList()) {
                      locIdParent.expandido = true;
                      locationsPesquisa.where((v) => v.id == locIdParent.id).isEmpty ? locationsPesquisa.add(locIdParent) : null;
                    }
                  }
                }
              }
            }
          }

          if (companie.locations!.where((v) => v.id == asst.locationId).isNotEmpty) {
            for (Locations locId in companie.locations!.where((v) => v.id == asst.locationId).toList()) {
              locId.expandido = true;
              locationsPesquisa.isEmpty
                  ? locationsPesquisa = [locId]
                  : locationsPesquisa.where((v) => v.id == locId.id).isEmpty
                      ? locationsPesquisa.add(locId)
                      : null;
              if (companie.locations!.where((v) => v.id == locId.parentId).isNotEmpty) {
                for (Locations locIdParent in companie.locations!.where((v) => v.id == locId.parentId).toList()) {
                  locIdParent.expandido = true;
                  locationsPesquisa.where((v) => v.id == locIdParent.id).isEmpty ? locationsPesquisa.add(locIdParent) : null;
                }
              }
            }
          }
        }
      }
    }

    if (critico) {
      if (companie.assets!.where((v) => v.status == "alert").isNotEmpty) {
        for (Assets asst in companie.assets!.where((v) => v.status == "alert").toList()) {
          asst.expandido = true;
          assetsPesquisa.isEmpty
              ? assetsPesquisa = [asst]
              : assetsPesquisa.where((v) => v.id == asst.id).isEmpty
                  ? assetsPesquisa.add(asst)
                  : null;
          if (companie.assets!.where((v) => v.id == asst.parentId).isNotEmpty) {
            for (Assets asstId in companie.assets!.where((v) => v.id == asst.parentId).toList()) {
              asstId.expandido = true;
              assetsPesquisa.where((v) => v.id == asstId.id).isEmpty ? assetsPesquisa.add(asstId) : null;
              if (companie.locations!.where((v) => v.id == asstId.locationId).isNotEmpty) {
                for (Locations locId in companie.locations!.where((v) => v.id == asstId.locationId).toList()) {
                  locId.expandido = true;
                  locationsPesquisa.isEmpty
                      ? locationsPesquisa = [locId]
                      : locationsPesquisa.where((v) => v.id == locId.id).isEmpty
                          ? locationsPesquisa.add(locId)
                          : null;
                  if (companie.locations!.where((v) => v.parentId == locId.id).isNotEmpty) {
                    for (Locations locIdParent in companie.locations!.where((v) => v.parentId == locId.id).toList()) {
                      locIdParent.expandido = true;
                      locationsPesquisa.where((v) => v.id == locIdParent.id).isEmpty ? locationsPesquisa.add(locIdParent) : null;
                    }
                  }
                }
              }
            }
          }

          if (companie.locations!.where((v) => v.id == asst.locationId).isNotEmpty) {
            for (Locations locId in companie.locations!.where((v) => v.id == asst.locationId).toList()) {
              locId.expandido = true;
              locationsPesquisa.isEmpty
                  ? locationsPesquisa = [locId]
                  : locationsPesquisa.where((v) => v.id == locId.id).isEmpty
                      ? locationsPesquisa.add(locId)
                      : null;
              if (companie.locations!.where((v) => v.id == locId.parentId).isNotEmpty) {
                for (Locations locIdParent in companie.locations!.where((v) => v.id == locId.parentId).toList()) {
                  locIdParent.expandido = true;
                  locationsPesquisa.where((v) => v.id == locIdParent.id).isEmpty ? locationsPesquisa.add(locIdParent) : null;
                }
              }
            }
          }
        }
      }
    }

    if (sensorEnergia || critico) {
      companie.assets = assetsPesquisa;
      companie.locations = locationsPesquisa;
    }

    List<Locations> locations = [];
    List<Assets> assets = [];

    if (companie.locations!.where((v) => v.parentId == "null").isNotEmpty) {
      for (Locations l in companie.locations!.where((v) => v.parentId == "null").toList()) {
        if (companie.locations!.where((v) => v.parentId == l.id).isNotEmpty) {
          for (Locations subl in companie.locations!.where((v) => v.parentId == l.id).toList()) {
            l.subLocations.isEmpty ? l.subLocations = [subl] : l.subLocations.add(subl);
          }
        }
        locations.isEmpty ? locations = [l] : locations.add(l);
      }
    }

    if (companie.assets!.where((v) => v.parentId == "null" && v.locationId == "null").isNotEmpty) {
      for (Assets a in companie.assets!.where((v) => v.parentId == "null" && v.locationId == "null").toList()) {
        if (companie.assets!.where((v) => v.parentId == a.id).isNotEmpty) {
          for (Assets suba in companie.assets!.where((v) => v.parentId == a.id).toList()) {
            if (suba.sensorType == "null") {
              a.subAssets == null || a.subAssets!.isEmpty ? a.subAssets = [suba] : a.subAssets!.add(suba);
            } else {
              a.componentes == null || a.componentes!.isEmpty ? a.componentes = [suba] : a.componentes!.add(suba);
            }
          }
        }
        assets.isEmpty ? assets = [a] : assets.add(a);
      }
    }
    if (companie.assets!.where((v) => v.locationId != "null").isNotEmpty) {
      for (Assets a in companie.assets!.where((v) => v.locationId != "null").toList()) {
        if (companie.assets!.where((v) => v.parentId == a.id).isNotEmpty) {
          for (Assets suba in companie.assets!.where((v) => v.parentId == a.id).toList()) {
            if (suba.sensorType == "null") {
              a.subAssets == null || a.subAssets!.isEmpty ? a.subAssets = [suba] : a.subAssets!.add(suba);
            } else {
              a.componentes == null || a.componentes!.isEmpty ? a.componentes = [suba] : a.componentes!.add(suba);
            }
          }
        }

        Locations lId = companie.locations!.where((v) => v.id == a.locationId).first;
        for (Locations lOriginal in locations) {
          if (lOriginal == lId) {
            lOriginal.assets.isEmpty ? lOriginal.assets = [a] : lOriginal.assets.add(a);
          } else if (lOriginal.subLocations.where((v) => v.id == lId.id).isNotEmpty) {
            lOriginal.subLocations.where((v) => v.id == lId.id).first.assets.isEmpty ? lOriginal.subLocations.where((v) => v.id == lId.id).first.assets = [a] : lOriginal.subLocations.where((v) => v.id == lId.id).first.assets.add(a);
          }
        }
      }
    }

    if (companie.assets!.where((v) => v.parentId != "null").isNotEmpty) {
      for (Assets a in companie.assets!.where((v) => v.parentId != "null").toList()) {
        if (companie.assets!.where((v) => v.parentId == a.id).isNotEmpty) {
          for (Assets suba in companie.assets!.where((v) => v.parentId == a.id).toList()) {
            if (suba.sensorType == "null") {
              a.subAssets == null || a.subAssets!.isEmpty ? a.subAssets = [suba] : a.subAssets!.add(suba);
            } else {
              a.componentes == null || a.componentes!.isEmpty ? a.componentes = [suba] : a.componentes!.add(suba);
            }
          }
        }
        /*
        for (Locations l in locations) {
          if (l.assets.where((v) => v.id == a.parentId).isNotEmpty) {
            if (l.assets.where((v) => v.id == a.parentId).first.sensorType == "null") {
              l.assets.where((v) => v.id == a.parentId).first.subAssets == null || l.assets.where((v) => v.id == a.parentId).first.subAssets!.isEmpty ? l.assets.where((v) => v.id == a.parentId).first.subAssets = [a] : l.assets.where((v) => v.id == a.parentId).first.subAssets!.add(a);
            } else {
              l.assets.where((v) => v.id == a.parentId).first.componentes == null || l.assets.where((v) => v.id == a.parentId).first.componentes!.isEmpty ? l.assets.where((v) => v.id == a.parentId).first.componentes = [a] : l.assets.where((v) => v.id == a.parentId).first.componentes!.add(a);
            }
          } else {
            for (Assets asub in l.assets) {
              if (asub.subAssets != null && asub.subAssets!.where((v) => v.id == a.parentId).isNotEmpty) {
                if (asub.subAssets!.where((v) => v.id == a.parentId).first.sensorType == "null") {
                  asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets == null || asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets!.isEmpty ? asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets = [a] : asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets!.add(a);
                } else {
                  asub.subAssets!.where((v) => v.id == a.parentId).first.componentes == null || asub.subAssets!.where((v) => v.id == a.parentId).first.componentes!.isEmpty ? asub.subAssets!.where((v) => v.id == a.parentId).first.componentes = [a] : asub.subAssets!.where((v) => v.id == a.parentId).first.componentes!.add(a);
                }
              }
            }
            for (Locations subl in l.subLocations) {
              if (subl.assets.where((v) => v.id == a.parentId).isNotEmpty) {
                if (subl.assets.where((v) => v.id == a.parentId).first.sensorType == "null") {
                  subl.assets.where((v) => v.id == a.parentId).first.subAssets == null || subl.assets.where((v) => v.id == a.parentId).first.subAssets!.isEmpty ? subl.assets.where((v) => v.id == a.parentId).first.subAssets = [a] : subl.assets.where((v) => v.id == a.parentId).first.subAssets!.add(a);
                } else {
                  subl.assets.where((v) => v.id == a.parentId).first.componentes == null || subl.assets.where((v) => v.id == a.parentId).first.componentes!.isEmpty ? subl.assets.where((v) => v.id == a.parentId).first.componentes = [a] : subl.assets.where((v) => v.id == a.parentId).first.componentes!.add(a);
                }
              } else
                for (Assets asub in subl.assets) {
                  if (asub.subAssets != null && asub.subAssets!.where((v) => v.id == a.parentId).isNotEmpty) {
                    if (asub.subAssets!.where((v) => v.id == a.parentId).first.sensorType == "null") {
                      asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets == null || asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets!.isEmpty ? asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets = [a] : asub.subAssets!.where((v) => v.id == a.parentId).first.subAssets!.add(a);
                    } else {
                      asub.subAssets!.where((v) => v.id == a.parentId).first.componentes == null || asub.subAssets!.where((v) => v.id == a.parentId).first.componentes!.isEmpty ? asub.subAssets!.where((v) => v.id == a.parentId).first.componentes = [a] : asub.subAssets!.where((v) => v.id == a.parentId).first.componentes!.add(a);
                    }
                  }
                }
            }
          }
        }
      */
      }
    }

    return ThreeView(locations: locations, assets: assets);
  }
}
