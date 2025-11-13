library google_maps_flutter;

import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

@immutable
class LatLng {
  final double latitude;
  final double longitude;
  const LatLng(this.latitude, this.longitude);

  mapbox.Position toPosition() => mapbox.Position(longitude, latitude);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLng && runtimeType == other.runtimeType && latitude == other.latitude && longitude == other.longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() => 'LatLng($latitude, $longitude)';
}

@immutable
class LatLngBounds {
  final LatLng southwest;
  final LatLng northeast;
  const LatLngBounds({required this.southwest, required this.northeast});

  mapbox.CoordinateBounds toCoordinateBounds() => mapbox.CoordinateBounds(
        southwest: mapbox.Point(coordinates: southwest.toPosition()),
        northeast: mapbox.Point(coordinates: northeast.toPosition()),
        infiniteBounds: false,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLngBounds && runtimeType == other.runtimeType && southwest == other.southwest && northeast == other.northeast;

  @override
  int get hashCode => Object.hash(southwest, northeast);

  @override
  String toString() => 'LatLngBounds($southwest, $northeast)';
}

@immutable
class CameraPosition {
  final LatLng target;
  final double zoom;
  final double bearing;
  final double tilt;
  const CameraPosition({
    required this.target,
    this.zoom = 0,
    this.bearing = 0,
    this.tilt = 0,
  });
}

@immutable
class CameraTargetBounds {
  final LatLngBounds? bounds;
  const CameraTargetBounds(this.bounds);
  static const CameraTargetBounds unbounded = CameraTargetBounds(null);
}

enum _CameraUpdateType { newCameraPosition, newLatLngBounds }

@immutable
class CameraUpdate {
  final _CameraUpdateType _type;
  final CameraPosition? _cameraPosition;
  final LatLngBounds? _bounds;
  final double? _padding;

  const CameraUpdate._({
    required _CameraUpdateType type,
    CameraPosition? cameraPosition,
    LatLngBounds? bounds,
    double? padding,
  })  : _type = type,
        _cameraPosition = cameraPosition,
        _bounds = bounds,
        _padding = padding;

  static CameraUpdate newCameraPosition(CameraPosition position) =>
      CameraUpdate._(type: _CameraUpdateType.newCameraPosition, cameraPosition: position);

