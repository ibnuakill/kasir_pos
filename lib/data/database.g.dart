// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KategoriTable extends Kategori
    with TableInfo<$KategoriTable, KategoriData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KategoriTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, nama];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kategori';
  @override
  VerificationContext validateIntegrity(
    Insertable<KategoriData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KategoriData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KategoriData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
    );
  }

  @override
  $KategoriTable createAlias(String alias) {
    return $KategoriTable(attachedDatabase, alias);
  }
}

class KategoriData extends DataClass implements Insertable<KategoriData> {
  final int id;
  final String nama;
  const KategoriData({required this.id, required this.nama});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nama'] = Variable<String>(nama);
    return map;
  }

  KategoriCompanion toCompanion(bool nullToAbsent) {
    return KategoriCompanion(id: Value(id), nama: Value(nama));
  }

  factory KategoriData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KategoriData(
      id: serializer.fromJson<int>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nama': serializer.toJson<String>(nama),
    };
  }

  KategoriData copyWith({int? id, String? nama}) =>
      KategoriData(id: id ?? this.id, nama: nama ?? this.nama);
  KategoriData copyWithCompanion(KategoriCompanion data) {
    return KategoriData(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KategoriData(')
          ..write('id: $id, ')
          ..write('nama: $nama')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nama);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KategoriData && other.id == this.id && other.nama == this.nama);
}

class KategoriCompanion extends UpdateCompanion<KategoriData> {
  final Value<int> id;
  final Value<String> nama;
  const KategoriCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
  });
  KategoriCompanion.insert({
    this.id = const Value.absent(),
    required String nama,
  }) : nama = Value(nama);
  static Insertable<KategoriData> custom({
    Expression<int>? id,
    Expression<String>? nama,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
    });
  }

  KategoriCompanion copyWith({Value<int>? id, Value<String>? nama}) {
    return KategoriCompanion(id: id ?? this.id, nama: nama ?? this.nama);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KategoriCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama')
          ..write(')'))
        .toString();
  }
}

class $ProdukTable extends Produk with TableInfo<$ProdukTable, ProdukData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProdukTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hargaKatalogMeta = const VerificationMeta(
    'hargaKatalog',
  );
  @override
  late final GeneratedColumn<int> hargaKatalog = GeneratedColumn<int>(
    'harga_katalog',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _satuanMeta = const VerificationMeta('satuan');
  @override
  late final GeneratedColumn<String> satuan = GeneratedColumn<String>(
    'satuan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bolehPecahanMeta = const VerificationMeta(
    'bolehPecahan',
  );
  @override
  late final GeneratedColumn<bool> bolehPecahan = GeneratedColumn<bool>(
    'boleh_pecahan',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("boleh_pecahan" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _kategoriIdMeta = const VerificationMeta(
    'kategoriId',
  );
  @override
  late final GeneratedColumn<int> kategoriId = GeneratedColumn<int>(
    'kategori_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES kategori (id)',
    ),
  );
  static const VerificationMeta _aktifMeta = const VerificationMeta('aktif');
  @override
  late final GeneratedColumn<bool> aktif = GeneratedColumn<bool>(
    'aktif',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("aktif" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _fotoMeta = const VerificationMeta('foto');
  @override
  late final GeneratedColumn<String> foto = GeneratedColumn<String>(
    'foto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nama,
    hargaKatalog,
    satuan,
    bolehPecahan,
    kategoriId,
    aktif,
    foto,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'produk';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProdukData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('harga_katalog')) {
      context.handle(
        _hargaKatalogMeta,
        hargaKatalog.isAcceptableOrUnknown(
          data['harga_katalog']!,
          _hargaKatalogMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hargaKatalogMeta);
    }
    if (data.containsKey('satuan')) {
      context.handle(
        _satuanMeta,
        satuan.isAcceptableOrUnknown(data['satuan']!, _satuanMeta),
      );
    } else if (isInserting) {
      context.missing(_satuanMeta);
    }
    if (data.containsKey('boleh_pecahan')) {
      context.handle(
        _bolehPecahanMeta,
        bolehPecahan.isAcceptableOrUnknown(
          data['boleh_pecahan']!,
          _bolehPecahanMeta,
        ),
      );
    }
    if (data.containsKey('kategori_id')) {
      context.handle(
        _kategoriIdMeta,
        kategoriId.isAcceptableOrUnknown(data['kategori_id']!, _kategoriIdMeta),
      );
    }
    if (data.containsKey('aktif')) {
      context.handle(
        _aktifMeta,
        aktif.isAcceptableOrUnknown(data['aktif']!, _aktifMeta),
      );
    }
    if (data.containsKey('foto')) {
      context.handle(
        _fotoMeta,
        foto.isAcceptableOrUnknown(data['foto']!, _fotoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProdukData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProdukData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      hargaKatalog: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}harga_katalog'],
      )!,
      satuan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}satuan'],
      )!,
      bolehPecahan: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}boleh_pecahan'],
      )!,
      kategoriId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kategori_id'],
      ),
      aktif: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}aktif'],
      )!,
      foto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}foto'],
      ),
    );
  }

  @override
  $ProdukTable createAlias(String alias) {
    return $ProdukTable(attachedDatabase, alias);
  }
}

class ProdukData extends DataClass implements Insertable<ProdukData> {
  final int id;
  final String nama;

  /// Harga jual dalam rupiah bulat, dipakai apa adanya saat menjual.
  final int hargaKatalog;

  /// Satuan bebas milik toko; satu Produk hanya punya satu Satuan (ADR-0005).
  final String satuan;
  final bool bolehPecahan;

  /// Boleh kosong: katalog bisa diisi sebelum sempat dirapikan per Kategori.
  final int? kategoriId;
  final bool aktif;

  /// Path berkas Foto Produk di penyimpanan aplikasi, bukan isi gambarnya.
  /// Null berarti Produk ini belum punya foto dan katalog memakai penanda
  /// pengganti.
  final String? foto;
  const ProdukData({
    required this.id,
    required this.nama,
    required this.hargaKatalog,
    required this.satuan,
    required this.bolehPecahan,
    this.kategoriId,
    required this.aktif,
    this.foto,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nama'] = Variable<String>(nama);
    map['harga_katalog'] = Variable<int>(hargaKatalog);
    map['satuan'] = Variable<String>(satuan);
    map['boleh_pecahan'] = Variable<bool>(bolehPecahan);
    if (!nullToAbsent || kategoriId != null) {
      map['kategori_id'] = Variable<int>(kategoriId);
    }
    map['aktif'] = Variable<bool>(aktif);
    if (!nullToAbsent || foto != null) {
      map['foto'] = Variable<String>(foto);
    }
    return map;
  }

  ProdukCompanion toCompanion(bool nullToAbsent) {
    return ProdukCompanion(
      id: Value(id),
      nama: Value(nama),
      hargaKatalog: Value(hargaKatalog),
      satuan: Value(satuan),
      bolehPecahan: Value(bolehPecahan),
      kategoriId: kategoriId == null && nullToAbsent
          ? const Value.absent()
          : Value(kategoriId),
      aktif: Value(aktif),
      foto: foto == null && nullToAbsent ? const Value.absent() : Value(foto),
    );
  }

  factory ProdukData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProdukData(
      id: serializer.fromJson<int>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      hargaKatalog: serializer.fromJson<int>(json['hargaKatalog']),
      satuan: serializer.fromJson<String>(json['satuan']),
      bolehPecahan: serializer.fromJson<bool>(json['bolehPecahan']),
      kategoriId: serializer.fromJson<int?>(json['kategoriId']),
      aktif: serializer.fromJson<bool>(json['aktif']),
      foto: serializer.fromJson<String?>(json['foto']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nama': serializer.toJson<String>(nama),
      'hargaKatalog': serializer.toJson<int>(hargaKatalog),
      'satuan': serializer.toJson<String>(satuan),
      'bolehPecahan': serializer.toJson<bool>(bolehPecahan),
      'kategoriId': serializer.toJson<int?>(kategoriId),
      'aktif': serializer.toJson<bool>(aktif),
      'foto': serializer.toJson<String?>(foto),
    };
  }

  ProdukData copyWith({
    int? id,
    String? nama,
    int? hargaKatalog,
    String? satuan,
    bool? bolehPecahan,
    Value<int?> kategoriId = const Value.absent(),
    bool? aktif,
    Value<String?> foto = const Value.absent(),
  }) => ProdukData(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    hargaKatalog: hargaKatalog ?? this.hargaKatalog,
    satuan: satuan ?? this.satuan,
    bolehPecahan: bolehPecahan ?? this.bolehPecahan,
    kategoriId: kategoriId.present ? kategoriId.value : this.kategoriId,
    aktif: aktif ?? this.aktif,
    foto: foto.present ? foto.value : this.foto,
  );
  ProdukData copyWithCompanion(ProdukCompanion data) {
    return ProdukData(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      hargaKatalog: data.hargaKatalog.present
          ? data.hargaKatalog.value
          : this.hargaKatalog,
      satuan: data.satuan.present ? data.satuan.value : this.satuan,
      bolehPecahan: data.bolehPecahan.present
          ? data.bolehPecahan.value
          : this.bolehPecahan,
      kategoriId: data.kategoriId.present
          ? data.kategoriId.value
          : this.kategoriId,
      aktif: data.aktif.present ? data.aktif.value : this.aktif,
      foto: data.foto.present ? data.foto.value : this.foto,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProdukData(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('hargaKatalog: $hargaKatalog, ')
          ..write('satuan: $satuan, ')
          ..write('bolehPecahan: $bolehPecahan, ')
          ..write('kategoriId: $kategoriId, ')
          ..write('aktif: $aktif, ')
          ..write('foto: $foto')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nama,
    hargaKatalog,
    satuan,
    bolehPecahan,
    kategoriId,
    aktif,
    foto,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProdukData &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.hargaKatalog == this.hargaKatalog &&
          other.satuan == this.satuan &&
          other.bolehPecahan == this.bolehPecahan &&
          other.kategoriId == this.kategoriId &&
          other.aktif == this.aktif &&
          other.foto == this.foto);
}

class ProdukCompanion extends UpdateCompanion<ProdukData> {
  final Value<int> id;
  final Value<String> nama;
  final Value<int> hargaKatalog;
  final Value<String> satuan;
  final Value<bool> bolehPecahan;
  final Value<int?> kategoriId;
  final Value<bool> aktif;
  final Value<String?> foto;
  const ProdukCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.hargaKatalog = const Value.absent(),
    this.satuan = const Value.absent(),
    this.bolehPecahan = const Value.absent(),
    this.kategoriId = const Value.absent(),
    this.aktif = const Value.absent(),
    this.foto = const Value.absent(),
  });
  ProdukCompanion.insert({
    this.id = const Value.absent(),
    required String nama,
    required int hargaKatalog,
    required String satuan,
    this.bolehPecahan = const Value.absent(),
    this.kategoriId = const Value.absent(),
    this.aktif = const Value.absent(),
    this.foto = const Value.absent(),
  }) : nama = Value(nama),
       hargaKatalog = Value(hargaKatalog),
       satuan = Value(satuan);
  static Insertable<ProdukData> custom({
    Expression<int>? id,
    Expression<String>? nama,
    Expression<int>? hargaKatalog,
    Expression<String>? satuan,
    Expression<bool>? bolehPecahan,
    Expression<int>? kategoriId,
    Expression<bool>? aktif,
    Expression<String>? foto,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (hargaKatalog != null) 'harga_katalog': hargaKatalog,
      if (satuan != null) 'satuan': satuan,
      if (bolehPecahan != null) 'boleh_pecahan': bolehPecahan,
      if (kategoriId != null) 'kategori_id': kategoriId,
      if (aktif != null) 'aktif': aktif,
      if (foto != null) 'foto': foto,
    });
  }

