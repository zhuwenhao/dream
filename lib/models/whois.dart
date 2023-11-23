import 'package:json_annotation/json_annotation.dart';

part 'whois.g.dart';

@JsonSerializable(createToJson: false, fieldRename: FieldRename.snake)
class Whois {
  const Whois({
    this.creationDate = '',
    this.domainName = '',
    this.expirationDate = '',
    this.registrar = '',
    this.status = '',
    this.updatedDate = '',
  });

  factory Whois.fromJson(Map<String, dynamic> json) => _$WhoisFromJson(json);

  final String creationDate;

  final String domainName;

  final String expirationDate;

  final String registrar;

  final String status;

  final String updatedDate;
}
