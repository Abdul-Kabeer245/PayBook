class Transaction {
  final int? id;
  final int? employeeid;
  final String? type;
  final double amount;
  final String? description;
  final DateTime date;

  Transaction(
      {this.id,
      this.employeeid,
      this.type,
      required this.amount,
      this.description,
      required this.date});

  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'employeeid': employeeid,
  //     'type': type,
  //     'amount': amount,
  //     'description': description,
  //     'date': date
  //   };
  // }
  Map<String, dynamic> toMap() {
  return {
    'id': id,
    'employeeid': employeeid,
    'type': type,
    'amount': amount,
    'description': description,
    'date': date.toIso8601String(), // Convert DateTime to a string
  };
}
  
 static Transaction fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      employeeid: map['employeeid'],
      type: map['type'],
      amount: map['amount'],
      description: map['description'],
      date: DateTime.parse(map['date']), // Convert the string back to DateTime
    );
  }
 
//  factory Transaction.fromMap(Map<String, dynamic> map){
//     return Transaction(
//       id: map['id'],
//       employeeid: map['employeeid'],
//       type: map['type'],
//       amount: map['amount'],
//       description: map['description'],
//       date: map['date']
//     );
//   }


}