  ProdukCompanion copyWith({
    Value<int>? id,
    Value<String>? nama,
    Value<int>? hargaKatalog,
    Value<String>? satuan,
    Value<bool>? bolehPecahan,
    Value<int?>? kategoriId,
    Value<bool>? aktif,
    Value<String?>? foto,
  }) {
    return ProdukCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      hargaKatalog: hargaKatalog ?? this.hargaKatalog,
      satuan: satuan ?? this.satuan,
      bolehPecahan: bolehPecahan ?? this.bolehPecahan,
      kategoriId: kategoriId ?? this.kategoriId,
      aktif: aktif ?? this.aktif,
      foto: foto ?? this.foto,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (hargaKatalog.present) {
      map['harga_katalog'] = Variable<int>(hargaKatalog.value);
    }
    if (satuan.present) {
      map['satuan'] = Variable<String>(satuan.value);
    }
    if (bolehPecahan.present) {
      map['boleh_pecahan'] = Variable<bool>(bolehPecahan.value);
    }
    if (kategoriId.present) {
      map['kategori_id'] = Variable<int>(kategoriId.value);
    }
    if (aktif.present) {
      map['aktif'] = Variable<bool>(aktif.value);
    }
    if (foto.present) {
      map['foto'] = Variable<String>(foto.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProdukCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('hargaKatalog: $hargaKatalog, ')
          ..write('satuan: $satuan, ')
          ..write('bolehPecahan: $bolehPecahan, ')
          ..write('kategoriId: $kategoriId, ')
          ..write('aktif: $aktif, ')
          ..write('foto: $foto')
          ..write(')'))
        .toString();
  }
}

class $PergerakanStokTable extends PergerakanStok
    with TableInfo<$PergerakanStokTable, PergerakanStokData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PergerakanStokTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _produkIdMeta = const VerificationMeta(
    'produkId',
  );
  @override
  late final GeneratedColumn<int> produkId = GeneratedColumn<int>(
    'produk_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES produk (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<JenisPergerakan, String> jenis =
      GeneratedColumn<String>(
        'jenis',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<JenisPergerakan>($PergerakanStokTable.$converterjenis);
  static const VerificationMeta _jumlahMiliMeta = const VerificationMeta(
    'jumlahMili',
  );
  @override
  late final GeneratedColumn<int> jumlahMili = GeneratedColumn<int>(
    'jumlah_mili',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waktuMeta = const VerificationMeta('waktu');
  @override
  late final GeneratedColumn<DateTime> waktu = GeneratedColumn<DateTime>(
    'waktu',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    produkId,
    jenis,
    jumlahMili,
    waktu,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pergerakan_stok';
  @override
  VerificationContext validateIntegrity(
    Insertable<PergerakanStokData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('produk_id')) {
      context.handle(
        _produkIdMeta,
        produkId.isAcceptableOrUnknown(data['produk_id']!, _produkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produkIdMeta);
    }
    if (data.containsKey('jumlah_mili')) {
      context.handle(
        _jumlahMiliMeta,
        jumlahMili.isAcceptableOrUnknown(data['jumlah_mili']!, _jumlahMiliMeta),
      );
    } else if (isInserting) {
      context.missing(_jumlahMiliMeta);
    }
    if (data.containsKey('waktu')) {
      context.handle(
        _waktuMeta,
        waktu.isAcceptableOrUnknown(data['waktu']!, _waktuMeta),
      );
    } else if (isInserting) {
      context.missing(_waktuMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PergerakanStokData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PergerakanStokData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}produk_id'],
      )!,
      jenis: $PergerakanStokTable.$converterjenis.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}jenis'],
        )!,
      ),
      jumlahMili: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jumlah_mili'],
      )!,
      waktu: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}waktu'],
      )!,
    );
  }

  @override
  $PergerakanStokTable createAlias(String alias) {
    return $PergerakanStokTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<JenisPergerakan, String, String> $converterjenis =
      const EnumNameConverter<JenisPergerakan>(JenisPergerakan.values);
}

class PergerakanStokData extends DataClass
    implements Insertable<PergerakanStokData> {
  final int id;
  final int produkId;
  final JenisPergerakan jenis;

  /// Perubahan berskala seribu: 2500 berarti 2,5. Negatif untuk Stok keluar.
  final int jumlahMili;
  final DateTime waktu;
  const PergerakanStokData({
    required this.id,
    required this.produkId,
    required this.jenis,
    required this.jumlahMili,
    required this.waktu,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['produk_id'] = Variable<int>(produkId);
    {
      map['jenis'] = Variable<String>(
        $PergerakanStokTable.$converterjenis.toSql(jenis),
      );
    }
    map['jumlah_mili'] = Variable<int>(jumlahMili);
    map['waktu'] = Variable<DateTime>(waktu);
    return map;
  }

  PergerakanStokCompanion toCompanion(bool nullToAbsent) {
    return PergerakanStokCompanion(
      id: Value(id),
      produkId: Value(produkId),
      jenis: Value(jenis),
      jumlahMili: Value(jumlahMili),
      waktu: Value(waktu),
    );
  }

  factory PergerakanStokData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PergerakanStokData(
      id: serializer.fromJson<int>(json['id']),
      produkId: serializer.fromJson<int>(json['produkId']),
      jenis: $PergerakanStokTable.$converterjenis.fromJson(
        serializer.fromJson<String>(json['jenis']),
      ),
      jumlahMili: serializer.fromJson<int>(json['jumlahMili']),
      waktu: serializer.fromJson<DateTime>(json['waktu']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'produkId': serializer.toJson<int>(produkId),
      'jenis': serializer.toJson<String>(
        $PergerakanStokTable.$converterjenis.toJson(jenis),
      ),
      'jumlahMili': serializer.toJson<int>(jumlahMili),
      'waktu': serializer.toJson<DateTime>(waktu),
    };
  }

  PergerakanStokData copyWith({
    int? id,
    int? produkId,
    JenisPergerakan? jenis,
    int? jumlahMili,
    DateTime? waktu,
  }) => PergerakanStokData(
    id: id ?? this.id,
    produkId: produkId ?? this.produkId,
    jenis: jenis ?? this.jenis,
    jumlahMili: jumlahMili ?? this.jumlahMili,
    waktu: waktu ?? this.waktu,
  );
  PergerakanStokData copyWithCompanion(PergerakanStokCompanion data) {
    return PergerakanStokData(
      id: data.id.present ? data.id.value : this.id,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      jenis: data.jenis.present ? data.jenis.value : this.jenis,
      jumlahMili: data.jumlahMili.present
          ? data.jumlahMili.value
          : this.jumlahMili,
      waktu: data.waktu.present ? data.waktu.value : this.waktu,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PergerakanStokData(')
          ..write('id: $id, ')
          ..write('produkId: $produkId, ')
          ..write('jenis: $jenis, ')
          ..write('jumlahMili: $jumlahMili, ')
          ..write('waktu: $waktu')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, produkId, jenis, jumlahMili, waktu);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PergerakanStokData &&
          other.id == this.id &&
          other.produkId == this.produkId &&
          other.jenis == this.jenis &&
          other.jumlahMili == this.jumlahMili &&
          other.waktu == this.waktu);
}

class PergerakanStokCompanion extends UpdateCompanion<PergerakanStokData> {
  final Value<int> id;
  final Value<int> produkId;
  final Value<JenisPergerakan> jenis;
  final Value<int> jumlahMili;
  final Value<DateTime> waktu;
  const PergerakanStokCompanion({
    this.id = const Value.absent(),
    this.produkId = const Value.absent(),
    this.jenis = const Value.absent(),
    this.jumlahMili = const Value.absent(),
    this.waktu = const Value.absent(),
  });
  PergerakanStokCompanion.insert({
    this.id = const Value.absent(),
    required int produkId,
    required JenisPergerakan jenis,
    required int jumlahMili,
    required DateTime waktu,
  }) : produkId = Value(produkId),
       jenis = Value(jenis),
       jumlahMili = Value(jumlahMili),
       waktu = Value(waktu);
  static Insertable<PergerakanStokData> custom({
    Expression<int>? id,
    Expression<int>? produkId,
    Expression<String>? jenis,
    Expression<int>? jumlahMili,
    Expression<DateTime>? waktu,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (produkId != null) 'produk_id': produkId,
      if (jenis != null) 'jenis': jenis,
      if (jumlahMili != null) 'jumlah_mili': jumlahMili,
      if (waktu != null) 'waktu': waktu,
    });
  }

  PergerakanStokCompanion copyWith({
    Value<int>? id,
    Value<int>? produkId,
    Value<JenisPergerakan>? jenis,
    Value<int>? jumlahMili,
    Value<DateTime>? waktu,
  }) {
    return PergerakanStokCompanion(
      id: id ?? this.id,
      produkId: produkId ?? this.produkId,
      jenis: jenis ?? this.jenis,
      jumlahMili: jumlahMili ?? this.jumlahMili,
      waktu: waktu ?? this.waktu,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (produkId.present) {
      map['produk_id'] = Variable<int>(produkId.value);
    }
    if (jenis.present) {
      map['jenis'] = Variable<String>(
        $PergerakanStokTable.$converterjenis.toSql(jenis.value),
      );
    }
    if (jumlahMili.present) {
      map['jumlah_mili'] = Variable<int>(jumlahMili.value);
    }
    if (waktu.present) {
      map['waktu'] = Variable<DateTime>(waktu.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PergerakanStokCompanion(')
          ..write('id: $id, ')
          ..write('produkId: $produkId, ')
          ..write('jenis: $jenis, ')
          ..write('jumlahMili: $jumlahMili, ')
          ..write('waktu: $waktu')
          ..write(')'))
        .toString();
  }
}

class $TransaksiTable extends Transaksi
    with TableInfo<$TransaksiTable, TransaksiData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransaksiTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomorMeta = const VerificationMeta('nomor');
  @override
  late final GeneratedColumn<String> nomor = GeneratedColumn<String>(
    'nomor',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _waktuMeta = const VerificationMeta('waktu');
  @override
  late final GeneratedColumn<DateTime> waktu = GeneratedColumn<DateTime>(
    'waktu',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MetodeBayar, String> metodeBayar =
      GeneratedColumn<String>(
        'metode_bayar',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MetodeBayar>($TransaksiTable.$convertermetodeBayar);
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<int> subtotal = GeneratedColumn<int>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<JenisDiskon?, String>
  diskonJenis = GeneratedColumn<String>(
    'diskon_jenis',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<JenisDiskon?>($TransaksiTable.$converterdiskonJenisn);
  static const VerificationMeta _diskonNilaiMeta = const VerificationMeta(
    'diskonNilai',
  );
  @override
  late final GeneratedColumn<int> diskonNilai = GeneratedColumn<int>(
    'diskon_nilai',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _potonganMeta = const VerificationMeta(
    'potongan',
  );
  @override
  late final GeneratedColumn<int> potongan = GeneratedColumn<int>(
    'potongan',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uangDiterimaMeta = const VerificationMeta(
    'uangDiterima',
  );
  @override
  late final GeneratedColumn<int> uangDiterima = GeneratedColumn<int>(
    'uang_diterima',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kembalianMeta = const VerificationMeta(
    'kembalian',
  );
  @override
  late final GeneratedColumn<int> kembalian = GeneratedColumn<int>(
    'kembalian',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nomor,
    waktu,
    metodeBayar,
    subtotal,
    diskonJenis,
    diskonNilai,
    potongan,
    total,
    uangDiterima,
    kembalian,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaksi';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransaksiData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nomor')) {
      context.handle(
        _nomorMeta,
        nomor.isAcceptableOrUnknown(data['nomor']!, _nomorMeta),
      );
    } else if (isInserting) {
      context.missing(_nomorMeta);
    }
    if (data.containsKey('waktu')) {
      context.handle(
        _waktuMeta,
        waktu.isAcceptableOrUnknown(data['waktu']!, _waktuMeta),
      );
    } else if (isInserting) {
      context.missing(_waktuMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('diskon_nilai')) {
      context.handle(
        _diskonNilaiMeta,
        diskonNilai.isAcceptableOrUnknown(
          data['diskon_nilai']!,
          _diskonNilaiMeta,
        ),
      );
    }
    if (data.containsKey('potongan')) {
      context.handle(
        _potonganMeta,
        potongan.isAcceptableOrUnknown(data['potongan']!, _potonganMeta),
      );
    } else if (isInserting) {
      context.missing(_potonganMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('uang_diterima')) {
      context.handle(
        _uangDiterimaMeta,
        uangDiterima.isAcceptableOrUnknown(
          data['uang_diterima']!,
          _uangDiterimaMeta,
        ),
      );
    }
    if (data.containsKey('kembalian')) {
      context.handle(
        _kembalianMeta,
        kembalian.isAcceptableOrUnknown(data['kembalian']!, _kembalianMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransaksiData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransaksiData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nomor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nomor'],
      )!,
      waktu: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}waktu'],
      )!,
      metodeBayar: $TransaksiTable.$convertermetodeBayar.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}metode_bayar'],
        )!,
      ),
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal'],
      )!,
      diskonJenis: $TransaksiTable.$converterdiskonJenisn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}diskon_jenis'],
        ),
      ),
      diskonNilai: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diskon_nilai'],
      ),
      potongan: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}potongan'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      uangDiterima: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uang_diterima'],
      ),
      kembalian: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kembalian'],
      ),
    );
  }

  @override
  $TransaksiTable createAlias(String alias) {
    return $TransaksiTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MetodeBayar, String, String> $convertermetodeBayar =
      const EnumNameConverter<MetodeBayar>(MetodeBayar.values);
  static JsonTypeConverter2<JenisDiskon, String, String> $converterdiskonJenis =
      const EnumNameConverter<JenisDiskon>(JenisDiskon.values);
  static JsonTypeConverter2<JenisDiskon?, String?, String?>
  $converterdiskonJenisn = JsonTypeConverter2.asNullable($converterdiskonJenis);
}

