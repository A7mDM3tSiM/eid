class EmirateIdModel {
  late String name;
  late String number;
  late String? issueDate;
  late String? expiryDate;
  late String? dateOfBirth;
  late String? nationality;
  late String? sex;

  EmirateIdModel({
    required this.name,
    required this.number,
    this.issueDate,
    this.expiryDate,
    this.dateOfBirth,
    this.nationality,
    this.sex,
  });

  @override
  String toString() {
    var string = '';
    string += name.isEmpty ? "" : 'Holder Name = $name\n';
    string += number.isEmpty ? "" : 'Number = $number\n';
    string += expiryDate == null ? "" : 'Expiry Date = $expiryDate\n';
    string += issueDate == null ? "" : 'Issue Date = $issueDate\n';
    string += expiryDate == null ? "" : 'Cnic Holder DoB = $expiryDate\n';
    string += nationality == null ? "" : 'Nationality = $nationality\n';
    string += sex == null ? "" : 'Sex = $sex\n';
    return string;
  }
}
