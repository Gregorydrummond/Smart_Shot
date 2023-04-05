// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetSessionCollection on Isar {
  IsarCollection<Session> get sessions => collection();
}

const SessionSchema = CollectionSchema(
  name: r'Session',
  schema:
      r'{"name":"Session","idName":"id","properties":[{"name":"airballShots","type":"Long"},{"name":"bankShots","type":"Long"},{"name":"duration","type":"Double"},{"name":"madeShots","type":"Long"},{"name":"missedShots","type":"Long"},{"name":"rating","type":"Double"},{"name":"shotPercentage","type":"Double"},{"name":"startTime","type":"Long"},{"name":"swishShots","type":"Long"},{"name":"totalShots","type":"Long"}],"indexes":[],"links":[]}',
  idName: r'id',
  propertyIds: {
    r'airballShots': 0,
    r'bankShots': 1,
    r'duration': 2,
    r'madeShots': 3,
    r'missedShots': 4,
    r'rating': 5,
    r'shotPercentage': 6,
    r'startTime': 7,
    r'swishShots': 8,
    r'totalShots': 9
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _sessionGetId,
  setId: _sessionSetId,
  getLinks: _sessionGetLinks,
  attachLinks: _sessionAttachLinks,
  serializeNative: _sessionSerializeNative,
  deserializeNative: _sessionDeserializeNative,
  deserializePropNative: _sessionDeserializePropNative,
  serializeWeb: _sessionSerializeWeb,
  deserializeWeb: _sessionDeserializeWeb,
  deserializePropWeb: _sessionDeserializePropWeb,
  version: 4,
);

int? _sessionGetId(Session object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _sessionSetId(Session object, int id) {
  object.id = id;
}

List<IsarLinkBase<dynamic>> _sessionGetLinks(Session object) {
  return [];
}

void _sessionSerializeNative(
    IsarCollection<Session> collection,
    IsarCObject cObj,
    Session object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  final size = (staticSize) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeLong(offsets[0], object.airballShots);
  writer.writeLong(offsets[1], object.bankShots);
  writer.writeDouble(offsets[2], object.duration);
  writer.writeLong(offsets[3], object.madeShots);
  writer.writeLong(offsets[4], object.missedShots);
  writer.writeDouble(offsets[5], object.rating);
  writer.writeDouble(offsets[6], object.shotPercentage);
  writer.writeDateTime(offsets[7], object.startTime);
  writer.writeLong(offsets[8], object.swishShots);
  writer.writeLong(offsets[9], object.totalShots);
}

Session _sessionDeserializeNative(IsarCollection<Session> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Session();
  object.airballShots = reader.readLong(offsets[0]);
  object.bankShots = reader.readLong(offsets[1]);
  object.duration = reader.readDouble(offsets[2]);
  object.id = id;
  object.madeShots = reader.readLong(offsets[3]);
  object.missedShots = reader.readLong(offsets[4]);
  object.rating = reader.readDouble(offsets[5]);
  object.shotPercentage = reader.readDouble(offsets[6]);
  object.startTime = reader.readDateTime(offsets[7]);
  object.swishShots = reader.readLong(offsets[8]);
  object.totalShots = reader.readLong(offsets[9]);
  return object;
}

P _sessionDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Illegal propertyIndex');
  }
}

Object _sessionSerializeWeb(
    IsarCollection<Session> collection, Session object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'airballShots', object.airballShots);
  IsarNative.jsObjectSet(jsObj, r'bankShots', object.bankShots);
  IsarNative.jsObjectSet(jsObj, r'duration', object.duration);
  IsarNative.jsObjectSet(jsObj, r'hotStreak', object.hotStreak);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'madeShots', object.madeShots);
  IsarNative.jsObjectSet(jsObj, r'missedShots', object.missedShots);
  IsarNative.jsObjectSet(jsObj, r'rating', object.rating);
  IsarNative.jsObjectSet(jsObj, r'shotPercentage', object.shotPercentage);
  IsarNative.jsObjectSet(
      jsObj, r'startTime', object.startTime.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, r'streak', object.streak);
  IsarNative.jsObjectSet(jsObj, r'swishShots', object.swishShots);
  IsarNative.jsObjectSet(jsObj, r'totalShots', object.totalShots);
  return jsObj;
}

