
class Admin{
  String id,
      user,
      pass,
      role,
      name,
      birth,
      sex,
      phone,
      mail,
      address;

  Admin({
      this.id,
      this.user,
      this.pass,
      this.role,
      this.name,
      this.birth,
      this.sex,
      this.phone,
      this.mail,
      this.address});

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
      id: json["id"],
      user: json["user"],
      pass: json["pass"],
      role: json["role"],
      name: json["name"],
      birth: json["birth"],
      sex: json["sex"],
      phone: json["phone"],
      mail: json["mail"],
      address: json["address"]);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user": user,
      "pass": pass,
      "role": role,
      "name": name,
      "birth": birth,
      "sex": sex,
      "phone": phone,
      "mail": mail,
      "address": address,
    };
  }
}

