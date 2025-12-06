import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:responsi2mobilepaket1h1d023097/helpers/api_url.dart';
import 'package:responsi2mobilepaket1h1d023097/model/barang.dart';

class BarangForm extends StatefulWidget {
  final Barang? barang;
  const BarangForm({Key? key, this.barang}) : super(key: key);
  @override
  _BarangFormState createState() => _BarangFormState();
}

class _BarangFormState extends State<BarangForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _hargaCtrl = TextEditingController();
  final _jumlahCtrl = TextEditingController();
  final _tanggalCtrl = TextEditingController();
  bool _isLoading = false;
  String judul = "Tambah Barang Fawwaz"; 
  String btnLabel = "SIMPAN";

  @override
  void initState() {
    super.initState();
    if (widget.barang != null) {
      judul = "Ubah Barang Fawwaz";
      btnLabel = "UPDATE";
      _namaCtrl.text = widget.barang!.namaBarang!;
      _hargaCtrl.text = widget.barang!.harga.toString();
      _jumlahCtrl.text = widget.barang!.jumlah.toString();
      _tanggalCtrl.text = widget.barang!.tanggalMasuk!;
    }
  }

  Future<void> simpan() async {
    setState(() {
      _isLoading = true;
    });
    final body = {
      "nama_barang": _namaCtrl.text,
      "harga": _hargaCtrl.text,
      "jumlah": _jumlahCtrl.text,
      "tanggal_masuk": _tanggalCtrl.text,
    };
    try {
      final url = widget.barang == null
          ? Uri.parse(ApiUrl.createBarang)
          : Uri.parse(ApiUrl.updateBarang(widget.barang!.id!));
      final response = widget.barang == null
          ? await http.post(url, body: body)
          : await http.put(url, body: body);
      final data = json.decode(response.body);
      if (data['status'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Data Berhasil Disimpan")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Gagal Menyimpan Data")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 10),
              child: Text(
                "Informasi Perangkat",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildInput(
                      ctrl: _namaCtrl,
                      label: "Nama Perangkat",
                      icon: Icons.computer,
                      hint: "Contoh: Laptop Asus ROG",
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: _buildInput(
                            ctrl: _hargaCtrl,
                            label: "Harga (Rp)",
                            icon: Icons.monetization_on_outlined,
                            type: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildInput(
                            ctrl: _jumlahCtrl,
                            label: "Stok",
                            icon: Icons.inventory_2_outlined,
                            type: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _tanggalCtrl,
                      readOnly: true,
                      validator: (v) =>
                          v!.isEmpty ? "Tanggal wajib diisi" : null,
                      decoration: InputDecoration(
                        labelText: "Tanggal Masuk",
                        prefixIcon: const Icon(
                          Icons.calendar_month,
                          color: Colors.blueGrey,
                        ),
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Colors.blueGrey,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            _tanggalCtrl.text = DateFormat(
                              'yyyy-MM-dd',
                            ).format(picked);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: Text(
                        btnLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) simpan();
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController ctrl,
    required String label,
    required IconData icon,
    TextInputType type = TextInputType.text,
    String? hint,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.blueGrey),
        filled: true,
        fillColor:
            Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueGrey, width: 2),
        ),
      ),
      validator: (v) => v!.isEmpty ? "$label wajib diisi" : null,
    );
  }
}
