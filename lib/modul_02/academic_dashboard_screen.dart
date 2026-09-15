import 'package:flutter/material.dart';
import 'studiKasus/stateRuangPraktikum.dart';

class AcademicDashboardScreen extends StatelessWidget {
  const AcademicDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StateRuangPraktikum stateRuangPraktikum =
        StateRuangPraktikum();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172033),
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Ruang Praktikum Hari Ini',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;

          // HP = 1 kolom
          // Tablet / layar besar = 2 kolom
          final bool isTablet = screenWidth >= 600;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth < 600
                  ? 16
                  : screenWidth < 900
                      ? 24
                      : 40,
              vertical: 20,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1200,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // =================================================
                    // JUDUL
                    // =================================================

                    Text(
                      'Ruang Praktikum Hari Ini',
                      style: TextStyle(
                        fontSize: isTablet ? 32 : 26,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF172033),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // =================================================
                    // INFORMASI JUMLAH SESI & RUANG
                    // =================================================

                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        _buildInfoChip(
                          icon: Icons.calendar_month_rounded,
                          text:
                              '${stateRuangPraktikum.daftarRuang.length} sesi',
                          backgroundColor:
                              const Color(0xFFE5F3FF),
                          iconColor:
                              const Color(0xFF1689D8),
                          textColor:
                              const Color(0xFF28618C),
                        ),

                        _buildInfoChip(
                          icon: Icons.meeting_room_rounded,
                          text: '1 ruang tersedia',
                          backgroundColor:
                              const Color(0xFFE3F5EC),
                          iconColor:
                              const Color(0xFF2D9B6B),
                          textColor:
                              const Color(0xFF317957),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // =================================================
                    // DAFTAR KARTU
                    // =================================================

                    LayoutBuilder(
                      builder: (context, cardConstraints) {
                        final double availableWidth =
                            cardConstraints.maxWidth;

                        final double spacing = 14;

                        // Kalau tablet, bagi menjadi 2.
                        // Kalau HP, gunakan seluruh lebar.
                        final double cardWidth = isTablet
                            ? (availableWidth - spacing) / 2
                            : availableWidth;

                        return Wrap(
                          spacing: spacing,
                          runSpacing: spacing,
                          children: [
                            // =========================================
                            // KARTU 1, 2, 3
                            // =========================================

                            ...stateRuangPraktikum.daftarRuang.map(
                              (ruang) {
                                return SizedBox(
                                  width: cardWidth,
                                  child: _buildRuangCard(
                                    mataKuliah:
                                        ruang.mataKuliah,
                                    jam: ruang.jam,
                                    ruang: ruang.ruang,
                                    status: ruang.status,
                                  ),
                                );
                              },
                            ),

                            // =========================================
                            // KARTU RUANG TERSEDIA
                            // =========================================

                            SizedBox(
                              width: cardWidth,
                              child: _buildAvailableRoomCard(),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ===============================================================
  // CHIP INFORMASI
  // ===============================================================

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: iconColor,
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // KARTU RUANG PRAKTIKUM
  // ===============================================================

  Widget _buildRuangCard({
    required String mataKuliah,
    required String jam,
    required String ruang,
    required String status,
  }) {
    late Color statusBackground;
    late Color statusColor;
    late Color messageBackground;
    late Color messageColor;
    late IconData messageIcon;
    late String message;

    // =============================================================
    // STATUS BERLANGSUNG
    // =============================================================

    if (status == 'Berlangsung') {
      statusBackground = const Color(0xFFE0F2FE);
      statusColor = const Color(0xFF1689D8);

      messageBackground = const Color(0xFFE2F2FF);
      messageColor = const Color(0xFF285D82);

      messageIcon = Icons.groups_rounded;
      message = 'Sedang digunakan\noleh praktikan';
    }

    // =============================================================
    // STATUS AKAN DATANG
    // =============================================================

    else if (status == 'Akan datang') {
      statusBackground = const Color(0xFFFFEBC2);
      statusColor = const Color(0xFFD99016);

      messageBackground = const Color(0xFFFFF5DD);
      messageColor = const Color(0xFF75581D);

      messageIcon = Icons.schedule_rounded;
      message = 'Sesi akan dimulai\nsebentar lagi';
    }

    // =============================================================
    // STATUS SELESAI
    // =============================================================

    else {
      statusBackground = const Color(0xFFE8EBEE);
      statusColor = const Color(0xFF68727D);

      messageBackground = const Color(0xFFEDF1F5);
      messageColor = const Color(0xFF58616B);

      messageIcon = Icons.check_circle_rounded;
      message = 'Sesi telah selesai';
    }

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE0E6ED),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================================================
          // NAMA MATA KULIAH + STATUS
          // =========================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  mataKuliah,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172033),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // =========================================================
          // JAM
          // =========================================================

          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 20,
                color: Color(0xFF303B49),
              ),

              const SizedBox(width: 9),

              Text(
                jam,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF46515F),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          // =========================================================
          // RUANG
          // =========================================================

          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 20,
                color: Color(0xFF303B49),
              ),

              const SizedBox(width: 9),

              Text(
                ruang,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF46515F),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // =========================================================
          // INFORMASI STATUS
          // =========================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: messageBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  messageIcon,
                  size: 25,
                  color: statusColor,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: messageColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // KARTU RUANG TERSEDIA
  // ===============================================================

  Widget _buildAvailableRoomCard() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFFF3FBF7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD5EDE1),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================================================
          // NAMA RUANG + STATUS
          // =========================================================

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Lab 2',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172033),
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF4E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Tersedia',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF25835D),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // =========================================================
          // KETERANGAN RUANG
          // =========================================================

          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.meeting_room_rounded,
                size: 22,
                color: Color(0xFF303B49),
              ),

              SizedBox(width: 9),

              Expanded(
                child: Text(
                  'Ruang tersedia\ndi luar jadwal sesi',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF46515F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // =========================================================
          // INFORMASI RUANG
          // =========================================================

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFDDF4E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.meeting_room_rounded,
                  size: 25,
                  color: Color(0xFF25835D),
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Text(
                    'Siap digunakan\nuntuk praktikum lain',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF317957),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}