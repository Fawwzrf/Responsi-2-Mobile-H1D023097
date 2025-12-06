import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:responsi2mobilepaket1h1d023097/helpers/api_url.dart';
import 'package:responsi2mobilepaket1h1d023097/model/barang.dart';
import 'package:responsi2mobilepaket1h1d023097/ui/barang_detail.dart';
import 'package:responsi2mobilepaket1h1d023097/ui/barang_form.dart';
import 'package:responsi2mobilepaket1h1d023097/ui/login_page.dart';

class BarangPage extends StatefulWidget {
  const BarangPage({Key? key}) : super(key: key);
  @override
  _BarangPageState createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  List<Barang> _allBarang = [];
  List<Barang> _foundBarang = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBarang();
  }

  Future<void> _fetchBarang() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(ApiUrl.listBarang));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body)['data'];
        setState(() {
          _allBarang = data.map((e) => Barang.fromJson(e)).toList();
          _foundBarang = _allBarang;
        });
      }
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _runFilter(String keyword) {
    List<Barang> results = [];
    if (keyword.isEmpty) {
      results = _allBarang;
    } else {
      results = _allBarang
          .where(
            (item) =>
                item.namaBarang!.toLowerCase().contains(keyword.toLowerCase()),
          )
          .toList();
    }
    setState(() {
      _foundBarang = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaris Komputer by Fawwaz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: TextField(
              onChanged: _runFilter,
              decoration: InputDecoration(
                hintText: "Cari barang...",
                prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _foundBarang.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada data",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10, bottom: 80),
                    itemCount: _foundBarang.length,
                    itemBuilder: (context, index) {
                      final barang = _foundBarang[index];
                      return Card(
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.computer,
                              color: Colors.blueGrey[700],
                            ),
                          ),
                          title: Text(
                            barang.namaBarang!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                "Rp ${NumberFormat('#,###', 'id_ID').format(barang.harga)}",
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Stok: ${barang.jumlah}",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 18,
                            color: Colors.grey,
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BarangDetail(barang: barang),
                              ),
                            );
                            _fetchBarang();
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BarangForm()),
          );
          _fetchBarang();
        },
        label: const Text("Tambah", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueGrey[700],
      ),
    );
  }
}
