import 'package:flutter/material.dart';
import 'database_helper.dart';

class TambahBookingPage extends StatefulWidget {
  const TambahBookingPage({super.key});

  @override
  State<TambahBookingPage> createState() => _TambahBookingPageState();
}

class _TambahBookingPageState extends State<TambahBookingPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController jamController = TextEditingController();
  final TextEditingController durasiController = TextEditingController();

  String lapangan = "Futsal";
  String status = "Booking";

  @override
  void dispose() {
    namaController.dispose();
    jamController.dispose();
    durasiController.dispose();
    super.dispose();
  }

  Future<void> simpanBooking() async {
    try {
      if (namaController.text.trim().isEmpty ||
          jamController.text.trim().isEmpty ||
          durasiController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Semua data harus diisi"),
          ),
        );
        return;
      }

      print("=== MASUK SIMPAN BOOKING ===");

      final id = await DatabaseHelper.instance.tambahBooking(
        namaController.text.trim(),
        lapangan,
        jamController.text.trim(),
        durasiController.text.trim(),
        status,
      );

      print("BOOKING BERHASIL, ID = $id");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Booking berhasil disimpan"),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      print("ERROR DATABASE : $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error : $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Booking"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: "Nama Penyewa",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: lapangan,
              decoration: const InputDecoration(
                labelText: "Lapangan",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.sports_soccer),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Futsal",
                  child: Text("Futsal"),
                ),
                DropdownMenuItem(
                  value: "Badminton",
                  child: Text("Badminton"),
                ),
                DropdownMenuItem(
                  value: "Tenis Meja",
                  child: Text("Tenis Meja"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  lapangan = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: jamController,
              decoration: const InputDecoration(
                labelText: "Jam Sewa",
                hintText: "Contoh : 18.00",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: durasiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Durasi (Jam)",
                hintText: "Contoh : 2",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer),
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: status,
              decoration: const InputDecoration(
                labelText: "Status",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.flag),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Booking",
                  child: Text("Booking"),
                ),
                DropdownMenuItem(
                  value: "Selesai",
                  child: Text("Selesai"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  status = value!;
                });
              },
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: simpanBooking,
                icon: const Icon(Icons.save),
                label: const Text(
                  "SIMPAN BOOKING",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}