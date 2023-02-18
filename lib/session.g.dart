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
      r'{"name":"Session","idName":"id","properties":[{"name":"duration","type":"Double"},{"name":"getSessionDuration","type":"Double"},{"name":"getSessionRating","type":"Double"},{"name":"getShotPercentage","type":"Double"},{"name":"getTotalMakes","type":"Long"},{"name":"getTotalMisses","type":"Long"},{"name":"getTotalShots","type":"Long"},{"name":"madeShots","type":"Long"},{"name":"missedShots","type":"Long"},{"name":"rating","type":"Double"},{"name":"shotPercentage","type":"Double"},{"name":"startTime","type":"Long"},{"name":"totalShots","type":"Long"}],"indexes":[],"links":[]}',
  idName: r'id',
  propertyIds: {
    r'duration': 0,
    r'getSessionDuration': 1,
    r'getSessionRating': 2,
    r'getShotPercentage': 3,
    r'getTotalMakes': 4,
    r'getTotalMisses': 5,
    r'getTotalShots': 6,
    r'madeShots': 7,
    r'missedShots': 8,
    r'rating': 9,
    r'shotPercentage': 10,
    r'startTime': 11,
    r'totalShots': 12
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
  writer.writeDouble(offsets[0], object.duration);
  writer.writeDouble(offsets[1], object.getSessionDuration);
  writer.writeDouble(offsets[2], object.getSessionRating);
  writer.writeDouble(offsets[3], object.getShotPercentage);
  writer.writeLong(offsets[4], object.getTotalMakes);
  writer.writeLong(offsets[5], object.getTotalMisses);
  writer.writeLong(offsets[6], object.getTotalShots);
  writer.writeLong(offsets[7], object.madeShots);
  writer.writeLong(offsets[8], object.missedShots);
  writer.writeDouble(offsets[9], object.rating);
  writer.writeDouble(offsets[10], object.shotPercentage);
  writer.writeDateTime(offsets[11], object.startTime);
  writer.writeLong(offsets[12], object.totalShots);
}

Session _sessionDeserializeNative(IsarCollection<Session> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Session();
  object.duration = reader.readDouble(offsets[0]);
  object.id = id;
  object.madeShots = reader.readLong(offsets[7]);
  object.missedShots = reader.readLong(offsets[8]);
  object.rating = reader.readDouble(offsets[9]);
  object.shotPercentage = reader.readDouble(offsets[10]);
  object.startTime = reader.readDateTime(offsets[11]);
  object.totalShots = reader.readLong(offsets[12]);
  return object;
}

P _sessionDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Illegal propertyIndex');
  }
}

Object _sessionSerializeWeb(
    IsarCollection<Session> collection, Session object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'duration', object.duration);
  IsarNative.jsObjectSet(
      jsObj, r'getSessionDuration', object.getSessionDuration);
  IsarNative.jsObjectSet(jsObj, r'getSessionRating', object.getSessionRating);
  IsarNative.jsObjectSet(jsObj, r'getShotPercentage', object.getShotPercentage);
  IsarNative.jsObjectSet(jsObj, r'getTotalMakes', object.getTotalMakes);
  IsarNative.jsObjectSet(jsObj, r'getTotalMisses', object.getTotalMisses);
  IsarNative.jsObjectSet(jsObj, r'getTotalShots', object.getTotalShots);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'madeShots', object.madeShots);
  IsarNative.jsObjectSet(jsObj, r'missedShots', object.missedShots);
  IsarNative.jsObjectSet(jsObj, r'rating', object.rating);
  IsarNative.jsObjectSet(jsObj, r'shotPercentage', object.shotPercentage);
  IsarNative.jsObjectSet(
      jsObj, r'startTime', object.startTime.toUtc().millisecondsSinceEpoch);
  IsarNative.jsObjectSet(jsObj, r'totalShots', object.totalShots);
  return jsObj;
}

Session _sessionDeserializeWeb(
    IsarCollection<Session> collection, Object jsObj) {
  final object = Session();
  object.duration =
      IsarNative.jsObjectGet(jsObj, r'duration') ?? double.negativeInfinity;
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
  object.totalShots = IsarNative.jsObjectGet(jsObj, r'totalShots') ??
      (double.negativeInfinity as int);
  return object;
}

