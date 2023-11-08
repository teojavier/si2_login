import 'dart:convert';

List<Vehicle> vehicleFromMap(String str) => List<Vehicle>.from(json.decode(str).map((x) => Vehicle.fromMap(x)));

String vehicleToMap(List<Vehicle> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Vehicle {
    int id;
    String brand;
    String model;
    int year;
    String licencePlate;
    int clientId;
    String createdAt;
    String updatedAt;

    Vehicle({
        required this.id,
        required this.brand,
        required this.model,
        required this.year,
        required this.licencePlate,
        required this.clientId,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Vehicle.fromMap(Map<String, dynamic> json) => Vehicle(
        id: json["id"],
        brand: json["brand"],
        model: json["model"],
        year: json["year"],
        licencePlate: json["licence_plate"],
        clientId: json["client_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "brand": brand,
        "model": model,
        "year": year,
        "licence_plate": licencePlate,
        "client_id": clientId,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
