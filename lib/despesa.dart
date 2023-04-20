class Despesa {
  late String descricao;
  late String tipo;
  late String valor;

  Despesa({required this.descricao, required this.tipo, required this.valor});

  Despesa.fromJson(Map json) {
    descricao = json['descricao'] as String;
    tipo = json['tipo'] as String;
    valor = json['valor'] as String;
  }

  Map<String, dynamic> toJson() => {
        'descricao': descricao,
        'tipo': tipo,
        'valor': valor,
      };
}
