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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nama,
    hargaKatalog,
    satuan,
    bolehPecahan,
    kategoriId,
    aktif,
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
  const ProdukData({
    required this.id,
    required this.nama,
    required this.hargaKatalog,
    required this.satuan,
    required this.bolehPecahan,
    this.kategoriId,
    required this.aktif,
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
  }) => ProdukData(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    hargaKatalog: hargaKatalog ?? this.hargaKatalog,
    satuan: satuan ?? this.satuan,
    bolehPecahan: bolehPecahan ?? this.bolehPecahan,
    kategoriId: kategoriId.present ? kategoriId.value : this.kategoriId,
    aktif: aktif ?? this.aktif,
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
          ..write('aktif: $aktif')
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
          other.aktif == this.aktif);
}

class ProdukCompanion extends UpdateCompanion<ProdukData> {
  final Value<int> id;
  final Value<String> nama;
  final Value<int> hargaKatalog;
  final Value<String> satuan;
  final Value<bool> bolehPecahan;
  final Value<int?> kategoriId;
  final Value<bool> aktif;
  const ProdukCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.hargaKatalog = const Value.absent(),
    this.satuan = const Value.absent(),
    this.bolehPecahan = const Value.absent(),
    this.kategoriId = const Value.absent(),
    this.aktif = const Value.absent(),
  });
  ProdukCompanion.insert({
    this.id = const Value.absent(),
    required String nama,
    required int hargaKatalog,
    required String satuan,
    this.bolehPecahan = const Value.absent(),
    this.kategoriId = const Value.absent(),
    this.aktif = const Value.absent(),
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
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (hargaKatalog != null) 'harga_katalog': hargaKatalog,
      if (satuan != null) 'satuan': satuan,
      if (bolehPecahan != null) 'boleh_pecahan': bolehPecahan,
      if (kategoriId != null) 'kategori_id': kategoriId,
      if (aktif != null) 'aktif': aktif,
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
  }) {
    return ProdukCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      hargaKatalog: hargaKatalog ?? this.hargaKatalog,
      satuan: satuan ?? this.satuan,
      bolehPecahan: bolehPecahan ?? this.bolehPecahan,
      kategoriId: kategoriId ?? this.kategoriId,
      aktif: aktif ?? this.aktif,
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
          ..write('aktif: $aktif')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $KategoriTable kategori = $KategoriTable(this);
  late final $ProdukTable produk = $ProdukTable(this);
  late final $PergerakanStokTable pergerakanStok = $PergerakanStokTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettings,
    kategori,
    produk,
    pergerakanStok,
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
          PrefetchHooks Function({bool kategoriId, bool pergerakanStokRefs})
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
              }) => ProdukCompanion(
                id: id,
                nama: nama,
                hargaKatalog: hargaKatalog,
                satuan: satuan,
                bolehPecahan: bolehPecahan,
                kategoriId: kategoriId,
                aktif: aktif,
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
              }) => ProdukCompanion.insert(
                id: id,
                nama: nama,
                hargaKatalog: hargaKatalog,
                satuan: satuan,
                bolehPecahan: bolehPecahan,
                kategoriId: kategoriId,
                aktif: aktif,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ProdukTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({kategoriId = false, pergerakanStokRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (pergerakanStokRefs) db.pergerakanStok,
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
      PrefetchHooks Function({bool kategoriId, bool pergerakanStokRefs})
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
}
