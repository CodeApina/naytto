// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amenities_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$amenitiesRepositoryHash() =>
    r'ef1daa97b02386193d904e1c4fa5c2ace6c8651c';

/// See also [amenitiesRepository].
@ProviderFor(amenitiesRepository)
final amenitiesRepositoryProvider = Provider<AmenitiesRepository>.internal(
  amenitiesRepository,
  name: r'amenitiesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$amenitiesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AmenitiesRepositoryRef = ProviderRef<AmenitiesRepository>;
String _$amenitiesListHash() => r'c7642a8db285d0bbc993f64030effac9e98ed539';

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

/// See also [amenitiesList].
@ProviderFor(amenitiesList)
const amenitiesListProvider = AmenitiesListFamily();

/// See also [amenitiesList].
class AmenitiesListFamily extends Family<AsyncValue<List<Amenity>>> {
  /// See also [amenitiesList].
  const AmenitiesListFamily();

  /// See also [amenitiesList].
  AmenitiesListProvider call(
    String collectionName,
  ) {
    return AmenitiesListProvider(
      collectionName,
    );
  }

  @override
  AmenitiesListProvider getProviderOverride(
    covariant AmenitiesListProvider provider,
  ) {
    return call(
      provider.collectionName,
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
  String? get name => r'amenitiesListProvider';
}

/// See also [amenitiesList].
class AmenitiesListProvider extends AutoDisposeFutureProvider<List<Amenity>> {
  /// See also [amenitiesList].
  AmenitiesListProvider(
    String collectionName,
  ) : this._internal(
          (ref) => amenitiesList(
            ref as AmenitiesListRef,
            collectionName,
          ),
          from: amenitiesListProvider,
          name: r'amenitiesListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$amenitiesListHash,
          dependencies: AmenitiesListFamily._dependencies,
          allTransitiveDependencies:
              AmenitiesListFamily._allTransitiveDependencies,
          collectionName: collectionName,
        );

  AmenitiesListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.collectionName,
  }) : super.internal();

  final String collectionName;

  @override
  Override overrideWith(
    FutureOr<List<Amenity>> Function(AmenitiesListRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AmenitiesListProvider._internal(
        (ref) => create(ref as AmenitiesListRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        collectionName: collectionName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Amenity>> createElement() {
    return _AmenitiesListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AmenitiesListProvider &&
        other.collectionName == collectionName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, collectionName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AmenitiesListRef on AutoDisposeFutureProviderRef<List<Amenity>> {
  /// The parameter `collectionName` of this provider.
  String get collectionName;
}

class _AmenitiesListProviderElement
    extends AutoDisposeFutureProviderElement<List<Amenity>>
    with AmenitiesListRef {
  _AmenitiesListProviderElement(super.provider);

  @override
  String get collectionName => (origin as AmenitiesListProvider).collectionName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
