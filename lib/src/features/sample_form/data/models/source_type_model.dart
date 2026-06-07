class SourceType {
  final int id;
  final String name;

  SourceType({
    required this.id,
    required this.name,
  });

  factory SourceType.fromJson(Map<String, dynamic> json) {
    return SourceType(
      id: json['Id'] ?? json['id'] ?? 0,
      name: json['SourceName'] ?? json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'SourceName': name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceType && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
