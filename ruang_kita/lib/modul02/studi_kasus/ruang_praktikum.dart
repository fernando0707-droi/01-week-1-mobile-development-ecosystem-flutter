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
  // null = "Semua" (tidak ada filter aktif).
  RoomStatus? _selectedStatus;
 
  List<RoomSession> get _filteredSessions {
    if (_selectedStatus == null) return dummyRoomSessions;
    return dummyRoomSessions
        .where((session) => session.status == _selectedStatus)
        .toList();
  }
 
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
      body: Column(
        children: [
          // Commit #4: filter Wrap + ChoiceChip. Wrap dipakai (bukan Row)
          // supaya chip otomatis lipat ke baris baru di layar sempit,
          // tidak overflow horizontal.
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Semua'),
                  selected: _selectedStatus == null,
                  // setState di sini langsung memicu build ulang list/grid
                  // di bawah — tanpa restart aplikasi (poin F).
                  onSelected: (_) {
                    setState(() => _selectedStatus = null);
                  },
                ),
                for (final status in RoomStatus.values)
                  ChoiceChip(
                    label: Text(status.label),
                    selected: _selectedStatus == status,
                    onSelected: (selected) {
                      setState(() {
                        _selectedStatus = selected ? status : null;
                      });
                    },
                  ),
              ],
            ),
          ),
          // Expanded wajib di sini: Column tidak otomatis membatasi tinggi
          // child-nya, jadi LayoutBuilder/ListView di dalamnya perlu diberi
          // sisa ruang vertikal yang jelas, atau akan error "unbounded height".
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final sessions = _filteredSessions;
 
                int crossAxisCount;
                if (width < 600) {
                  crossAxisCount = 1; // Compact
                } else if (width < 840) {
                  crossAxisCount = 2; // Medium
                } else {
                  crossAxisCount = 3; // Expanded
                }
 
                if (crossAxisCount == 1) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      return _RoomSessionCard(session: sessions[index]);
                    },
                  );
                }
 
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    return _RoomSessionCard(session: sessions[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
 
// Card satu record ruang praktikum.
// Stack + Positioned untuk badge overlay (commit #3), ditambah GestureDetector
// untuk membuka detail lewat showModalBottomSheet (commit #4, poin G).
class _RoomSessionCard extends StatelessWidget {
  final RoomSession session;
 
  const _RoomSessionCard({required this.session});
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetailSheet(context, session),
      child: Stack(
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
      ),
    );
  }
 
  void _showDetailSheet(BuildContext context, RoomSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        // StatefulBuilder dipakai karena builder bottom sheet ini bukan
        // widget StatefulWidget sendiri — ini cara paling ringan untuk
        // punya state lokal (kontrol UI) khusus di dalam sheet ini saja.
        bool remindMe = false;
 
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.roomName,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    session.activityName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 6),
                      Text('${session.startTime} - ${session.endTime}'),
                      const SizedBox(width: 16),
                      _StatusBadge(status: session.status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(session.description),
                  const SizedBox(height: 8),
                  // Kontrol UI lokal minimal 1 buah (poin G) — SwitchListTile
                  // ini murni state di dalam modal, tidak memengaruhi
                  // halaman utama.
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Ingatkan saya sebelum mulai'),
                    value: remindMe,
                    onChanged: (value) {
                      setModalState(() => remindMe = value);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
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