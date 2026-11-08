class AddressModel {
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;

  const AddressModel({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  /// Resposta da API ViaCEP.
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      cep: (json['cep'] ?? '') as String,
      logradouro: (json['logradouro'] ?? '') as String,
      complemento: (json['complemento'] ?? '') as String,
      bairro: (json['bairro'] ?? '') as String,
      localidade: (json['localidade'] ?? '') as String,
      uf: (json['uf'] ?? '') as String,
    );
  }

  /// Usado para gravar no Hive (como Map).
  Map<String, dynamic> toMap() => {
    'cep': cep,
    'logradouro': logradouro,
    'complemento': complemento,
    'bairro': bairro,
    'localidade': localidade,
    'uf': uf,
  };

  factory AddressModel.fromMap(Map<dynamic, dynamic> map) {
    return AddressModel(
      cep: (map['cep'] ?? '') as String,
      logradouro: (map['logradouro'] ?? '') as String,
      complemento: (map['complemento'] ?? '') as String,
      bairro: (map['bairro'] ?? '') as String,
      localidade: (map['localidade'] ?? '') as String,
      uf: (map['uf'] ?? '') as String,
    );
  }

  /// Texto completo para exibição.
  String get fullAddress {
    final parts = [
      logradouro,
      bairro,
      localidade,
      uf,
    ].where((p) => p.trim().isNotEmpty).toList();
    return '${parts.join(', ')}, Brasil';
  }

  /// Texto usado só na busca de coordenadas (inclui o CEP para ser mais preciso).
  String get geocodeQuery {
    final cidadeUf = [
      localidade,
      uf,
    ].where((p) => p.trim().isNotEmpty).join(' - ');
    final parts = [
      logradouro,
      bairro,
      cidadeUf,
      cep,
      'Brasil',
    ].where((p) => p.trim().isNotEmpty).toList();
    return parts.join(', ');
  }
}