class TransaksiData extends DataClass implements Insertable<TransaksiData> {
  final int id;

  /// `TRX-<YYYYMMDD>-<NNN>`; unik sebagai jaring pengaman terakhir kalau
  /// penghitung urutan pernah salah.
  final String nomor;
  final DateTime waktu;
  final MetodeBayar metodeBayar;
  final int subtotal;

  /// Diskon disimpan sebagai bentuk aslinya, bukan hanya hasil potongannya,
  /// supaya Struk bisa menulis "Diskon 10%".
  final JenisDiskon? diskonJenis;
  final int? diskonNilai;
  final int potongan;
  final int total;

  /// Hanya terisi untuk pembayaran Tunai; QRIS tidak punya Kembalian.
  final int? uangDiterima;
  final int? kembalian;
  const TransaksiData({
    required this.id,
    required this.nomor,
    required this.waktu,
    required this.metodeBayar,
    required this.subtotal,
    this.diskonJenis,
    this.diskonNilai,
    required this.potongan,
    required this.total,
    this.uangDiterima,
    this.kembalian,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nomor'] = Variable<String>(nomor);
    map['waktu'] = Variable<DateTime>(waktu);
    {
      map['metode_bayar'] = Variable<String>(
        $TransaksiTable.$convertermetodeBayar.toSql(metodeBayar),
      );
    }
    map['subtotal'] = Variable<int>(subtotal);
    if (!nullToAbsent || diskonJenis != null) {
      map['diskon_jenis'] = Variable<String>(
        $TransaksiTable.$converterdiskonJenisn.toSql(diskonJenis),
      );
    }
    if (!nullToAbsent || diskonNilai != null) {
      map['diskon_nilai'] = Variable<int>(diskonNilai);
    }
    map['potongan'] = Variable<int>(potongan);
    map['total'] = Variable<int>(total);
    if (!nullToAbsent || uangDiterima != null) {
      map['uang_diterima'] = Variable<int>(uangDiterima);
    }
    if (!nullToAbsent || kembalian != null) {
      map['kembalian'] = Variable<int>(kembalian);
    }
    return map;
  }

  TransaksiCompanion toCompanion(bool nullToAbsent) {
    return TransaksiCompanion(
      id: Value(id),
      nomor: Value(nomor),
      waktu: Value(waktu),
      metodeBayar: Value(metodeBayar),
      subtotal: Value(subtotal),
      diskonJenis: diskonJenis == null && nullToAbsent
          ? const Value.absent()
          : Value(diskonJenis),
      diskonNilai: diskonNilai == null && nullToAbsent
          ? const Value.absent()
          : Value(diskonNilai),
      potongan: Value(potongan),
      total: Value(total),
      uangDiterima: uangDiterima == null && nullToAbsent
          ? const Value.absent()
          : Value(uangDiterima),
      kembalian: kembalian == null && nullToAbsent
          ? const Value.absent()
          : Value(kembalian),
    );
  }

  factory TransaksiData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransaksiData(
      id: serializer.fromJson<int>(json['id']),
      nomor: serializer.fromJson<String>(json['nomor']),
      waktu: serializer.fromJson<DateTime>(json['waktu']),
      metodeBayar: $TransaksiTable.$convertermetodeBayar.fromJson(
        serializer.fromJson<String>(json['metodeBayar']),
      ),
      subtotal: serializer.fromJson<int>(json['subtotal']),
      diskonJenis: $TransaksiTable.$converterdiskonJenisn.fromJson(
        serializer.fromJson<String?>(json['diskonJenis']),
      ),
      diskonNilai: serializer.fromJson<int?>(json['diskonNilai']),
      potongan: serializer.fromJson<int>(json['potongan']),
      total: serializer.fromJson<int>(json['total']),
      uangDiterima: serializer.fromJson<int?>(json['uangDiterima']),
      kembalian: serializer.fromJson<int?>(json['kembalian']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nomor': serializer.toJson<String>(nomor),
      'waktu': serializer.toJson<DateTime>(waktu),
      'metodeBayar': serializer.toJson<String>(
        $TransaksiTable.$convertermetodeBayar.toJson(metodeBayar),
      ),
      'subtotal': serializer.toJson<int>(subtotal),
      'diskonJenis': serializer.toJson<String?>(
        $TransaksiTable.$converterdiskonJenisn.toJson(diskonJenis),
      ),
      'diskonNilai': serializer.toJson<int?>(diskonNilai),
      'potongan': serializer.toJson<int>(potongan),
      'total': serializer.toJson<int>(total),
      'uangDiterima': serializer.toJson<int?>(uangDiterima),
      'kembalian': serializer.toJson<int?>(kembalian),
    };
  }

  TransaksiData copyWith({
    int? id,
    String? nomor,
    DateTime? waktu,
    MetodeBayar? metodeBayar,
    int? subtotal,
    Value<JenisDiskon?> diskonJenis = const Value.absent(),
    Value<int?> diskonNilai = const Value.absent(),
    int? potongan,
    int? total,
    Value<int?> uangDiterima = const Value.absent(),
    Value<int?> kembalian = const Value.absent(),
  }) => TransaksiData(
    id: id ?? this.id,
    nomor: nomor ?? this.nomor,
    waktu: waktu ?? this.waktu,
    metodeBayar: metodeBayar ?? this.metodeBayar,
    subtotal: subtotal ?? this.subtotal,
    diskonJenis: diskonJenis.present ? diskonJenis.value : this.diskonJenis,
    diskonNilai: diskonNilai.present ? diskonNilai.value : this.diskonNilai,
    potongan: potongan ?? this.potongan,
    total: total ?? this.total,
    uangDiterima: uangDiterima.present ? uangDiterima.value : this.uangDiterima,
    kembalian: kembalian.present ? kembalian.value : this.kembalian,
  );
  TransaksiData copyWithCompanion(TransaksiCompanion data) {
    return TransaksiData(
      id: data.id.present ? data.id.value : this.id,
      nomor: data.nomor.present ? data.nomor.value : this.nomor,
      waktu: data.waktu.present ? data.waktu.value : this.waktu,
      metodeBayar: data.metodeBayar.present
          ? data.metodeBayar.value
          : this.metodeBayar,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      diskonJenis: data.diskonJenis.present
          ? data.diskonJenis.value
          : this.diskonJenis,
      diskonNilai: data.diskonNilai.present
          ? data.diskonNilai.value
          : this.diskonNilai,
      potongan: data.potongan.present ? data.potongan.value : this.potongan,
      total: data.total.present ? data.total.value : this.total,
      uangDiterima: data.uangDiterima.present
          ? data.uangDiterima.value
          : this.uangDiterima,
      kembalian: data.kembalian.present ? data.kembalian.value : this.kembalian,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransaksiData(')
          ..write('id: $id, ')
          ..write('nomor: $nomor, ')
          ..write('waktu: $waktu, ')
          ..write('metodeBayar: $metodeBayar, ')
          ..write('subtotal: $subtotal, ')
          ..write('diskonJenis: $diskonJenis, ')
          ..write('diskonNilai: $diskonNilai, ')
          ..write('potongan: $potongan, ')
          ..write('total: $total, ')
          ..write('uangDiterima: $uangDiterima, ')
          ..write('kembalian: $kembalian')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nomor,
    waktu,
    metodeBayar,
    subtotal,
    diskonJenis,
    diskonNilai,
    potongan,
    total,
    uangDiterima,
    kembalian,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransaksiData &&
          other.id == this.id &&
          other.nomor == this.nomor &&
          other.waktu == this.waktu &&
          other.metodeBayar == this.metodeBayar &&
          other.subtotal == this.subtotal &&
          other.diskonJenis == this.diskonJenis &&
          other.diskonNilai == this.diskonNilai &&
          other.potongan == this.potongan &&
          other.total == this.total &&
          other.uangDiterima == this.uangDiterima &&
          other.kembalian == this.kembalian);
}

class TransaksiCompanion extends UpdateCompanion<TransaksiData> {
  final Value<int> id;
  final Value<String> nomor;
  final Value<DateTime> waktu;
  final Value<MetodeBayar> metodeBayar;
  final Value<int> subtotal;
  final Value<JenisDiskon?> diskonJenis;
  final Value<int?> diskonNilai;
  final Value<int> potongan;
  final Value<int> total;
  final Value<int?> uangDiterima;
  final Value<int?> kembalian;
  const TransaksiCompanion({
    this.id = const Value.absent(),
    this.nomor = const Value.absent(),
    this.waktu = const Value.absent(),
    this.metodeBayar = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.diskonJenis = const Value.absent(),
    this.diskonNilai = const Value.absent(),
    this.potongan = const Value.absent(),
    this.total = const Value.absent(),
    this.uangDiterima = const Value.absent(),
    this.kembalian = const Value.absent(),
  });
  TransaksiCompanion.insert({
    this.id = const Value.absent(),
    required String nomor,
    required DateTime waktu,
    required MetodeBayar metodeBayar,
    required int subtotal,
    this.diskonJenis = const Value.absent(),
    this.diskonNilai = const Value.absent(),
    required int potongan,
    required int total,
    this.uangDiterima = const Value.absent(),
    this.kembalian = const Value.absent(),
  }) : nomor = Value(nomor),
       waktu = Value(waktu),
       metodeBayar = Value(metodeBayar),
       subtotal = Value(subtotal),
       potongan = Value(potongan),
       total = Value(total);
  static Insertable<TransaksiData> custom({
    Expression<int>? id,
    Expression<String>? nomor,
    Expression<DateTime>? waktu,
    Expression<String>? metodeBayar,
    Expression<int>? subtotal,
    Expression<String>? diskonJenis,
    Expression<int>? diskonNilai,
    Expression<int>? potongan,
    Expression<int>? total,
    Expression<int>? uangDiterima,
    Expression<int>? kembalian,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nomor != null) 'nomor': nomor,
      if (waktu != null) 'waktu': waktu,
      if (metodeBayar != null) 'metode_bayar': metodeBayar,
      if (subtotal != null) 'subtotal': subtotal,
      if (diskonJenis != null) 'diskon_jenis': diskonJenis,
      if (diskonNilai != null) 'diskon_nilai': diskonNilai,
      if (potongan != null) 'potongan': potongan,
      if (total != null) 'total': total,
      if (uangDiterima != null) 'uang_diterima': uangDiterima,
      if (kembalian != null) 'kembalian': kembalian,
    });
  }

  TransaksiCompanion copyWith({
    Value<int>? id,
    Value<String>? nomor,
    Value<DateTime>? waktu,
    Value<MetodeBayar>? metodeBayar,
    Value<int>? subtotal,
    Value<JenisDiskon?>? diskonJenis,
    Value<int?>? diskonNilai,
    Value<int>? potongan,
    Value<int>? total,
    Value<int?>? uangDiterima,
    Value<int?>? kembalian,
  }) {
    return TransaksiCompanion(
      id: id ?? this.id,
      nomor: nomor ?? this.nomor,
      waktu: waktu ?? this.waktu,
      metodeBayar: metodeBayar ?? this.metodeBayar,
      subtotal: subtotal ?? this.subtotal,
      diskonJenis: diskonJenis ?? this.diskonJenis,
      diskonNilai: diskonNilai ?? this.diskonNilai,
      potongan: potongan ?? this.potongan,
      total: total ?? this.total,
      uangDiterima: uangDiterima ?? this.uangDiterima,
      kembalian: kembalian ?? this.kembalian,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nomor.present) {
      map['nomor'] = Variable<String>(nomor.value);
    }
    if (waktu.present) {
      map['waktu'] = Variable<DateTime>(waktu.value);
    }
    if (metodeBayar.present) {
      map['metode_bayar'] = Variable<String>(
        $TransaksiTable.$convertermetodeBayar.toSql(metodeBayar.value),
      );
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<int>(subtotal.value);
    }
    if (diskonJenis.present) {
      map['diskon_jenis'] = Variable<String>(
        $TransaksiTable.$converterdiskonJenisn.toSql(diskonJenis.value),
      );
    }
    if (diskonNilai.present) {
      map['diskon_nilai'] = Variable<int>(diskonNilai.value);
    }
    if (potongan.present) {
      map['potongan'] = Variable<int>(potongan.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (uangDiterima.present) {
      map['uang_diterima'] = Variable<int>(uangDiterima.value);
    }
    if (kembalian.present) {
      map['kembalian'] = Variable<int>(kembalian.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransaksiCompanion(')
          ..write('id: $id, ')
          ..write('nomor: $nomor, ')
          ..write('waktu: $waktu, ')
          ..write('metodeBayar: $metodeBayar, ')
          ..write('subtotal: $subtotal, ')
          ..write('diskonJenis: $diskonJenis, ')
          ..write('diskonNilai: $diskonNilai, ')
          ..write('potongan: $potongan, ')
          ..write('total: $total, ')
          ..write('uangDiterima: $uangDiterima, ')
          ..write('kembalian: $kembalian')
          ..write(')'))
        .toString();
  }
}

class $BarisTransaksiTable extends BarisTransaksi
    with TableInfo<$BarisTransaksiTable, BarisTransaksiData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BarisTransaksiTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _transaksiIdMeta = const VerificationMeta(
    'transaksiId',
  );
  @override
  late final GeneratedColumn<int> transaksiId = GeneratedColumn<int>(
    'transaksi_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transaksi (id)',
    ),
  );
  static const VerificationMeta _produkIdMeta = const VerificationMeta(
    'produkId',
  );
  @override
  late final GeneratedColumn<int> produkId = GeneratedColumn<int>(
    'produk_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES produk (id)',
    ),
  );
  static const VerificationMeta _namaProdukMeta = const VerificationMeta(
    'namaProduk',
  );
  @override
  late final GeneratedColumn<String> namaProduk = GeneratedColumn<String>(
    'nama_produk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _satuanMeta = const VerificationMeta('satuan');
  @override
  late final GeneratedColumn<String> satuan = GeneratedColumn<String>(
    'satuan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hargaSatuanMeta = const VerificationMeta(
    'hargaSatuan',
  );
  @override
  late final GeneratedColumn<int> hargaSatuan = GeneratedColumn<int>(
    'harga_satuan',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kuantitasMiliMeta = const VerificationMeta(
    'kuantitasMili',
  );
  @override
  late final GeneratedColumn<int> kuantitasMili = GeneratedColumn<int>(
    'kuantitas_mili',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<int> subtotal = GeneratedColumn<int>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transaksiId,
    produkId,
    namaProduk,
    satuan,
    hargaSatuan,
    kuantitasMili,
    subtotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'baris_transaksi';
  @override
  VerificationContext validateIntegrity(
    Insertable<BarisTransaksiData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaksi_id')) {
      context.handle(
        _transaksiIdMeta,
        transaksiId.isAcceptableOrUnknown(
          data['transaksi_id']!,
          _transaksiIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transaksiIdMeta);
    }
    if (data.containsKey('produk_id')) {
      context.handle(
        _produkIdMeta,
        produkId.isAcceptableOrUnknown(data['produk_id']!, _produkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produkIdMeta);
    }
    if (data.containsKey('nama_produk')) {
      context.handle(
        _namaProdukMeta,
        namaProduk.isAcceptableOrUnknown(data['nama_produk']!, _namaProdukMeta),
      );
    } else if (isInserting) {
      context.missing(_namaProdukMeta);
    }
    if (data.containsKey('satuan')) {
      context.handle(
        _satuanMeta,
        satuan.isAcceptableOrUnknown(data['satuan']!, _satuanMeta),
      );
    } else if (isInserting) {
      context.missing(_satuanMeta);
    }
    if (data.containsKey('harga_satuan')) {
      context.handle(
        _hargaSatuanMeta,
        hargaSatuan.isAcceptableOrUnknown(
          data['harga_satuan']!,
          _hargaSatuanMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hargaSatuanMeta);
    }
    if (data.containsKey('kuantitas_mili')) {
      context.handle(
        _kuantitasMiliMeta,
        kuantitasMili.isAcceptableOrUnknown(
          data['kuantitas_mili']!,
          _kuantitasMiliMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kuantitasMiliMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BarisTransaksiData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BarisTransaksiData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      transaksiId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}transaksi_id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}produk_id'],
      )!,
      namaProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_produk'],
      )!,
      satuan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}satuan'],
      )!,
      hargaSatuan: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}harga_satuan'],
      )!,
      kuantitasMili: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}kuantitas_mili'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal'],
      )!,
    );
  }

  @override
  $BarisTransaksiTable createAlias(String alias) {
    return $BarisTransaksiTable(attachedDatabase, alias);
  }
}

