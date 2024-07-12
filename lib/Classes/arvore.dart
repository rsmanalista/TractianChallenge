class Arvore {
  String? id;
  String? nome;
  String? tipo;
  String? gatewayId;
  String? sensorId;
  String? sensorType;
  String? status;
  List<Arvore>? filhos = [];

  Arvore(
      {this.id,
      this.nome,
      this.tipo,
      this.gatewayId,
      this.sensorId,
      this.sensorType,
      this.status,
      this.filhos});

  factory Arvore.fromJson(Map<String, dynamic> json) {
    var filhosFromJson = json['filhos'] as List;
    List<Arvore> filhosList =
        filhosFromJson.map((i) => Arvore.fromJson(i)).toList();

    return Arvore(
      id: json['id'],
      nome: json['nome'],
      tipo: json['tipo'],
      gatewayId: json['gatewayId'],
      sensorId: json['sensorId'],
      sensorType: json['sensorType'],
      status: json['status'],
      filhos: filhosList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo,
      'gatewayId': gatewayId,
      'sensorId': sensorId,
      'sensorType': sensorType,
      'status': status,
      'filhos': filhos,
    };
  }
}
