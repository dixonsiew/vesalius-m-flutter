class WayFinding {

  int floorId;
  String floorCode;
  String floorName;
  String? floorImageRaw;

  WayFinding({
    required this.floorId,
    required this.floorCode,
    required this.floorName,
    required this.floorImageRaw,
  });

  factory WayFinding.fromJson(Map<String, dynamic> json) {
    return WayFinding(
      floorId: json['floorId'],
      floorCode: json['floorCode'],
      floorName: json['floorName'],
      floorImageRaw: json['floorImageRaw'],
    );
  }
}

class LocationType {

  int locationTypeId;
  String locationTypeCode;
  String locationTypeName;

  LocationType({
    required this.locationTypeId,
    required this.locationTypeCode,
    required this.locationTypeName,
  });

  factory LocationType.fromJson(Map<String, dynamic> json) {
    return LocationType(
      locationTypeId: json['locationTypeId'],
      locationTypeCode: json['locationTypeCode'],
      locationTypeName: json['locationTypeName'],
    );
  }
}

class Location {

  int locationId;
  String locationFloorCode;
  String locationTypeCode;
  String locationCode;
  String locationName;
  String locationBuilding;

  Location({
    required this.locationId,
    required this.locationFloorCode,
    required this.locationTypeCode,
    required this.locationCode,
    required this.locationName,
    required this.locationBuilding,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['locationId'],
      locationFloorCode: json['locationFloorCode'],
      locationTypeCode: json['locationTypeCode'],
      locationCode: json['locationCode'],
      locationName: json['locationName'],
      locationBuilding: json['locationBuilding'],
    );
  }
}

class Route {

  int routeId;
  int routeFromLocationId;
  int routeToLocationId;
  String? routeFromImageRaw;
  String? routeToImageRaw;

  Route({
    required this.routeId,
    required this.routeFromLocationId,
    required this.routeToLocationId,
    required this.routeFromImageRaw,
    required this.routeToImageRaw,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      routeId: json['routeId'],
      routeFromLocationId: json['routeFromLocationId'],
      routeToLocationId: json['routeToLocationId'],
      routeFromImageRaw: json['routeFromImageRaw'],
      routeToImageRaw: json['routeToImageRaw'],
    );
  }
}