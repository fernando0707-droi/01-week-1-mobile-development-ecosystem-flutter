import 'package:flutter/material.dart';
import 'ruangPraktikum.dart';


class StateRuangPraktikum extends ChangeNotifier {
  final List<RuangPraktikum> _daftarRuang = [
    RuangPraktikum(
      mataKuliah: 'Mobile Programming',
      jam: '08.00 - 10.00',
      ruang: 'Lab 1',
      status: 'Berlangsung',
    ),

    RuangPraktikum(
      mataKuliah: 'Rekayasa Perangkat Lunak',
      jam: '10.00 - 12.00',
      ruang: 'Lab 2',
      status: 'Akan datang',
    ),

    RuangPraktikum(
      mataKuliah: 'Basis Data',
      jam: '13.00 - 15.00',
      ruang: 'Lab 3',
      status: 'Selesai',
    ),
  ];

  List<RuangPraktikum> get daftarRuang => _daftarRuang;

  void tambahRuang(RuangPraktikum ruang) {
    _daftarRuang.add(ruang);
    notifyListeners();
  }

  void hapusRuang(int index) {
    _daftarRuang.removeAt(index);
    notifyListeners();
  }
}