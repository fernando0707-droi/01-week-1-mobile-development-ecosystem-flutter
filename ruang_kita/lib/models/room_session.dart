// Status ketersediaan/aktivitas pada sebuah ruang praktikum.
enum RoomStatus { berlangsung, akanDatang, selesai, tersedia }
 
extension RoomStatusLabel on RoomStatus {
  String get label {
    switch (this) {
      case RoomStatus.berlangsung:
        return 'Berlangsung';
      case RoomStatus.akanDatang:
        return 'Akan Datang';
      case RoomStatus.selesai:
        return 'Selesai';
      case RoomStatus.tersedia:
        return 'Tersedia';
    }
  }
}

// Model satu record penggunaan ruang praktikum.
// Sengaja dipisah dari widget agar UI tidak berisi data mentah
class RoomSession {
  final String id;
  final String roomName;
  final String activityName;
  final String description;
  final RoomStatus status;
  final String startTime;
  final String endTime;
 
  const RoomSession({
    required this.id,
    required this.roomName,
    required this.activityName,
    required this.description,
    required this.status,
    required this.startTime,
    required this.endTime,
  });
}

// Record pertama sengaja punya activityName > 35 karakter dan
// description > 90 karakter untuk menguji overflow
final List<RoomSession> dummyRoomSessions = [
  const RoomSession(
    id: 'r1',
    roomName: 'Lab Praktikum Pemrograman',
    activityName: 'Praktikum Struktur Data dan Algoritma Pemrograman Lanjut',
    description:
        'Mahasiswa mempelajari struktur data lanjutan seperti pohon, graf, '
        'dan berbagai algoritma pencarian serta pengurutan untuk optimasi program.',
    status: RoomStatus.berlangsung,
    startTime: '08:00',
    endTime: '10:00',
  ),
  const RoomSession(
    id: 'r2',
    roomName: 'Lab Praktikum Elektronika',
    activityName: 'Praktikum Rangkaian Dasar',
    description: 'Pengukuran arus dan tegangan pada rangkaian seri-paralel.',
    status: RoomStatus.akanDatang,
    startTime: '10:00',
    endTime: '12:00',
  ),
  const RoomSession(
    id: 'r3',
    roomName: 'Studio Praktikum Desain',
    activityName: 'Praktikum Desain UI/UX',
    description: 'Membuat wireframe dan prototipe aplikasi mobile sederhana.',
    status: RoomStatus.selesai,
    startTime: '07:00',
    endTime: '09:00',
  ),
  const RoomSession(
    id: 'r4',
    roomName: 'Lab Praktikum Basis Data',
    activityName: 'Praktikum Query SQL',
    description: 'Latihan SELECT, JOIN, dan agregasi pada basis data akademik.',
    status: RoomStatus.tersedia,
    startTime: '13:00',
    endTime: '15:00',
  ),
  const RoomSession(
    id: 'r5',
    roomName: 'Lab Praktikum Pemrograman',
    activityName: 'Praktikum Mobile Development',
    description: 'Membangun tampilan dasar aplikasi dengan Flutter.',
    status: RoomStatus.tersedia,
    startTime: '15:00',
    endTime: '17:00',
  ),
  const RoomSession(
    id: 'r6',
    roomName: 'Lab Praktikum Elektronika',
    activityName: 'Praktikum Mikrokontroler',
    description: 'Pemrograman sensor dan aktuator sederhana pada mikrokontroler.',
    status: RoomStatus.berlangsung,
    startTime: '09:00',
    endTime: '11:00',
  ),
  const RoomSession(
    id: 'r7',
    roomName: 'Studio Praktikum Desain',
    activityName: 'Praktikum Ilustrasi Digital',
    description: 'Latihan menggambar vektor untuk aset antarmuka aplikasi.',
    status: RoomStatus.akanDatang,
    startTime: '11:00',
    endTime: '13:00',
  ),
  const RoomSession(
    id: 'r8',
    roomName: 'Lab Praktikum Basis Data',
    activityName: 'Praktikum Normalisasi Basis Data',
    description: 'Menerapkan bentuk normal 1NF hingga 3NF pada studi kasus.',
    status: RoomStatus.selesai,
    startTime: '08:00',
    endTime: '10:00',
  ),
];