  static CameraUpdate newLatLngBounds(LatLngBounds bounds, double padding) =>
      CameraUpdate._(
        type: _CameraUpdateType.newLatLngBounds,
        bounds: bounds,
        padding: padding,
      );
}

class MarkerId {
  const MarkerId(this.value);
  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarkerId && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class PolylineId {
  const PolylineId(this.value);
  final String value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PolylineId && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

enum _BitmapDescriptorType { asset, bytes, defaultMarker }

class BitmapDescriptor {
  BitmapDescriptor._(this._type, {this._assetName, this._bytes});

  final _BitmapDescriptorType _type;
  final String? _assetName;
  final Uint8List? _bytes;

  static Future<BitmapDescriptor> fromAssetImage(
    ImageConfiguration configuration,
    String assetName,
  ) async {
    return BitmapDescriptor._(
      _BitmapDescriptorType.asset,
      _assetName: assetName,
    );
  }

  static Future<BitmapDescriptor> fromBytes(Uint8List bytes) async {
    return BitmapDescriptor._(
      _BitmapDescriptorType.bytes,
      _bytes: bytes,
    );
  }

  static BitmapDescriptor defaultMarker() =>
      BitmapDescriptor._(_BitmapDescriptorType.defaultMarker);

  String get cacheKey {
    switch (_type) {
      case _BitmapDescriptorType.asset:
        return 'asset|${_assetName ?? ''}';
      case _BitmapDescriptorType.bytes:
        return 'bytes|${_bytes?.hashCode ?? 0}';
      case _BitmapDescriptorType.defaultMarker:
        return 'marker-default';
    }
  }
}

class InfoWindow {
  final String? title;
  final String? snippet;
  const InfoWindow({this.title, this.snippet});

  static const InfoWindow noText = InfoWindow();
}

class Marker {
  final MarkerId markerId;
  final LatLng position;
  final BitmapDescriptor? icon;
  final Offset? anchor;
  final InfoWindow infoWindow;
  final double rotation;
  final bool draggable;

  const Marker({
    required this.markerId,
    required this.position,
    this.icon,
    this.anchor,
    this.infoWindow = const InfoWindow(),
    this.rotation = 0,
    this.draggable = false,
  });

  Marker copyWith({
    LatLng? positionParam,
    BitmapDescriptor? iconParam,
    Offset? anchorParam,
    InfoWindow? infoWindowParam,
    double? rotationParam,
    bool? draggableParam,
  }) {
    return Marker(
      markerId: markerId,
      position: positionParam ?? position,
      icon: iconParam ?? icon,
      anchor: anchorParam ?? anchor,
      infoWindow: infoWindowParam ?? infoWindow,
      rotation: rotationParam ?? rotation,
      draggable: draggableParam ?? draggable,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Marker && markerId == other.markerId);

  @override
  int get hashCode => markerId.hashCode;
}

class Polyline {
  final PolylineId polylineId;
  final List<LatLng> points;
  final Color color;
  final int width;

  const Polyline({
    required this.polylineId,
    required this.points,
    this.color = Colors.blue,
    this.width = 3,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || (other is Polyline && polylineId == other.polylineId);

  @override
  int get hashCode => polylineId.hashCode;
}

class GoogleMapConfig {
  static String? accessToken;
  static String? styleString;
}

typedef MapCreatedCallback = void Function(GoogleMapController controller);

class GoogleMap extends StatefulWidget {
  const GoogleMap({
    super.key,
    required this.initialCameraPosition,
    this.onMapCreated,
    this.markers = const <Marker>{},
    this.polylines = const <Polyline>{},
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = false,
    this.zoomGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.style,
    this.padding = EdgeInsets.zero,
    this.onCameraMove,
    this.onCameraMoveStarted,
    this.onCameraIdle,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
  });

  final CameraPosition initialCameraPosition;
  final MapCreatedCallback? onMapCreated;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final bool myLocationEnabled;
  final bool myLocationButtonEnabled;
  final bool zoomGesturesEnabled;
  final bool zoomControlsEnabled;
  final String? style;
  final EdgeInsets padding;
  final ValueChanged<CameraPosition>? onCameraMove;
  final VoidCallback? onCameraMoveStarted;
  final VoidCallback? onCameraIdle;
  final CameraTargetBounds cameraTargetBounds;

  @override
  State<GoogleMap> createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMap> {
  mapbox.MapboxMap? _mapboxMap;
  mapbox.PointAnnotationManager? _pointManager;
  mapbox.PolylineAnnotationManager? _polylineManager;
  final Map<String, mapbox.PointAnnotation> _pointAnnotations = {};
  final Map<String, mapbox.PolylineAnnotation> _polylineAnnotations = {};
  final Map<String, Uint8List> _iconCache = HashMap();
  EdgeInsets _currentPadding = EdgeInsets.zero;
  LatLngBounds? _visibleRegion;
  bool _cameraMoving = false;

  @override
  void initState() {
    super.initState();
    _currentPadding = widget.padding;
  }

  @override
  Widget build(BuildContext context) {
    final token = GoogleMapConfig.accessToken;
    if (token == null || token.isEmpty) {
      return const SizedBox.shrink();
    }

    final cameraOptions = mapbox.CameraOptions(
      center: widget.initialCameraPosition.target.toPosition(),
      zoom: widget.initialCameraPosition.zoom,
      bearing: widget.initialCameraPosition.bearing,
      pitch: widget.initialCameraPosition.tilt,
      padding: _paddingToInsets(_currentPadding),
    );

    return mapbox.MapWidget(
      resourceOptions: mapbox.ResourceOptions(accessToken: token),
      cameraOptions: cameraOptions,
      styleUri: widget.style ?? GoogleMapConfig.styleString ?? mapbox.MapboxStyles.MAPBOX_STREETS,
      onMapCreated: _handleMapCreated,
      onStyleLoadedListener: (_) => _refreshAnnotations(force: true),
      onCameraChangeListener: _handleCameraChanged,
      onMapIdleListener: (_) => _handleMapIdle(),
    );
  }

  mapbox.MbxEdgeInsets _paddingToInsets(EdgeInsets padding) => mapbox.MbxEdgeInsets(
        top: padding.top,
        left: padding.left,
        bottom: padding.bottom,
        right: padding.right,
      );

  Future<void> _handleMapCreated(mapbox.MapboxMap map) async {
    _mapboxMap = map;
    await _configureGestures();
    await _configureLocation();
    await _applyCameraBounds(widget.cameraTargetBounds.bounds);
    await _applyPadding();
    await _resetAnnotationManagers();
    await _refreshAnnotations(force: true);
    await _updateVisibleRegion();
    widget.onMapCreated?.call(GoogleMapController._(map, this));
  }

  @override
  void didUpdateWidget(covariant GoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_mapboxMap == null) return;
    if (oldWidget.padding != widget.padding) {
      _currentPadding = widget.padding;
      unawaited(_applyPadding());
    }
    if (oldWidget.zoomGesturesEnabled != widget.zoomGesturesEnabled) {
      unawaited(_configureGestures());
    }
    if (oldWidget.myLocationEnabled != widget.myLocationEnabled) {
      unawaited(_configureLocation());
    }
    if (oldWidget.cameraTargetBounds.bounds != widget.cameraTargetBounds.bounds) {
      unawaited(_applyCameraBounds(widget.cameraTargetBounds.bounds));
    }
    if (oldWidget.style != widget.style) {
      final uri = widget.style ?? GoogleMapConfig.styleString;
      if (uri != null) {
        unawaited(_mapboxMap!.loadStyleURI(uri));
      }
    }
    if (!_setEquals(oldWidget.markers, widget.markers) ||
        !_setEquals(oldWidget.polylines, widget.polylines)) {
      unawaited(_refreshAnnotations());
    }
  }

  bool _setEquals<T>(Set<T> a, Set<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (final item in a) {
      if (!b.contains(item)) return false;
    }
    return true;
  }

  Future<void> _configureGestures() async {
    if (_mapboxMap == null) return;
    await _mapboxMap!.gestures.updateSettings(
      mapbox.GesturesSettings(
        pinchToZoomEnabled: widget.zoomGesturesEnabled,
        rotateEnabled: widget.zoomGesturesEnabled,
        scrollEnabled: true,
        simultaneousRotateAndPinchToZoomEnabled: widget.zoomGesturesEnabled,
        quickZoomEnabled: widget.zoomGesturesEnabled,
        doubleTapToZoomInEnabled: widget.zoomGesturesEnabled,
        doubleTouchToZoomOutEnabled: widget.zoomGesturesEnabled,
        pinchPanEnabled: true,
      ),
    );
  }

  Future<void> _configureLocation() async {
    if (_mapboxMap == null) return;
    await _mapboxMap!.location.updateSettings(
      mapbox.LocationComponentSettings(
        enabled: widget.myLocationEnabled,
        pulsingEnabled: widget.myLocationEnabled,
        puckBearingEnabled: widget.myLocationEnabled,
      ),
    );
  }

  Future<void> _applyCameraBounds(LatLngBounds? bounds) async {
    if (_mapboxMap == null) return;
    final options = bounds == null
        ? mapbox.CameraBoundsOptions(bounds: null)
        : mapbox.CameraBoundsOptions(bounds: bounds.toCoordinateBounds());
    await _mapboxMap!.setBounds(options);
  }

  Future<void> _applyPadding() async {
    if (_mapboxMap == null) return;
    await _mapboxMap!.setCamera(
      mapbox.CameraOptions(padding: _paddingToInsets(_currentPadding)),
    );
  }

  Future<void> _resetAnnotationManagers() async {
    if (_mapboxMap == null) return;
    _pointManager = await _mapboxMap!.annotations.createPointAnnotationManager();
    _polylineManager =
        await _mapboxMap!.annotations.createPolylineAnnotationManager();
    _pointAnnotations.clear();
    _polylineAnnotations.clear();
  }

  Future<void> _refreshAnnotations({bool force = false}) async {
    if (_mapboxMap == null) return;
    if (_pointManager == null || _polylineManager == null || force) {
      await _resetAnnotationManagers();
    }
    await _syncMarkers();
    await _syncPolylines();
  }

  Future<void> _syncMarkers() async {
    if (_pointManager == null) return;
    await _pointManager!.deleteAll();
    _pointAnnotations.clear();
    for (final marker in widget.markers) {
      final image = await _resolveIcon(marker.icon);
      final annotation = await _pointManager!.create(
        mapbox.PointAnnotationOptions(
          geometry: mapbox.Point(coordinates: marker.position.toPosition()),
          image: image,
          iconRotate: marker.rotation,
          textField: marker.infoWindow.title,
          textOffset: marker.infoWindow.title != null ? const [0.0, 1.0] : null,
          draggable: marker.draggable,
        ),
      );
      _pointAnnotations[marker.markerId.value] = annotation;
    }
  }

  Future<void> _syncPolylines() async {
    if (_polylineManager == null) return;
    await _polylineManager!.deleteAll();
    _polylineAnnotations.clear();
    for (final polyline in widget.polylines) {
      if (polyline.points.isEmpty) continue;
      final annotation = await _polylineManager!.create(
        mapbox.PolylineAnnotationOptions(
          geometry: mapbox.LineString.fromPoints(
            points: polyline.points
                .map((p) => mapbox.Point(coordinates: p.toPosition()))
                .toList(),
          ),
          lineColor: polyline.color.value,
          lineWidth: polyline.width.toDouble(),
        ),
      );
      _polylineAnnotations[polyline.polylineId.value] = annotation;
    }
  }

  Future<Uint8List> _resolveIcon(BitmapDescriptor? descriptor) async {
    if (descriptor == null || descriptor._type == _BitmapDescriptorType.defaultMarker) {
      return await _defaultMarkerBytes();
    }
    final key = descriptor.cacheKey;
    if (_iconCache.containsKey(key)) {
      return _iconCache[key]!;
    }
    Uint8List? bytes;
    switch (descriptor._type) {
      case _BitmapDescriptorType.asset:
        if (descriptor._assetName != null) {
          final data = await rootBundle.load(descriptor._assetName!);
          bytes = data.buffer.asUint8List();
        }
        break;
      case _BitmapDescriptorType.bytes:
        bytes = descriptor._bytes;
        break;
      case _BitmapDescriptorType.defaultMarker:
        bytes = await _defaultMarkerBytes();
        break;
    }
    bytes ??= await _defaultMarkerBytes();
    _iconCache[key] = bytes;
    return bytes;
  }

  Uint8List? _cachedDefaultMarker;

  Future<Uint8List> _defaultMarkerBytes() async {
    if (_cachedDefaultMarker != null) return _cachedDefaultMarker!;
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color = Colors.red;
    const size = 80.0;
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);
    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    _cachedDefaultMarker = bytes.buffer.asUint8List();
    return _cachedDefaultMarker!;
  }

  Future<void> _handleCameraChanged(mapbox.CameraChangedEventData data) async {
    if (!_cameraMoving) {
      _cameraMoving = true;
      widget.onCameraMoveStarted?.call();
    }
    if (widget.onCameraMove != null) {
      final state = data.cameraState;
      final position = CameraPosition(
        target: LatLng(state.center.coordinates.lat, state.center.coordinates.lng),
        zoom: state.zoom,
        bearing: state.bearing,
        tilt: state.pitch,
      );
      widget.onCameraMove!(position);
    }
    await _updateVisibleRegion();
  }

  Future<void> _handleMapIdle() async {
    if (!_cameraMoving) return;
    _cameraMoving = false;
    widget.onCameraIdle?.call();
  }

  Future<void> _updateVisibleRegion() async {
    if (_mapboxMap == null) return;
    try {
      final bounds = await _mapboxMap!.coordinateBoundsForCamera(
        mapbox.CameraOptions(),
      );
      _visibleRegion = LatLngBounds(
        southwest: LatLng(bounds.southwest.coordinates.lat, bounds.southwest.coordinates.lng),
        northeast: LatLng(bounds.northeast.coordinates.lat, bounds.northeast.coordinates.lng),
      );
    } catch (_) {
      // ignore errors
    }
  }

  LatLngBounds? get visibleRegion => _visibleRegion;

  Future<void> animateCamera(CameraUpdate update) => _applyCameraUpdate(update, true);

  Future<void> moveCamera(CameraUpdate update) => _applyCameraUpdate(update, false);

  Future<void> _applyCameraUpdate(CameraUpdate update, bool animated) async {
    if (_mapboxMap == null) return;
    switch (update._type) {
      case _CameraUpdateType.newCameraPosition:
        final camera = mapbox.CameraOptions(
          center: update._cameraPosition!.target.toPosition(),
          zoom: update._cameraPosition!.zoom,
          bearing: update._cameraPosition!.bearing,
          pitch: update._cameraPosition!.tilt,
        );
        if (animated) {
          await _mapboxMap!.easeTo(camera, mapbox.MapAnimationOptions(duration: 500));
        } else {
          await _mapboxMap!.setCamera(camera);
        }
        break;
      case _CameraUpdateType.newLatLngBounds:
        final bounds = update._bounds!;
        final padding = update._padding ?? 0;
        final camera = await _mapboxMap!.cameraForCoordinateBounds(
          bounds.toCoordinateBounds(),
          _paddingToInsets(EdgeInsets.all(padding)),
          null,
          null,
          null,
        );
        if (animated) {
          await _mapboxMap!.easeTo(camera, mapbox.MapAnimationOptions(duration: 500));
        } else {
          await _mapboxMap!.setCamera(camera);
        }
        break;
    }
    await _updateVisibleRegion();
  }
}

class GoogleMapController {
  GoogleMapController._(this._mapboxMap, this._state);

  final mapbox.MapboxMap _mapboxMap;
  final _GoogleMapState _state;

  Future<void> animateCamera(CameraUpdate update) => _state.animateCamera(update);

  Future<void> moveCamera(CameraUpdate update) => _state.moveCamera(update);

  Future<LatLngBounds?> getVisibleRegion() async {
    await _state._updateVisibleRegion();
    return _state.visibleRegion;
  }

  Future<void> setMapStyle(String? style) async {
    if (style == null || style.isEmpty) return;
    await _mapboxMap.loadStyleURI(style);
  }

  Future<void> setPadding(double left, double top, double right, double bottom) async {
    _state._currentPadding = EdgeInsets.fromLTRB(left, top, right, bottom);
    await _state._applyPadding();
  }
}


