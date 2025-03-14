class UserModel {
  String? nama;
  String? email;
  String? noHp;
  String? jabatan;
  String? dinas;
  String? divisi;

  UserModel({
    this.nama,
    this.email,
    this.noHp,
    this.jabatan,
    this.dinas,
    this.divisi,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nama: json['Nama'],
      email: json['Email'],
      noHp: json['No. HP'],
      jabatan: json['Jabatan'],
      dinas: json['Dinas'],
      divisi: json['Divisi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Nama': nama,
      'Email': email,
      'No. HP': noHp,
      'Jabatan': jabatan,
      'Dinas': dinas,
      'Divisi': divisi,
    };
  }

  static UserModel blank() {
    return UserModel(
      nama: '',
      email: '',
      noHp: '',
      jabatan: '',
      dinas: '',
      divisi: '',
    );
  }
}