P _sessionDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'duration':
      return (IsarNative.jsObjectGet(jsObj, r'duration') ??
          double.negativeInfinity) as P;
    case r'getSessionDuration':
      return (IsarNative.jsObjectGet(jsObj, r'getSessionDuration') ??
          double.negativeInfinity) as P;
    case r'getSessionRating':
      return (IsarNative.jsObjectGet(jsObj, r'getSessionRating') ??
          double.negativeInfinity) as P;
    case r'getShotPercentage':
      return (IsarNative.jsObjectGet(jsObj, r'getShotPercentage') ??
          double.negativeInfinity) as P;
    case r'getTotalMakes':
      return (IsarNative.jsObjectGet(jsObj, r'getTotalMakes') ??
          (double.negativeInfinity as int)) as P;
    case r'getTotalMisses':
      return (IsarNative.jsObjectGet(jsObj, r'getTotalMisses') ??
          (double.negativeInfinity as int)) as P;
    case r'getTotalShots':
      return (IsarNative.jsObjectGet(jsObj, r'getTotalShots') ??
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

  QueryBuilder<Session, Session, QAfterFilterCondition>
      getSessionDurationGreaterThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'getSessionDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition>
      getSessionDurationLessThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'getSessionDuration',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition>
      getSessionDurationBetween(double lower, double upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'getSessionDuration',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition>
      getSessionRatingGreaterThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'getSessionRating',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition>
      getSessionRatingLessThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'getSessionRating',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> getSessionRatingBetween(
      double lower, double upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'getSessionRating',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition>
      getShotPercentageGreaterThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'getShotPercentage',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition>
      getShotPercentageLessThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'getShotPercentage',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition>
      getShotPercentageBetween(double lower, double upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'getShotPercentage',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> getTotalMakesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'getTotalMakes',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition>
      getTotalMakesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'getTotalMakes',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> getTotalMakesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'getTotalMakes',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> getTotalMakesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'getTotalMakes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> getTotalMissesEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'getTotalMisses',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition>
      getTotalMissesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'getTotalMisses',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> getTotalMissesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'getTotalMisses',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> getTotalMissesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'getTotalMisses',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> getTotalShotsEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'getTotalShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition>
      getTotalShotsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'getTotalShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> getTotalShotsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'getTotalShots',
        value: value,
      ));
    });
  }

  QueryBuilder<Session, Session, QAfterFilterCondition> getTotalShotsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'getTotalShots',
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

  QueryBuilder<Session, Session, QAfterSortBy> sortByGetSessionDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getSessionDuration', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByGetSessionDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getSessionDuration', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByGetSessionRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getSessionRating', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByGetSessionRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getSessionRating', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByGetShotPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getShotPercentage', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByGetShotPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getShotPercentage', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByGetTotalMakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getTotalMakes', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByGetTotalMakesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getTotalMakes', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByGetTotalMisses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getTotalMisses', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByGetTotalMissesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getTotalMisses', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByGetTotalShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getTotalShots', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> sortByGetTotalShotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getTotalShots', Sort.desc);
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

  QueryBuilder<Session, Session, QAfterSortBy> thenByGetSessionDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getSessionDuration', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByGetSessionDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getSessionDuration', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByGetSessionRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getSessionRating', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByGetSessionRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getSessionRating', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByGetShotPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getShotPercentage', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByGetShotPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getShotPercentage', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByGetTotalMakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getTotalMakes', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByGetTotalMakesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getTotalMakes', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByGetTotalMisses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getTotalMisses', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByGetTotalMissesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getTotalMisses', Sort.desc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByGetTotalShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getTotalShots', Sort.asc);
    });
  }

  QueryBuilder<Session, Session, QAfterSortBy> thenByGetTotalShotsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'getTotalShots', Sort.desc);
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
  QueryBuilder<Session, Session, QDistinct> distinctByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByGetSessionDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'getSessionDuration');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByGetSessionRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'getSessionRating');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByGetShotPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'getShotPercentage');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByGetTotalMakes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'getTotalMakes');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByGetTotalMisses() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'getTotalMisses');
    });
  }

  QueryBuilder<Session, Session, QDistinct> distinctByGetTotalShots() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'getTotalShots');
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

  QueryBuilder<Session, double, QQueryOperations> durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<Session, double, QQueryOperations> getSessionDurationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'getSessionDuration');
    });
  }

  QueryBuilder<Session, double, QQueryOperations> getSessionRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'getSessionRating');
    });
  }

  QueryBuilder<Session, double, QQueryOperations> getShotPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'getShotPercentage');
    });
  }

  QueryBuilder<Session, int, QQueryOperations> getTotalMakesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'getTotalMakes');
    });
  }

  QueryBuilder<Session, int, QQueryOperations> getTotalMissesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'getTotalMisses');
    });
  }

  QueryBuilder<Session, int, QQueryOperations> getTotalShotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'getTotalShots');
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

  QueryBuilder<Session, int, QQueryOperations> totalShotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalShots');
    });
  }
}