class BarisTransaksiData extends DataClass
    implements Insertable<BarisTransaksiData> {
  final int id;
  final int transaksiId;
  final int produkId;
  final String namaProduk;
  final String satuan;
  final int hargaSatuan;
  final int kuantitasMili;
  final int subtotal;
  const BarisTransaksiData({
    required this.id,
    required this.transaksiId,
    required this.produkId,
    required this.namaProduk,
    required this.satuan,
    required this.hargaSatuan,
    required this.kuantitasMili,
    required this.subtotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['transaksi_id'] = Variable<int>(transaksiId);
    map['produk_id'] = Variable<int>(produkId);
    map['nama_produk'] = Variable<String>(namaProduk);
    map['satuan'] = Variable<String>(satuan);
    map['harga_satuan'] = Variable<int>(hargaSatuan);
    map['kuantitas_mili'] = Variable<int>(kuantitasMili);
    map['subtotal'] = Variable<int>(subtotal);
    return map;
  }

  BarisTransaksiCompanion toCompanion(bool nullToAbsent) {
    return BarisTransaksiCompanion(
      id: Value(id),
      transaksiId: Value(transaksiId),
      produkId: Value(produkId),
      namaProduk: Value(namaProduk),
      satuan: Value(satuan),
      hargaSatuan: Value(hargaSatuan),
      kuantitasMili: Value(kuantitasMili),
      subtotal: Value(subtotal),
    );
  }

  factory BarisTransaksiData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BarisTransaksiData(
      id: serializer.fromJson<int>(json['id']),
      transaksiId: serializer.fromJson<int>(json['transaksiId']),
      produkId: serializer.fromJson<int>(json['produkId']),
      namaProduk: serializer.fromJson<String>(json['namaProduk']),
      satuan: serializer.fromJson<String>(json['satuan']),
      hargaSatuan: serializer.fromJson<int>(json['hargaSatuan']),
      kuantitasMili: serializer.fromJson<int>(json['kuantitasMili']),
      subtotal: serializer.fromJson<int>(json['subtotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'transaksiId': serializer.toJson<int>(transaksiId),
      'produkId': serializer.toJson<int>(produkId),
      'namaProduk': serializer.toJson<String>(namaProduk),
      'satuan': serializer.toJson<String>(satuan),
      'hargaSatuan': serializer.toJson<int>(hargaSatuan),
      'kuantitasMili': serializer.toJson<int>(kuantitasMili),
      'subtotal': serializer.toJson<int>(subtotal),
    };
  }

  BarisTransaksiData copyWith({
    int? id,
    int? transaksiId,
    int? produkId,
    String? namaProduk,
    String? satuan,
    int? hargaSatuan,
    int? kuantitasMili,
    int? subtotal,
  }) => BarisTransaksiData(
    id: id ?? this.id,
    transaksiId: transaksiId ?? this.transaksiId,
    produkId: produkId ?? this.produkId,
    namaProduk: namaProduk ?? this.namaProduk,
    satuan: satuan ?? this.satuan,
    hargaSatuan: hargaSatuan ?? this.hargaSatuan,
    kuantitasMili: kuantitasMili ?? this.kuantitasMili,
    subtotal: subtotal ?? this.subtotal,
  );
  BarisTransaksiData copyWithCompanion(BarisTransaksiCompanion data) {
    return BarisTransaksiData(
      id: data.id.present ? data.id.value : this.id,
      transaksiId: data.transaksiId.present
          ? data.transaksiId.value
          : this.transaksiId,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      namaProduk: data.namaProduk.present
          ? data.namaProduk.value
          : this.namaProduk,
      satuan: data.satuan.present ? data.satuan.value : this.satuan,
      hargaSatuan: data.hargaSatuan.present
          ? data.hargaSatuan.value
          : this.hargaSatuan,
      kuantitasMili: data.kuantitasMili.present
          ? data.kuantitasMili.value
          : this.kuantitasMili,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BarisTransaksiData(')
          ..write('id: $id, ')
          ..write('transaksiId: $transaksiId, ')
          ..write('produkId: $produkId, ')
          ..write('namaProduk: $namaProduk, ')
          ..write('satuan: $satuan, ')
          ..write('hargaSatuan: $hargaSatuan, ')
          ..write('kuantitasMili: $kuantitasMili, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transaksiId,
    produkId,
    namaProduk,
    satuan,
    hargaSatuan,
    kuantitasMili,
    subtotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BarisTransaksiData &&
          other.id == this.id &&
          other.transaksiId == this.transaksiId &&
          other.produkId == this.produkId &&
          other.namaProduk == this.namaProduk &&
          other.satuan == this.satuan &&
          other.hargaSatuan == this.hargaSatuan &&
          other.kuantitasMili == this.kuantitasMili &&
          other.subtotal == this.subtotal);
}

class BarisTransaksiCompanion extends UpdateCompanion<BarisTransaksiData> {
  final Value<int> id;
  final Value<int> transaksiId;
  final Value<int> produkId;
  final Value<String> namaProduk;
  final Value<String> satuan;
  final Value<int> hargaSatuan;
  final Value<int> kuantitasMili;
  final Value<int> subtotal;
  const BarisTransaksiCompanion({
    this.id = const Value.absent(),
    this.transaksiId = const Value.absent(),
    this.produkId = const Value.absent(),
    this.namaProduk = const Value.absent(),
    this.satuan = const Value.absent(),
    this.hargaSatuan = const Value.absent(),
    this.kuantitasMili = const Value.absent(),
    this.subtotal = const Value.absent(),
  });
  BarisTransaksiCompanion.insert({
    this.id = const Value.absent(),
    required int transaksiId,
    required int produkId,
    required String namaProduk,
    required String satuan,
    required int hargaSatuan,
    required int kuantitasMili,
    required int subtotal,
  }) : transaksiId = Value(transaksiId),
       produkId = Value(produkId),
       namaProduk = Value(namaProduk),
       satuan = Value(satuan),
       hargaSatuan = Value(hargaSatuan),
       kuantitasMili = Value(kuantitasMili),
       subtotal = Value(subtotal);
  static Insertable<BarisTransaksiData> custom({
    Expression<int>? id,
    Expression<int>? transaksiId,
    Expression<int>? produkId,
    Expression<String>? namaProduk,
    Expression<String>? satuan,
    Expression<int>? hargaSatuan,
    Expression<int>? kuantitasMili,
    Expression<int>? subtotal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transaksiId != null) 'transaksi_id': transaksiId,
      if (produkId != null) 'produk_id': produkId,
      if (namaProduk != null) 'nama_produk': namaProduk,
      if (satuan != null) 'satuan': satuan,
      if (hargaSatuan != null) 'harga_satuan': hargaSatuan,
      if (kuantitasMili != null) 'kuantitas_mili': kuantitasMili,
      if (subtotal != null) 'subtotal': subtotal,
    });
  }

  BarisTransaksiCompanion copyWith({
    Value<int>? id,
    Value<int>? transaksiId,
    Value<int>? produkId,
    Value<String>? namaProduk,
    Value<String>? satuan,
    Value<int>? hargaSatuan,
    Value<int>? kuantitasMili,
    Value<int>? subtotal,
  }) {
    return BarisTransaksiCompanion(
      id: id ?? this.id,
      transaksiId: transaksiId ?? this.transaksiId,
      produkId: produkId ?? this.produkId,
      namaProduk: namaProduk ?? this.namaProduk,
      satuan: satuan ?? this.satuan,
      hargaSatuan: hargaSatuan ?? this.hargaSatuan,
      kuantitasMili: kuantitasMili ?? this.kuantitasMili,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (transaksiId.present) {
      map['transaksi_id'] = Variable<int>(transaksiId.value);
    }
    if (produkId.present) {
      map['produk_id'] = Variable<int>(produkId.value);
    }
    if (namaProduk.present) {
      map['nama_produk'] = Variable<String>(namaProduk.value);
    }
    if (satuan.present) {
      map['satuan'] = Variable<String>(satuan.value);
    }
    if (hargaSatuan.present) {
      map['harga_satuan'] = Variable<int>(hargaSatuan.value);
    }
    if (kuantitasMili.present) {
      map['kuantitas_mili'] = Variable<int>(kuantitasMili.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<int>(subtotal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BarisTransaksiCompanion(')
          ..write('id: $id, ')
          ..write('transaksiId: $transaksiId, ')
          ..write('produkId: $produkId, ')
          ..write('namaProduk: $namaProduk, ')
          ..write('satuan: $satuan, ')
          ..write('hargaSatuan: $hargaSatuan, ')
          ..write('kuantitasMili: $kuantitasMili, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $KategoriTable kategori = $KategoriTable(this);
  late final $ProdukTable produk = $ProdukTable(this);
  late final $PergerakanStokTable pergerakanStok = $PergerakanStokTable(this);
  late final $TransaksiTable transaksi = $TransaksiTable(this);
  late final $BarisTransaksiTable barisTransaksi = $BarisTransaksiTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettings,
    kategori,
    produk,
    pergerakanStok,
    transaksi,
    barisTransaksi,
  ];
}

typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$KategoriTableCreateCompanionBuilder =
    KategoriCompanion Function({Value<int> id, required String nama});
typedef $$KategoriTableUpdateCompanionBuilder =
    KategoriCompanion Function({Value<int> id, Value<String> nama});

final class $$KategoriTableReferences
    extends BaseReferences<_$AppDatabase, $KategoriTable, KategoriData> {
  $$KategoriTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProdukTable, List<ProdukData>> _produkRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.produk,
    aliasName: 'kategori__id__produk__kategori_id',
  );

  $$ProdukTableProcessedTableManager get produkRefs {
    final manager = $$ProdukTableTableManager(
      $_db,
      $_db.produk,
    ).filter((f) => f.kategoriId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_produkRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$KategoriTableFilterComposer
    extends Composer<_$AppDatabase, $KategoriTable> {
  $$KategoriTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> produkRefs(
    Expression<bool> Function($$ProdukTableFilterComposer f) f,
  ) {
    final $$ProdukTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.produk,
      getReferencedColumn: (t) => t.kategoriId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdukTableFilterComposer(
            $db: $db,
            $table: $db.produk,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KategoriTableOrderingComposer
    extends Composer<_$AppDatabase, $KategoriTable> {
  $$KategoriTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KategoriTableAnnotationComposer
    extends Composer<_$AppDatabase, $KategoriTable> {
  $$KategoriTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  Expression<T> produkRefs<T extends Object>(
    Expression<T> Function($$ProdukTableAnnotationComposer a) f,
  ) {
    final $$ProdukTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.produk,
      getReferencedColumn: (t) => t.kategoriId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdukTableAnnotationComposer(
            $db: $db,
            $table: $db.produk,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$KategoriTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KategoriTable,
          KategoriData,
          $$KategoriTableFilterComposer,
          $$KategoriTableOrderingComposer,
          $$KategoriTableAnnotationComposer,
          $$KategoriTableCreateCompanionBuilder,
          $$KategoriTableUpdateCompanionBuilder,
          (KategoriData, $$KategoriTableReferences),
          KategoriData,
          PrefetchHooks Function({bool produkRefs})
        > {
  $$KategoriTableTableManager(_$AppDatabase db, $KategoriTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KategoriTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KategoriTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KategoriTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
              }) => KategoriCompanion(id: id, nama: nama),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String nama}) =>
                  KategoriCompanion.insert(id: id, nama: nama),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KategoriTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({produkRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (produkRefs) db.produk],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (produkRefs)
                    await $_getPrefetchedData<
                      KategoriData,
                      $KategoriTable,
                      ProdukData
                    >(
                      currentTable: table,
                      referencedTable: $$KategoriTableReferences
                          ._produkRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$KategoriTableReferences(db, table, p0).produkRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.kategoriId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$KategoriTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KategoriTable,
      KategoriData,
      $$KategoriTableFilterComposer,
      $$KategoriTableOrderingComposer,
      $$KategoriTableAnnotationComposer,
      $$KategoriTableCreateCompanionBuilder,
      $$KategoriTableUpdateCompanionBuilder,
      (KategoriData, $$KategoriTableReferences),
      KategoriData,
      PrefetchHooks Function({bool produkRefs})
    >;
typedef $$ProdukTableCreateCompanionBuilder =
    ProdukCompanion Function({
      Value<int> id,
      required String nama,
      required int hargaKatalog,
      required String satuan,
      Value<bool> bolehPecahan,
      Value<int?> kategoriId,
      Value<bool> aktif,
      Value<String?> foto,
    });
typedef $$ProdukTableUpdateCompanionBuilder =
    ProdukCompanion Function({
      Value<int> id,
      Value<String> nama,
      Value<int> hargaKatalog,
      Value<String> satuan,
      Value<bool> bolehPecahan,
      Value<int?> kategoriId,
      Value<bool> aktif,
      Value<String?> foto,
    });

final class $$ProdukTableReferences
    extends BaseReferences<_$AppDatabase, $ProdukTable, ProdukData> {
  $$ProdukTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $KategoriTable _kategoriIdTable(_$AppDatabase db) =>
      db.kategori.createAlias('produk__kategori_id__kategori__id');

  $$KategoriTableProcessedTableManager? get kategoriId {
    final $_column = $_itemColumn<int>('kategori_id');
    if ($_column == null) return null;
    final manager = $$KategoriTableTableManager(
      $_db,
      $_db.kategori,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kategoriIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PergerakanStokTable, List<PergerakanStokData>>
  _pergerakanStokRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pergerakanStok,
    aliasName: 'produk__id__pergerakan_stok__produk_id',
  );

  $$PergerakanStokTableProcessedTableManager get pergerakanStokRefs {
    final manager = $$PergerakanStokTableTableManager(
      $_db,
      $_db.pergerakanStok,
    ).filter((f) => f.produkId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_pergerakanStokRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BarisTransaksiTable, List<BarisTransaksiData>>
  _barisTransaksiRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.barisTransaksi,
    aliasName: 'produk__id__baris_transaksi__produk_id',
  );

  $$BarisTransaksiTableProcessedTableManager get barisTransaksiRefs {
    final manager = $$BarisTransaksiTableTableManager(
      $_db,
      $_db.barisTransaksi,
    ).filter((f) => f.produkId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_barisTransaksiRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProdukTableFilterComposer
    extends Composer<_$AppDatabase, $ProdukTable> {
  $$ProdukTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hargaKatalog => $composableBuilder(
    column: $table.hargaKatalog,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get satuan => $composableBuilder(
    column: $table.satuan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get bolehPecahan => $composableBuilder(
    column: $table.bolehPecahan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get aktif => $composableBuilder(
    column: $table.aktif,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get foto => $composableBuilder(
    column: $table.foto,
    builder: (column) => ColumnFilters(column),
  );

  $$KategoriTableFilterComposer get kategoriId {
    final $$KategoriTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kategoriId,
      referencedTable: $db.kategori,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KategoriTableFilterComposer(
            $db: $db,
            $table: $db.kategori,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> pergerakanStokRefs(
    Expression<bool> Function($$PergerakanStokTableFilterComposer f) f,
  ) {
    final $$PergerakanStokTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pergerakanStok,
      getReferencedColumn: (t) => t.produkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PergerakanStokTableFilterComposer(
            $db: $db,
            $table: $db.pergerakanStok,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> barisTransaksiRefs(
    Expression<bool> Function($$BarisTransaksiTableFilterComposer f) f,
  ) {
    final $$BarisTransaksiTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.barisTransaksi,
      getReferencedColumn: (t) => t.produkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BarisTransaksiTableFilterComposer(
            $db: $db,
            $table: $db.barisTransaksi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProdukTableOrderingComposer
    extends Composer<_$AppDatabase, $ProdukTable> {
  $$ProdukTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hargaKatalog => $composableBuilder(
    column: $table.hargaKatalog,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get satuan => $composableBuilder(
    column: $table.satuan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get bolehPecahan => $composableBuilder(
    column: $table.bolehPecahan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get aktif => $composableBuilder(
    column: $table.aktif,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get foto => $composableBuilder(
    column: $table.foto,
    builder: (column) => ColumnOrderings(column),
  );

  $$KategoriTableOrderingComposer get kategoriId {
    final $$KategoriTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kategoriId,
      referencedTable: $db.kategori,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KategoriTableOrderingComposer(
            $db: $db,
            $table: $db.kategori,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProdukTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProdukTable> {
  $$ProdukTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<int> get hargaKatalog => $composableBuilder(
    column: $table.hargaKatalog,
    builder: (column) => column,
  );

  GeneratedColumn<String> get satuan =>
      $composableBuilder(column: $table.satuan, builder: (column) => column);

  GeneratedColumn<bool> get bolehPecahan => $composableBuilder(
    column: $table.bolehPecahan,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get aktif =>
      $composableBuilder(column: $table.aktif, builder: (column) => column);

  GeneratedColumn<String> get foto =>
      $composableBuilder(column: $table.foto, builder: (column) => column);

  $$KategoriTableAnnotationComposer get kategoriId {
    final $$KategoriTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kategoriId,
      referencedTable: $db.kategori,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KategoriTableAnnotationComposer(
            $db: $db,
            $table: $db.kategori,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> pergerakanStokRefs<T extends Object>(
    Expression<T> Function($$PergerakanStokTableAnnotationComposer a) f,
  ) {
    final $$PergerakanStokTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pergerakanStok,
      getReferencedColumn: (t) => t.produkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PergerakanStokTableAnnotationComposer(
            $db: $db,
            $table: $db.pergerakanStok,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> barisTransaksiRefs<T extends Object>(
    Expression<T> Function($$BarisTransaksiTableAnnotationComposer a) f,
  ) {
    final $$BarisTransaksiTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.barisTransaksi,
      getReferencedColumn: (t) => t.produkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BarisTransaksiTableAnnotationComposer(
            $db: $db,
            $table: $db.barisTransaksi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProdukTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProdukTable,
          ProdukData,
          $$ProdukTableFilterComposer,
          $$ProdukTableOrderingComposer,
          $$ProdukTableAnnotationComposer,
          $$ProdukTableCreateCompanionBuilder,
          $$ProdukTableUpdateCompanionBuilder,
          (ProdukData, $$ProdukTableReferences),
          ProdukData,
          PrefetchHooks Function({
            bool kategoriId,
            bool pergerakanStokRefs,
            bool barisTransaksiRefs,
          })
        > {
  $$ProdukTableTableManager(_$AppDatabase db, $ProdukTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProdukTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProdukTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProdukTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<int> hargaKatalog = const Value.absent(),
                Value<String> satuan = const Value.absent(),
                Value<bool> bolehPecahan = const Value.absent(),
                Value<int?> kategoriId = const Value.absent(),
                Value<bool> aktif = const Value.absent(),
                Value<String?> foto = const Value.absent(),
              }) => ProdukCompanion(
                id: id,
                nama: nama,
                hargaKatalog: hargaKatalog,
                satuan: satuan,
                bolehPecahan: bolehPecahan,
                kategoriId: kategoriId,
                aktif: aktif,
                foto: foto,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nama,
                required int hargaKatalog,
                required String satuan,
                Value<bool> bolehPecahan = const Value.absent(),
                Value<int?> kategoriId = const Value.absent(),
                Value<bool> aktif = const Value.absent(),
                Value<String?> foto = const Value.absent(),
              }) => ProdukCompanion.insert(
                id: id,
                nama: nama,
                hargaKatalog: hargaKatalog,
                satuan: satuan,
                bolehPecahan: bolehPecahan,
                kategoriId: kategoriId,
                aktif: aktif,
                foto: foto,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ProdukTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                kategoriId = false,
                pergerakanStokRefs = false,
                barisTransaksiRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (pergerakanStokRefs) db.pergerakanStok,
                    if (barisTransaksiRefs) db.barisTransaksi,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (kategoriId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.kategoriId,
                                    referencedTable: $$ProdukTableReferences
                                        ._kategoriIdTable(db),
                                    referencedColumn: $$ProdukTableReferences
                                        ._kategoriIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (pergerakanStokRefs)
                        await $_getPrefetchedData<
                          ProdukData,
                          $ProdukTable,
                          PergerakanStokData
                        >(
                          currentTable: table,
                          referencedTable: $$ProdukTableReferences
                              ._pergerakanStokRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProdukTableReferences(
                                db,
                                table,
                                p0,
                              ).pergerakanStokRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.produkId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (barisTransaksiRefs)
                        await $_getPrefetchedData<
                          ProdukData,
                          $ProdukTable,
                          BarisTransaksiData
                        >(
                          currentTable: table,
                          referencedTable: $$ProdukTableReferences
                              ._barisTransaksiRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProdukTableReferences(
                                db,
                                table,
                                p0,
                              ).barisTransaksiRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.produkId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProdukTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProdukTable,
      ProdukData,
      $$ProdukTableFilterComposer,
      $$ProdukTableOrderingComposer,
      $$ProdukTableAnnotationComposer,
      $$ProdukTableCreateCompanionBuilder,
      $$ProdukTableUpdateCompanionBuilder,
      (ProdukData, $$ProdukTableReferences),
      ProdukData,
      PrefetchHooks Function({
        bool kategoriId,
        bool pergerakanStokRefs,
        bool barisTransaksiRefs,
      })
    >;
typedef $$PergerakanStokTableCreateCompanionBuilder =
    PergerakanStokCompanion Function({
      Value<int> id,
      required int produkId,
      required JenisPergerakan jenis,
      required int jumlahMili,
      required DateTime waktu,
    });
typedef $$PergerakanStokTableUpdateCompanionBuilder =
    PergerakanStokCompanion Function({
      Value<int> id,
      Value<int> produkId,
      Value<JenisPergerakan> jenis,
      Value<int> jumlahMili,
      Value<DateTime> waktu,
    });

final class $$PergerakanStokTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PergerakanStokTable,
          PergerakanStokData
        > {
  $$PergerakanStokTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProdukTable _produkIdTable(_$AppDatabase db) =>
      db.produk.createAlias('pergerakan_stok__produk_id__produk__id');

  $$ProdukTableProcessedTableManager get produkId {
    final $_column = $_itemColumn<int>('produk_id')!;

    final manager = $$ProdukTableTableManager(
      $_db,
      $_db.produk,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_produkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PergerakanStokTableFilterComposer
    extends Composer<_$AppDatabase, $PergerakanStokTable> {
  $$PergerakanStokTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<JenisPergerakan, JenisPergerakan, String>
  get jenis => $composableBuilder(
    column: $table.jenis,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get jumlahMili => $composableBuilder(
    column: $table.jumlahMili,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get waktu => $composableBuilder(
    column: $table.waktu,
    builder: (column) => ColumnFilters(column),
  );

  $$ProdukTableFilterComposer get produkId {
    final $$ProdukTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produkId,
      referencedTable: $db.produk,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdukTableFilterComposer(
            $db: $db,
            $table: $db.produk,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PergerakanStokTableOrderingComposer
    extends Composer<_$AppDatabase, $PergerakanStokTable> {
  $$PergerakanStokTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jenis => $composableBuilder(
    column: $table.jenis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get jumlahMili => $composableBuilder(
    column: $table.jumlahMili,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get waktu => $composableBuilder(
    column: $table.waktu,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProdukTableOrderingComposer get produkId {
    final $$ProdukTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produkId,
      referencedTable: $db.produk,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdukTableOrderingComposer(
            $db: $db,
            $table: $db.produk,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PergerakanStokTableAnnotationComposer
    extends Composer<_$AppDatabase, $PergerakanStokTable> {
  $$PergerakanStokTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<JenisPergerakan, String> get jenis =>
      $composableBuilder(column: $table.jenis, builder: (column) => column);

  GeneratedColumn<int> get jumlahMili => $composableBuilder(
    column: $table.jumlahMili,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get waktu =>
      $composableBuilder(column: $table.waktu, builder: (column) => column);

  $$ProdukTableAnnotationComposer get produkId {
    final $$ProdukTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produkId,
      referencedTable: $db.produk,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdukTableAnnotationComposer(
            $db: $db,
            $table: $db.produk,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PergerakanStokTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PergerakanStokTable,
          PergerakanStokData,
          $$PergerakanStokTableFilterComposer,
          $$PergerakanStokTableOrderingComposer,
          $$PergerakanStokTableAnnotationComposer,
          $$PergerakanStokTableCreateCompanionBuilder,
          $$PergerakanStokTableUpdateCompanionBuilder,
          (PergerakanStokData, $$PergerakanStokTableReferences),
          PergerakanStokData,
          PrefetchHooks Function({bool produkId})
        > {
  $$PergerakanStokTableTableManager(
    _$AppDatabase db,
    $PergerakanStokTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PergerakanStokTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PergerakanStokTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PergerakanStokTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> produkId = const Value.absent(),
                Value<JenisPergerakan> jenis = const Value.absent(),
                Value<int> jumlahMili = const Value.absent(),
                Value<DateTime> waktu = const Value.absent(),
              }) => PergerakanStokCompanion(
                id: id,
                produkId: produkId,
                jenis: jenis,
                jumlahMili: jumlahMili,
                waktu: waktu,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int produkId,
                required JenisPergerakan jenis,
                required int jumlahMili,
                required DateTime waktu,
              }) => PergerakanStokCompanion.insert(
                id: id,
                produkId: produkId,
                jenis: jenis,
                jumlahMili: jumlahMili,
                waktu: waktu,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PergerakanStokTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({produkId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (produkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.produkId,
                                referencedTable: $$PergerakanStokTableReferences
                                    ._produkIdTable(db),
                                referencedColumn:
                                    $$PergerakanStokTableReferences
                                        ._produkIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PergerakanStokTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PergerakanStokTable,
      PergerakanStokData,
      $$PergerakanStokTableFilterComposer,
      $$PergerakanStokTableOrderingComposer,
      $$PergerakanStokTableAnnotationComposer,
      $$PergerakanStokTableCreateCompanionBuilder,
      $$PergerakanStokTableUpdateCompanionBuilder,
      (PergerakanStokData, $$PergerakanStokTableReferences),
      PergerakanStokData,
      PrefetchHooks Function({bool produkId})
    >;
typedef $$TransaksiTableCreateCompanionBuilder =
    TransaksiCompanion Function({
      Value<int> id,
      required String nomor,
      required DateTime waktu,
      required MetodeBayar metodeBayar,
      required int subtotal,
      Value<JenisDiskon?> diskonJenis,
      Value<int?> diskonNilai,
      required int potongan,
      required int total,
      Value<int?> uangDiterima,
      Value<int?> kembalian,
    });
typedef $$TransaksiTableUpdateCompanionBuilder =
    TransaksiCompanion Function({
      Value<int> id,
      Value<String> nomor,
      Value<DateTime> waktu,
      Value<MetodeBayar> metodeBayar,
      Value<int> subtotal,
      Value<JenisDiskon?> diskonJenis,
      Value<int?> diskonNilai,
      Value<int> potongan,
      Value<int> total,
      Value<int?> uangDiterima,
      Value<int?> kembalian,
    });

final class $$TransaksiTableReferences
    extends BaseReferences<_$AppDatabase, $TransaksiTable, TransaksiData> {
  $$TransaksiTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BarisTransaksiTable, List<BarisTransaksiData>>
  _barisTransaksiRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.barisTransaksi,
    aliasName: 'transaksi__id__baris_transaksi__transaksi_id',
  );

  $$BarisTransaksiTableProcessedTableManager get barisTransaksiRefs {
    final manager = $$BarisTransaksiTableTableManager(
      $_db,
      $_db.barisTransaksi,
    ).filter((f) => f.transaksiId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_barisTransaksiRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransaksiTableFilterComposer
    extends Composer<_$AppDatabase, $TransaksiTable> {
  $$TransaksiTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomor => $composableBuilder(
    column: $table.nomor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get waktu => $composableBuilder(
    column: $table.waktu,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MetodeBayar, MetodeBayar, String>
  get metodeBayar => $composableBuilder(
    column: $table.metodeBayar,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<JenisDiskon?, JenisDiskon, String>
  get diskonJenis => $composableBuilder(
    column: $table.diskonJenis,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get diskonNilai => $composableBuilder(
    column: $table.diskonNilai,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get potongan => $composableBuilder(
    column: $table.potongan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uangDiterima => $composableBuilder(
    column: $table.uangDiterima,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kembalian => $composableBuilder(
    column: $table.kembalian,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> barisTransaksiRefs(
    Expression<bool> Function($$BarisTransaksiTableFilterComposer f) f,
  ) {
    final $$BarisTransaksiTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.barisTransaksi,
      getReferencedColumn: (t) => t.transaksiId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BarisTransaksiTableFilterComposer(
            $db: $db,
            $table: $db.barisTransaksi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransaksiTableOrderingComposer
    extends Composer<_$AppDatabase, $TransaksiTable> {
  $$TransaksiTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomor => $composableBuilder(
    column: $table.nomor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get waktu => $composableBuilder(
    column: $table.waktu,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metodeBayar => $composableBuilder(
    column: $table.metodeBayar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diskonJenis => $composableBuilder(
    column: $table.diskonJenis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diskonNilai => $composableBuilder(
    column: $table.diskonNilai,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get potongan => $composableBuilder(
    column: $table.potongan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uangDiterima => $composableBuilder(
    column: $table.uangDiterima,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kembalian => $composableBuilder(
    column: $table.kembalian,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransaksiTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransaksiTable> {
  $$TransaksiTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nomor =>
      $composableBuilder(column: $table.nomor, builder: (column) => column);

  GeneratedColumn<DateTime> get waktu =>
      $composableBuilder(column: $table.waktu, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MetodeBayar, String> get metodeBayar =>
      $composableBuilder(
        column: $table.metodeBayar,
        builder: (column) => column,
      );

  GeneratedColumn<int> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumnWithTypeConverter<JenisDiskon?, String> get diskonJenis =>
      $composableBuilder(
        column: $table.diskonJenis,
        builder: (column) => column,
      );

  GeneratedColumn<int> get diskonNilai => $composableBuilder(
    column: $table.diskonNilai,
    builder: (column) => column,
  );

  GeneratedColumn<int> get potongan =>
      $composableBuilder(column: $table.potongan, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get uangDiterima => $composableBuilder(
    column: $table.uangDiterima,
    builder: (column) => column,
  );

  GeneratedColumn<int> get kembalian =>
      $composableBuilder(column: $table.kembalian, builder: (column) => column);

  Expression<T> barisTransaksiRefs<T extends Object>(
    Expression<T> Function($$BarisTransaksiTableAnnotationComposer a) f,
  ) {
    final $$BarisTransaksiTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.barisTransaksi,
      getReferencedColumn: (t) => t.transaksiId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BarisTransaksiTableAnnotationComposer(
            $db: $db,
            $table: $db.barisTransaksi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransaksiTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransaksiTable,
          TransaksiData,
          $$TransaksiTableFilterComposer,
          $$TransaksiTableOrderingComposer,
          $$TransaksiTableAnnotationComposer,
          $$TransaksiTableCreateCompanionBuilder,
          $$TransaksiTableUpdateCompanionBuilder,
          (TransaksiData, $$TransaksiTableReferences),
          TransaksiData,
          PrefetchHooks Function({bool barisTransaksiRefs})
        > {
  $$TransaksiTableTableManager(_$AppDatabase db, $TransaksiTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransaksiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransaksiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransaksiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nomor = const Value.absent(),
                Value<DateTime> waktu = const Value.absent(),
                Value<MetodeBayar> metodeBayar = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
                Value<JenisDiskon?> diskonJenis = const Value.absent(),
                Value<int?> diskonNilai = const Value.absent(),
                Value<int> potongan = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int?> uangDiterima = const Value.absent(),
                Value<int?> kembalian = const Value.absent(),
              }) => TransaksiCompanion(
                id: id,
                nomor: nomor,
                waktu: waktu,
                metodeBayar: metodeBayar,
                subtotal: subtotal,
                diskonJenis: diskonJenis,
                diskonNilai: diskonNilai,
                potongan: potongan,
                total: total,
                uangDiterima: uangDiterima,
                kembalian: kembalian,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nomor,
                required DateTime waktu,
                required MetodeBayar metodeBayar,
                required int subtotal,
                Value<JenisDiskon?> diskonJenis = const Value.absent(),
                Value<int?> diskonNilai = const Value.absent(),
                required int potongan,
                required int total,
                Value<int?> uangDiterima = const Value.absent(),
                Value<int?> kembalian = const Value.absent(),
              }) => TransaksiCompanion.insert(
                id: id,
                nomor: nomor,
                waktu: waktu,
                metodeBayar: metodeBayar,
                subtotal: subtotal,
                diskonJenis: diskonJenis,
                diskonNilai: diskonNilai,
                potongan: potongan,
                total: total,
                uangDiterima: uangDiterima,
                kembalian: kembalian,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransaksiTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({barisTransaksiRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (barisTransaksiRefs) db.barisTransaksi,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (barisTransaksiRefs)
                    await $_getPrefetchedData<
                      TransaksiData,
                      $TransaksiTable,
                      BarisTransaksiData
                    >(
                      currentTable: table,
                      referencedTable: $$TransaksiTableReferences
                          ._barisTransaksiRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TransaksiTableReferences(
                            db,
                            table,
                            p0,
                          ).barisTransaksiRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.transaksiId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TransaksiTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransaksiTable,
      TransaksiData,
      $$TransaksiTableFilterComposer,
      $$TransaksiTableOrderingComposer,
      $$TransaksiTableAnnotationComposer,
      $$TransaksiTableCreateCompanionBuilder,
      $$TransaksiTableUpdateCompanionBuilder,
      (TransaksiData, $$TransaksiTableReferences),
      TransaksiData,
      PrefetchHooks Function({bool barisTransaksiRefs})
    >;
typedef $$BarisTransaksiTableCreateCompanionBuilder =
    BarisTransaksiCompanion Function({
      Value<int> id,
      required int transaksiId,
      required int produkId,
      required String namaProduk,
      required String satuan,
      required int hargaSatuan,
      required int kuantitasMili,
      required int subtotal,
    });
typedef $$BarisTransaksiTableUpdateCompanionBuilder =
    BarisTransaksiCompanion Function({
      Value<int> id,
      Value<int> transaksiId,
      Value<int> produkId,
      Value<String> namaProduk,
      Value<String> satuan,
      Value<int> hargaSatuan,
      Value<int> kuantitasMili,
      Value<int> subtotal,
    });

final class $$BarisTransaksiTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BarisTransaksiTable,
          BarisTransaksiData
        > {
  $$BarisTransaksiTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TransaksiTable _transaksiIdTable(_$AppDatabase db) =>
      db.transaksi.createAlias('baris_transaksi__transaksi_id__transaksi__id');

  $$TransaksiTableProcessedTableManager get transaksiId {
    final $_column = $_itemColumn<int>('transaksi_id')!;

    final manager = $$TransaksiTableTableManager(
      $_db,
      $_db.transaksi,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transaksiIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProdukTable _produkIdTable(_$AppDatabase db) =>
      db.produk.createAlias('baris_transaksi__produk_id__produk__id');

  $$ProdukTableProcessedTableManager get produkId {
    final $_column = $_itemColumn<int>('produk_id')!;

    final manager = $$ProdukTableTableManager(
      $_db,
      $_db.produk,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_produkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BarisTransaksiTableFilterComposer
    extends Composer<_$AppDatabase, $BarisTransaksiTable> {
  $$BarisTransaksiTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get satuan => $composableBuilder(
    column: $table.satuan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hargaSatuan => $composableBuilder(
    column: $table.hargaSatuan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get kuantitasMili => $composableBuilder(
    column: $table.kuantitasMili,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  $$TransaksiTableFilterComposer get transaksiId {
    final $$TransaksiTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transaksiId,
      referencedTable: $db.transaksi,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableFilterComposer(
            $db: $db,
            $table: $db.transaksi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProdukTableFilterComposer get produkId {
    final $$ProdukTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produkId,
      referencedTable: $db.produk,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdukTableFilterComposer(
            $db: $db,
            $table: $db.produk,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BarisTransaksiTableOrderingComposer
    extends Composer<_$AppDatabase, $BarisTransaksiTable> {
  $$BarisTransaksiTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get satuan => $composableBuilder(
    column: $table.satuan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hargaSatuan => $composableBuilder(
    column: $table.hargaSatuan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kuantitasMili => $composableBuilder(
    column: $table.kuantitasMili,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  $$TransaksiTableOrderingComposer get transaksiId {
    final $$TransaksiTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transaksiId,
      referencedTable: $db.transaksi,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableOrderingComposer(
            $db: $db,
            $table: $db.transaksi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProdukTableOrderingComposer get produkId {
    final $$ProdukTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produkId,
      referencedTable: $db.produk,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdukTableOrderingComposer(
            $db: $db,
            $table: $db.produk,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BarisTransaksiTableAnnotationComposer
    extends Composer<_$AppDatabase, $BarisTransaksiTable> {
  $$BarisTransaksiTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => column,
  );

  GeneratedColumn<String> get satuan =>
      $composableBuilder(column: $table.satuan, builder: (column) => column);

  GeneratedColumn<int> get hargaSatuan => $composableBuilder(
    column: $table.hargaSatuan,
    builder: (column) => column,
  );

  GeneratedColumn<int> get kuantitasMili => $composableBuilder(
    column: $table.kuantitasMili,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  $$TransaksiTableAnnotationComposer get transaksiId {
    final $$TransaksiTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transaksiId,
      referencedTable: $db.transaksi,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransaksiTableAnnotationComposer(
            $db: $db,
            $table: $db.transaksi,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProdukTableAnnotationComposer get produkId {
    final $$ProdukTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produkId,
      referencedTable: $db.produk,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdukTableAnnotationComposer(
            $db: $db,
            $table: $db.produk,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BarisTransaksiTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BarisTransaksiTable,
          BarisTransaksiData,
          $$BarisTransaksiTableFilterComposer,
          $$BarisTransaksiTableOrderingComposer,
          $$BarisTransaksiTableAnnotationComposer,
          $$BarisTransaksiTableCreateCompanionBuilder,
          $$BarisTransaksiTableUpdateCompanionBuilder,
          (BarisTransaksiData, $$BarisTransaksiTableReferences),
          BarisTransaksiData,
          PrefetchHooks Function({bool transaksiId, bool produkId})
        > {
  $$BarisTransaksiTableTableManager(
    _$AppDatabase db,
    $BarisTransaksiTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BarisTransaksiTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BarisTransaksiTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BarisTransaksiTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> transaksiId = const Value.absent(),
                Value<int> produkId = const Value.absent(),
                Value<String> namaProduk = const Value.absent(),
                Value<String> satuan = const Value.absent(),
                Value<int> hargaSatuan = const Value.absent(),
                Value<int> kuantitasMili = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
              }) => BarisTransaksiCompanion(
                id: id,
                transaksiId: transaksiId,
                produkId: produkId,
                namaProduk: namaProduk,
                satuan: satuan,
                hargaSatuan: hargaSatuan,
                kuantitasMili: kuantitasMili,
                subtotal: subtotal,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int transaksiId,
                required int produkId,
                required String namaProduk,
                required String satuan,
                required int hargaSatuan,
                required int kuantitasMili,
                required int subtotal,
              }) => BarisTransaksiCompanion.insert(
                id: id,
                transaksiId: transaksiId,
                produkId: produkId,
                namaProduk: namaProduk,
                satuan: satuan,
                hargaSatuan: hargaSatuan,
                kuantitasMili: kuantitasMili,
                subtotal: subtotal,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BarisTransaksiTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({transaksiId = false, produkId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (transaksiId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.transaksiId,
                                referencedTable: $$BarisTransaksiTableReferences
                                    ._transaksiIdTable(db),
                                referencedColumn:
                                    $$BarisTransaksiTableReferences
                                        ._transaksiIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (produkId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.produkId,
                                referencedTable: $$BarisTransaksiTableReferences
                                    ._produkIdTable(db),
                                referencedColumn:
                                    $$BarisTransaksiTableReferences
                                        ._produkIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BarisTransaksiTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BarisTransaksiTable,
      BarisTransaksiData,
      $$BarisTransaksiTableFilterComposer,
      $$BarisTransaksiTableOrderingComposer,
      $$BarisTransaksiTableAnnotationComposer,
      $$BarisTransaksiTableCreateCompanionBuilder,
      $$BarisTransaksiTableUpdateCompanionBuilder,
      (BarisTransaksiData, $$BarisTransaksiTableReferences),
      BarisTransaksiData,
      PrefetchHooks Function({bool transaksiId, bool produkId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$KategoriTableTableManager get kategori =>
      $$KategoriTableTableManager(_db, _db.kategori);
  $$ProdukTableTableManager get produk =>
      $$ProdukTableTableManager(_db, _db.produk);
  $$PergerakanStokTableTableManager get pergerakanStok =>
      $$PergerakanStokTableTableManager(_db, _db.pergerakanStok);
  $$TransaksiTableTableManager get transaksi =>
      $$TransaksiTableTableManager(_db, _db.transaksi);
  $$BarisTransaksiTableTableManager get barisTransaksi =>
      $$BarisTransaksiTableTableManager(_db, _db.barisTransaksi);
}
