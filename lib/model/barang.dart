class Barang {
  int? id;
  String? namaBarang;
  int? harga;
  int? jumlah;
  String? tanggalMasuk;

  Barang({
    this.id,
    this.namaBarang,
    this.harga,
    this.jumlah,
    this.tanggalMasuk,
  });

  factory Barang.fromJson(Map<String, dynamic> obj) {
    return Barang(
      id: int.parse(obj['id']),
      namaBarang: obj['nama_barang'],
      harga: int.parse(obj['harga']),
      jumlah: int.parse(obj['jumlah']),
      tanggalMasuk: obj['tanggal_masuk'],
    );
  }
}
