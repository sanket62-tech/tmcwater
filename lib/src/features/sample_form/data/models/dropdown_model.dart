class DropdownModel {
  final int id;
  final String name;

  DropdownModel({
    required this.id,
    required this.name,
  });

  factory DropdownModel.fromJson(Map<String, dynamic> json) {
    return DropdownModel(
      id: json['Id'] ?? json['id'] ?? 0,
      name: json['Name'] ?? json['name'] ?? json['SourceName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropdownModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