Session _sessionDeserializeWeb(
    IsarCollection<Session> collection, Object jsObj) {
  final object = Session();
  object.airballShots = IsarNative.jsObjectGet(jsObj, r'airballShots') ??
      (double.negativeInfinity as int);
  object.bankShots = IsarNative.jsObjectGet(jsObj, r'bankShots') ??
      (double.negativeInfinity as int);
  object.duration =
      IsarNative.jsObjectGet(jsObj, r'duration') ?? double.negativeInfinity;
  object.hotStreak = IsarNative.jsObjectGet(jsObj, r'hotStreak') ??
      (double.negativeInfinity as int);
  object.id = IsarNative.jsObjectGet(jsObj, r'id');
  object.madeShots = IsarNative.jsObjectGet(jsObj, r'madeShots') ??
      (double.negativeInfinity as int);
  object.missedShots = IsarNative.jsObjectGet(jsObj, r'missedShots') ??
      (double.negativeInfinity as int);
  object.rating =
      IsarNative.jsObjectGet(jsObj, r'rating') ?? double.negativeInfinity;
  object.shotPercentage = IsarNative.jsObjectGet(jsObj, r'shotPercentage') ??
      double.negativeInfinity;
  object.startTime = IsarNative.jsObjectGet(jsObj, r'startTime') != null
      ? DateTime.fromMillisecondsSinceEpoch(
              IsarNative.jsObjectGet(jsObj, r'startTime') as int,
              isUtc: true)
          .toLocal()
      : DateTime.fromMillisecondsSinceEpoch(0);
  object.streak = IsarNative.jsObjectGet(jsObj, r'streak') ??
      (double.negativeInfinity as int);
  object.swishShots = IsarNative.jsObjectGet(jsObj, r'swishShots') ??
      (double.negativeInfinity as int);
  object.totalShots = IsarNative.jsObjectGet(jsObj, r'totalShots') ??
      (double.negativeInfinity as int);
  return object;
}

P _sessionDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'airballShots':
      return (IsarNative.jsObjectGet(jsObj, r'airballShots') ??
          (double.negativeInfinity as int)) as P;
    case r'bankShots':
      return (IsarNative.jsObjectGet(jsObj, r'bankShots') ??
          (double.negativeInfinity as int)) as P;
    case r'duration':
      return (IsarNative.jsObjectGet(jsObj, r'duration') ??
          double.negativeInfinity) as P;
    case r'hotStreak':
      return (IsarNative.jsObjectGet(jsObj, r'hotStreak') ??
          (double.negativeInfinity as int)) as P;
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id')) as P;
    case r'madeShots':
      return (IsarNative.jsObjectGet(jsObj, r'madeShots') ??
          (double.negativeInfinity as int)) as P;
    case r'missedShots':
      return (IsarNative.jsObjectGet(jsObj, r'missedShots') ??
          (double.negativeInfinity as int)) as P;
    case r'rating':
      return (IsarNative.jsObjectGet(jsObj, r'rating') ??
          double.negativeInfinity) as P;
    case r'shotPercentage':
      return (IsarNative.jsObjectGet(jsObj, r'shotPercentage') ??
          double.negativeInfinity) as P;
    case r'startTime':
      return (IsarNative.jsObjectGet(jsObj, r'startTime') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, r'startTime') as int,
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    case r'streak':
      return (IsarNative.jsObjectGet(jsObj, r'streak') ??
          (double.negativeInfinity as int)) as P;
    case r'swishShots':
      return (IsarNative.jsObjectGet(jsObj, r'swishShots') ??
          (double.negativeInfinity as int)) as P;
    case r'totalShots':
      return (IsarNative.jsObjectGet(jsObj, r'totalShots') ??
          (double.negativeInfinity as int)) as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _sessionAttachLinks(IsarCollection<dynamic> col, int id, Session object) {}

