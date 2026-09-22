import 'package:flutter/material.dart';
import 'package:ruang_kita/models/room_session.dart';
//halaman utama Ruangkita
//statefulWidget karena nanti akan menyimpan state filter kategori
class ruangPraktikumPage extends StatefulWidget {
  const ruangPraktikumPage({super.key});
 
  @override
  State<ruangPraktikumPage> createState() => _ruangPraktikumPageState();
}

class _ruangPraktikumPageState extends State<ruangPraktikumPage>{
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
        ]
      ),
      //baru 1 kolom vertikal
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: dummyRoomSessions.length,
        itemBuilder: (context, index) {
          return _RoomSessionCard(session: dummyRoomSessions[index]);
        }
      )
    );
  }
}

// card satu record ruang praktikum
class _RoomSessionCard extends StatelessWidget{
    final RoomSession session;

    const _RoomSessionCard({required this.session});

    @override
 Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indikator status sederhana
            Container(
              width: 8,
              height: 64,
              decoration: BoxDecoration(
                color: _statusColor(session.status),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            // Expanded wajib di sini: tanpa ini, Row akan overflow
            // horizontal ketika teks di dalam Column terlalu panjang.
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
                    '${session.startTime} - ${session.endTime}  •  ${session.status.label}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
