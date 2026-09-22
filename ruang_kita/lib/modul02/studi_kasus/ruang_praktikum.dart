import 'package:flutter/material.dart';
import 'package:ruang_kita/models/room_session.dart';
// Halaman utama RuangKita.
// StatefulWidget karena akan menyimpan state filter kategori/status

class RuangPraktikumPage extends StatefulWidget {
  const RuangPraktikumPage({super.key});
 
  @override
  State<RuangPraktikumPage> createState() => _RuangPraktikumPageState();
}
 
class _RuangPraktikumPageState extends State<RuangPraktikumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RuangKita'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'M02-2142',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      // Commit #3: LayoutBuilder membaca constraints.maxWidth dari PARENT
      // (di sini body Scaffold), bukan lebar device lewat MediaQuery.
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
 
          int crossAxisCount;
          if (width < 600) {
            crossAxisCount = 1; // Compact
          } else if (width < 840) {
            crossAxisCount = 2; // Medium
          } else {
            crossAxisCount = 3; // Expanded
          }
 
          // Compact tetap pakai ListView (list vertikal murni).
          if (crossAxisCount == 1) {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: dummyRoomSessions.length,
              itemBuilder: (context, index) {
                return _RoomSessionCard(session: dummyRoomSessions[index]);
              },
            );
          }
 
          // Medium & Expanded pakai GridView sesuai crossAxisCount.
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: dummyRoomSessions.length,
            itemBuilder: (context, index) {
              return _RoomSessionCard(session: dummyRoomSessions[index]);
            },
          );
        },
      ),
    );
  }
}
 
// Card satu record ruang praktikum.
// Stack membungkus Card + badge status sebagai overlay lewat Positioned,
// bukan sekadar diletakkan berjejer dalam Row (poin D).
class _RoomSessionCard extends StatelessWidget {
  final RoomSession session;
 
  const _RoomSessionCard({required this.session});
 
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 56, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.roomName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.activityName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.description,
                        style: const TextStyle(fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${session.startTime} - ${session.endTime}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: _StatusBadge(status: session.status),
        ),
      ],
    );
  }
}
 
class _StatusBadge extends StatelessWidget {
  final RoomStatus status;
 
  const _StatusBadge({required this.status});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _statusColor(status),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
 
  Color _statusColor(RoomStatus status) {
    switch (status) {
      case RoomStatus.berlangsung:
        return Colors.green;
      case RoomStatus.akanDatang:
        return Colors.orange;
      case RoomStatus.selesai:
        return Colors.grey;
      case RoomStatus.tersedia:
        return Colors.blue;
    }
  }
}