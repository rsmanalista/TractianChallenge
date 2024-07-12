import 'dart:convert';

import 'package:challenge/Api/TractianApi.dart';
import 'package:challenge/Classes/arvore.dart';
import 'package:challenge/Classes/retorno.dart';
import 'package:challenge/Model/companies.dart';
import 'package:challenge/ui/companieData.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
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
      body: FutureBuilder<List<Companies>>(
          future: getCompanies(),
          builder: (builder, snapshot) {
            if (snapshot.data != null) {
              if (snapshot.data!.isNotEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var value in snapshot.data!)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CompanieData(
                                          companie: value,
                                        )));
                            setState(() {});
                          },
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              title: Text(
                                value.name!.toUpperCase(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(value.id!),
                            ),
                          ),
                        ),
                      )
                  ],
                );
              } else {
                return const Center(
                  child: Text("Nenhuma Compania Retornada"),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future<List<Companies>> getCompanies() async {
    List<Companies> retorno = [];
    try {
      Retorno ret = await TractianApi.getCompanies();
      if (ret.erro == false) {
        retorno = ret.companies;
      }
    } catch (ex) {
      AlertDialog.adaptive();
    }
    return retorno;
  }
}
