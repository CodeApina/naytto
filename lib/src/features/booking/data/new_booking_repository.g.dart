// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_booking_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$newBookingRepositoryHash() =>
    r'207d5166b456f894436746cc0729819d893c6746';

/// See also [newBookingRepository].
@ProviderFor(newBookingRepository)
final newBookingRepositoryProvider = Provider<NewBookingRepository>.internal(
  newBookingRepository,
  name: r'newBookingRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$newBookingRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NewBookingRepositoryRef = ProviderRef<NewBookingRepository>;
String _$bookingsStreamHash() => r'47886a2565c06ad416172cff7aecfa4518ec2e6f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [bookingsStream].
@ProviderFor(bookingsStream)
const bookingsStreamProvider = BookingsStreamFamily();

/// See also [bookingsStream].
class BookingsStreamFamily extends Family<AsyncValue<List<Booking>>> {
  /// See also [bookingsStream].
  const BookingsStreamFamily();

  /// See also [bookingsStream].
  BookingsStreamProvider call(
    String amenityID,
    DateTime date,
  ) {
    return BookingsStreamProvider(
      amenityID,
      date,
    );
  }

  @override
  BookingsStreamProvider getProviderOverride(
    covariant BookingsStreamProvider provider,
  ) {
    return call(
      provider.amenityID,
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bookingsStreamProvider';
}

/// See also [bookingsStream].
class BookingsStreamProvider extends AutoDisposeStreamProvider<List<Booking>> {
  /// See also [bookingsStream].
  BookingsStreamProvider(
    String amenityID,
    DateTime date,
  ) : this._internal(
          (ref) => bookingsStream(
            ref as BookingsStreamRef,
            amenityID,
            date,
          ),
          from: bookingsStreamProvider,
          name: r'bookingsStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookingsStreamHash,
          dependencies: BookingsStreamFamily._dependencies,
          allTransitiveDependencies:
              BookingsStreamFamily._allTransitiveDependencies,
          amenityID: amenityID,
          date: date,
        );

  BookingsStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.amenityID,
    required this.date,
  }) : super.internal();

  final String amenityID;
  final DateTime date;

  @override
  Override overrideWith(
    Stream<List<Booking>> Function(BookingsStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookingsStreamProvider._internal(
        (ref) => create(ref as BookingsStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        amenityID: amenityID,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Booking>> createElement() {
    return _BookingsStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingsStreamProvider &&
        other.amenityID == amenityID &&
        other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, amenityID.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BookingsStreamRef on AutoDisposeStreamProviderRef<List<Booking>> {
  /// The parameter `amenityID` of this provider.
  String get amenityID;

  /// The parameter `date` of this provider.
  DateTime get date;
}

class _BookingsStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Booking>>
    with BookingsStreamRef {
  _BookingsStreamProviderElement(super.provider);

  @override
  String get amenityID => (origin as BookingsStreamProvider).amenityID;
  @override
  DateTime get date => (origin as BookingsStreamProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
