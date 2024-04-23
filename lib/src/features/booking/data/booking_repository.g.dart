// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingRepositoryHash() => r'ffe6e76d5e0406278c91b0b16b7db5367206d41e';

/// See also [bookingRepository].
@ProviderFor(bookingRepository)
final bookingRepositoryProvider = Provider<NewBookingRepository>.internal(
  bookingRepository,
  name: r'bookingRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookingRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BookingRepositoryRef = ProviderRef<NewBookingRepository>;
String _$bookingsForDateStreamHash() =>
    r'b326b1eb21db2a737791d8848c468d8c028f3ec7';

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

/// See also [bookingsForDateStream].
@ProviderFor(bookingsForDateStream)
const bookingsForDateStreamProvider = BookingsForDateStreamFamily();

/// See also [bookingsForDateStream].
class BookingsForDateStreamFamily extends Family<AsyncValue<List<Booking>>> {
  /// See also [bookingsForDateStream].
  const BookingsForDateStreamFamily();

  /// See also [bookingsForDateStream].
  BookingsForDateStreamProvider call(
    String amenityID,
    DateTime date,
  ) {
    return BookingsForDateStreamProvider(
      amenityID,
      date,
    );
  }

  @override
  BookingsForDateStreamProvider getProviderOverride(
    covariant BookingsForDateStreamProvider provider,
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
  String? get name => r'bookingsForDateStreamProvider';
}

/// See also [bookingsForDateStream].
class BookingsForDateStreamProvider
    extends AutoDisposeStreamProvider<List<Booking>> {
  /// See also [bookingsForDateStream].
  BookingsForDateStreamProvider(
    String amenityID,
    DateTime date,
  ) : this._internal(
          (ref) => bookingsForDateStream(
            ref as BookingsForDateStreamRef,
            amenityID,
            date,
          ),
          from: bookingsForDateStreamProvider,
          name: r'bookingsForDateStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$bookingsForDateStreamHash,
          dependencies: BookingsForDateStreamFamily._dependencies,
          allTransitiveDependencies:
              BookingsForDateStreamFamily._allTransitiveDependencies,
          amenityID: amenityID,
          date: date,
        );

  BookingsForDateStreamProvider._internal(
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
    Stream<List<Booking>> Function(BookingsForDateStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BookingsForDateStreamProvider._internal(
        (ref) => create(ref as BookingsForDateStreamRef),
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
    return _BookingsForDateStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BookingsForDateStreamProvider &&
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

mixin BookingsForDateStreamRef on AutoDisposeStreamProviderRef<List<Booking>> {
  /// The parameter `amenityID` of this provider.
  String get amenityID;

  /// The parameter `date` of this provider.
  DateTime get date;
}

class _BookingsForDateStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Booking>>
    with BookingsForDateStreamRef {
  _BookingsForDateStreamProviderElement(super.provider);

  @override
  String get amenityID => (origin as BookingsForDateStreamProvider).amenityID;
  @override
  DateTime get date => (origin as BookingsForDateStreamProvider).date;
}

String _$allBookingsForUserStreamHash() =>
    r'b642881a4b2678146c35c1a7161b1007cd806283';

/// See also [allBookingsForUserStream].
@ProviderFor(allBookingsForUserStream)
final allBookingsForUserStreamProvider =
    AutoDisposeStreamProvider<List<Booking>>.internal(
  allBookingsForUserStream,
  name: r'allBookingsForUserStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allBookingsForUserStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllBookingsForUserStreamRef
    = AutoDisposeStreamProviderRef<List<Booking>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
