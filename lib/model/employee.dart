class Employee {
  final String id;
  final String name;
  final String email;
  final String imageUrl;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl = '', // Default to empty string
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
    };
  }
}