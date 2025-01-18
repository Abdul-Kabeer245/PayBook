class Employee {
  final int? id;
  final String name;
  final String phone;
  final String email;

  Employee({
    this.id ,
    required this.name,
    this.phone = '',
    this.email = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
    };
  }


  factory Employee.fromMap(Map<String, dynamic> map){
    return Employee(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email']
    );
  }
}