extension SessionQueryWhereSort on QueryBuilder<Session, Session, QWhere> {
  QueryBuilder<Session, Session, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SessionQueryWhere on QueryBuilder<Session, Session, QWhereClause> {
  QueryBuilder<Session, Session, QAfterWhereClause> idEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterWhereClause> idNotEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Session, Session, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Session, Session, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Session, Session, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SessionQueryFilter
    on QueryBuilder<Session, Session, QFilterCondition> {
  QueryBuilder<Session, Session, QAfterFilterCondition> airballShotsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'airballShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> airballShotsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'airballShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> airballShotsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'airballShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> airballShotsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'airballShots',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> bankShotsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bankShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> bankShotsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bankShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> bankShotsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bankShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> bankShotsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bankShots',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> durationGreaterThan(
      double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> durationLessThan(
      double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'duration',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> durationBetween(
      double lower, double upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duration',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> hotStreakEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hotStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> hotStreakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hotStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> hotStreakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hotStreak',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> hotStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hotStreak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> madeShotsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'madeShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> madeShotsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'madeShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> madeShotsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'madeShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> madeShotsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'madeShots',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> missedShotsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missedShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> missedShotsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'missedShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> missedShotsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'missedShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> missedShotsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'missedShots',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> ratingGreaterThan(
      double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rating',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> ratingLessThan(
      double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'rating',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> ratingBetween(
      double lower, double upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rating',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition>
      shotPercentageGreaterThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'shotPercentage',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> shotPercentageLessThan(
      double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'shotPercentage',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> shotPercentageBetween(
      double lower, double upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'shotPercentage',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> startTimeEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> startTimeGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> startTimeLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startTime',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> streakEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'streak',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> streakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'streak',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> streakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'streak',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> streakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'streak',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> swishShotsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'swishShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> swishShotsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'swishShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> swishShotsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'swishShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> swishShotsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'swishShots',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> totalShotsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> totalShotsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> totalShotsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> totalShotsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalShots',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SessionQueryLinks
    on QueryBuilder<Session, Session, QFilterCondition> {}

extension SessionQueryWhereSortBy on QueryBuilder<Session, Session, QSortBy> {
  QueryBuilder<Session, Session, QAfterSortBy> sortByAirballShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airballShots', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByAirballShotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airballShots', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByBankShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankShots', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByBankShotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankShots', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByHotStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hotStreak', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByHotStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hotStreak', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByMadeShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'madeShots', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByMadeShotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'madeShots', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByMissedShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedShots', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByMissedShotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedShots', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByShotPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shotPercentage', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByShotPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shotPercentage', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortBySwishShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swishShots', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortBySwishShotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swishShots', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByTotalShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalShots', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByTotalShotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalShots', Sort.desc);
    });
  }
}

extension SessionQueryWhereSortThenBy
    on QueryBuilder<Session, Session, QSortThenBy> {
  QueryBuilder<Session, Session, QAfterSortBy> thenByAirballShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airballShots', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByAirballShotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'airballShots', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByBankShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankShots', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByBankShotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankShots', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByHotStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hotStreak', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByHotStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hotStreak', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByMadeShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'madeShots', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByMadeShotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'madeShots', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByMissedShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedShots', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByMissedShotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedShots', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rating', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByShotPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shotPercentage', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByShotPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shotPercentage', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenBySwishShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swishShots', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenBySwishShotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'swishShots', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByTotalShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalShots', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByTotalShotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalShots', Sort.desc);
    });
  }
}

extension SessionQueryWhereDistinct
    on QueryBuilder<Session, Session, QDistinct> {
  QueryBuilder<Session, Session, QDistinct> distinctByAirballShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'airballShots');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByBankShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bankShots');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByHotStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hotStreak');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByMadeShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'madeShots');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByMissedShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missedShots');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rating');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByShotPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shotPercentage');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streak');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctBySwishShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'swishShots');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByTotalShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalShots');
    });
  }
}

extension SessionQueryProperty
    on QueryBuilder<Session, Session, QQueryProperty> {
  QueryBuilder<Session, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Session, int, QQueryOperations> airballShotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'airballShots');
    });
  }

  QueryBuilder<Session, int, QQueryOperations> bankShotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bankShots');
    });
  }

  QueryBuilder<Session, double, QQueryOperations> durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<Session, int, QQueryOperations> hotStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hotStreak');
    });
  }

  QueryBuilder<Session, int, QQueryOperations> madeShotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'madeShots');
    });
  }

  QueryBuilder<Session, int, QQueryOperations> missedShotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missedShots');
    });
  }

  QueryBuilder<Session, double, QQueryOperations> ratingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rating');
    });
  }

  QueryBuilder<Session, double, QQueryOperations> shotPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shotPercentage');
    });
  }

  QueryBuilder<Session, DateTime, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }

  QueryBuilder<Session, int, QQueryOperations> streakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streak');
    });
  }

  QueryBuilder<Session, int, QQueryOperations> swishShotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'swishShots');
    });
  }

  QueryBuilder<Session, int, QQueryOperations> totalShotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalShots');
    });
  }
}
