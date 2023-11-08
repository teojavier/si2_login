import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loginsi2v2/models/models.dart';
import 'package:loginsi2v2/services/server.dart';

class VehicleService extends ChangeNotifier {
  late List<Vehicle> vehiculos = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  // VehicleService(String userId) {
  //   loadVehiculos(userId);
  // }

  Future<List<Vehicle>> loadVehiculos(String userId) async {
    isLoading = true;
    
    vehiculos = [];

    final resp = await http.get(Uri.parse(
        '${servidor.baseUrl}/assistance_request/getVehicles/client_id=$userId'));

    final List<dynamic> vehiculosMap = json.decode(resp.body);

    vehiculosMap.forEach((element) {
      final map = Vehicle.fromMap(element);
      vehiculos.add(map);
    });

    isLoading = false;
    notifyListeners();
    return vehiculos;
  }
}
