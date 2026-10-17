# kasir

Aplikasi kasir (POS) untuk satu toko. Berjalan offline di satu device, dengan layout responsif untuk HP dan tablet. Flutter, target build Android.

## Isi repo

| Path | Keterangan |
|---|---|
| `lib/` | Kode aplikasi |
| `test/` | Widget test, semuanya lewat satu seam di root widget |
| `GLOSSARY.md` | Kosakata domain — pakai istilah ini di kode dan percakapan |
| `docs/adr/` | Keputusan arsitektur yang mengikat |
| `docs/agents/` | Konvensi kerja agent: issue tracker, triage, domain docs |
| `.scratch/kasir-v1/` | Spec v1 dan tiket implementasinya |

## Menjalankan

```bash
flutter pub get
dart run build_runner build     # menghasilkan lib/data/database.g.dart
flutter run
```

## Test

```bash
flutter analyze
flutter test
```

## Status

v1 sedang dibangun. Lihat `.scratch/kasir-v1/spec.md` untuk lingkupnya dan `.scratch/kasir-v1/issues/` untuk tiket yang sudah dan belum selesai.
