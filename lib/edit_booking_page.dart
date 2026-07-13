import 'package:flutter/material.dart';
import 'database_helper.dart';

class EditBookingPage extends StatefulWidget {
  final Map<String, dynamic> booking;

  const EditBookingPage({
    super.key,
    required this.booking,
  });

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  late TextEditingController namaController;
  late TextEditingController jamController;
  late TextEditingController durasiController;

  late String lapangan;
  late String status;

  @override
  void initState() {
    super.initState();

    namaController =
        TextEditingController(text: widget.booking["nama"]);

    jamController =
        TextEditingController(text: widget.booking["jam"]);

    durasiController =
        TextEditingController(text: widget.booking["durasi"]);

    lapangan = widget.booking["lapangan"];
    status = widget.booking["status"];
  }

  @override
  void dispose() {
    namaController.dispose();
    jamController.dispose();
    durasiController.dispose();
    super.dispose();
  }

  Future<void> updateBooking() async {
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

    await DatabaseHelper.instance.updateBooking(
      widget.booking["id"],
      namaController.text.trim(),
      lapangan,
      jamController.text.trim(),
      durasiController.text.trim(),
      status,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Booking berhasil diperbarui"),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Booking"),
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
                onPressed: updateBooking,
                icon: const Icon(Icons.save),
                label: const Text(
                  "SIMPAN PERUBAHAN",
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