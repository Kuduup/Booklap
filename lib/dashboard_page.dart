import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'login_page.dart';
import 'tambah_booking_page.dart';
import 'edit_booking_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    loadBooking();
  }

  Future<void> loadBooking() async {
    try {
      final data = await DatabaseHelper.instance.getBooking();

      if (!mounted) return;

      setState(() {
        bookings = data;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "Booking":
        return Colors.orange;
      case "Selesai":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> deleteBooking(int id) async {
    bool? hapus = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Booking"),
        content: const Text("Yakin ingin menghapus booking ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (hapus == true) {
      await DatabaseHelper.instance.deleteBooking(id);
      loadBooking();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BookLap"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: loadBooking,
        child: bookings.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 180),
                  Icon(
                    Icons.event_busy,
                    size: 90,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: Text(
                      "Belum ada booking",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.blue,
                                child: Icon(
                                  Icons.sports_soccer,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  booking["nama"] ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: [
                              const Icon(Icons.stadium,
                                  color: Colors.blue),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Lapangan : ${booking["lapangan"]}",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  color: Colors.orange),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Jam : ${booking["jam"]}",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Icon(Icons.timer,
                                  color: Colors.purple),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Durasi : ${booking["durasi"]} Jam",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              const Icon(Icons.flag,
                                  color: Colors.green),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor(
                                    booking["status"] ?? "",
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: Text(
                                  booking["status"] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Divider(height: 30),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              IconButton(
                                tooltip: "Edit",
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () async {
                                  final result =
                                      await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditBookingPage(
                                        booking: booking,
                                      ),
                                    ),
                                  );

                                  if (result == true) {
                                    loadBooking();
                                  }
                                },
                              ),

                              IconButton(
                                tooltip: "Hapus",
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deleteBooking(
                                    booking["id"],
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Booking"),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahBookingPage(),
            ),
          );

          if (result == true) {
            loadBooking();
          }
        },
      ),
    );
  }
}