import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  // Kunci untuk mengakses state form (validasi dan reset).
  final _formKey = GlobalKey<FormState>();

  // Controller untuk menampilkan tanggal yang dipilih dari date picker.
  final _endDateController = TextEditingController();

  // Pilihan kategori, sama dengan EXPERIENCE_CHOICES di models.py (nilai: label).
  static const Map<String, String> _categoryChoices = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
  };
  static const String _defaultCategory = 'full-time';

  // Variabel penampung isi setiap field.
  String _title = "";
  String _description = "";
  String _category = _defaultCategory;
  bool _isOngoing = false;
  DateTime? _endDate;

  @override
  void dispose() {
    _endDateController.dispose();
    super.dispose();
  }

  /// Mengubah tanggal menjadi teks dengan format dd/mm/yyyy.
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  /// Membuka date picker untuk memilih tanggal selesai (tidak bisa di masa depan).
  Future<void> _pickEndDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? now,
      firstDate: DateTime(2000),
      lastDate: now,
      helpText: 'Pilih tanggal selesai',
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      _endDate = picked;
      _endDateController.text = _formatDate(picked);
    });
  }

  /// Mengosongkan form dan mengembalikan semua pilihan ke nilai awal.
  void _resetForm() {
    _formKey.currentState!.reset();
    _endDateController.clear();
    setState(() {
      _title = "";
      _description = "";
      _category = _defaultCategory;
      _isOngoing = false;
      _endDate = null;
    });
  }

  /// Menjalankan semua validator; dialog ringkasan hanya muncul jika valid.
  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Experience berhasil disimpan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Judul: ${_title.trim()}'),
                const SizedBox(height: 4),
                Text('Deskripsi: ${_description.trim()}'),
                const SizedBox(height: 4),
                Text('Kategori: ${_categoryChoices[_category]}'),
                const SizedBox(height: 4),
                Text(
                  _isOngoing
                      ? 'Status: Masih berlangsung'
                      : 'Selesai pada: ${_formatDate(_endDate!)}',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _resetForm();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // AppBar memakai warna primary tema, sama seperti halaman utama.
      appBar: AppBar(
        title: const Text(
          'Tambah Experience',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Drawer yang sama dengan halaman utama dan form proyek.
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        // SingleChildScrollView menjaga semua input dan tombol Simpan tetap
        // bisa dijangkau di layar sempit atau saat keyboard muncul.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Center(
            // Membatasi lebar form agar tetap nyaman dibaca di layar lebar.
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // === Judul Pengalaman (title, maks. 255 karakter) ===
                  TextFormField(
                    maxLength: 255,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: "Judul Pengalaman",
                      hintText: "Contoh: Software Engineer Intern",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _title = value;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Judul pengalaman tidak boleh kosong!";
                      }
                      final withoutTags = value.replaceAll(
                        RegExp(r'<[^>]*>'),
                        '',
                      );
                      if (withoutTags.trim().isEmpty) {
                        return "Judul tidak boleh hanya berisi tag HTML!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // === Deskripsi Pengalaman (description) ===
                  TextFormField(
                    minLines: 3,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: "Deskripsi Pengalaman",
                      hintText: "Ceritakan pengalaman atau tanggung jawabmu...",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _description = value;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Deskripsi pengalaman tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // === Kategori (category) ===
                  DropdownButtonFormField<String>(
                    initialValue: _defaultCategory,
                    decoration: InputDecoration(
                      labelText: "Kategori",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    items: _categoryChoices.entries
                        .map(
                          (entry) => DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          ),
                        )
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _category = newValue!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null) {
                        return "Pilih kategori pengalaman!";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // === Status: masih berlangsung (ended_at kosong) ===
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text("Masih berlangsung"),
                    subtitle: const Text(
                      "Aktifkan jika pengalaman ini belum selesai.",
                    ),
                    value: _isOngoing,
                    onChanged: (bool value) {
                      setState(() {
                        _isOngoing = value;
                        if (value) {
                          _endDate = null;
                          _endDateController.clear();
                        }
                      });
                    },
                  ),

                  if (!_isOngoing) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _endDateController,
                      readOnly: true,
                      onTap: _pickEndDate,
                      decoration: InputDecoration(
                        labelText: "Selesai Pada",
                        hintText: "Pilih tanggal selesai",
                        suffixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      validator: (String? value) {
                        if (_endDate == null) {
                          return "Pilih tanggal selesai, atau aktifkan "
                              "'Masih berlangsung'.";
                        }
                        if (_endDate!.isAfter(DateTime.now())) {
                          return "Tanggal selesai tidak boleh di masa depan!";
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 24),

                  // === Tombol Simpan ===
                  ElevatedButton.icon(
                    onPressed: _submitForm,
                    icon: const Icon(Icons.save),
                    label: const Text("Simpan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}