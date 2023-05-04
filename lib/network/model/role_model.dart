class Role {
  final int? id;
  final String? name;

  Role({
    this.id,
    this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }

  factory Role.fromFirebase(Map<String, dynamic> json) {
    return Role(
      id: json['roleId'],
      name: json['roleName'],
    );
  }

  Map<String, dynamic> toFirestore() => {'id': id, 'name': name};

  @override
  String toString() {
    return 'Role{id: $id, name: $name}';
  }
}
