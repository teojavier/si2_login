import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loginsi2v2/models/models.dart';
import 'package:loginsi2v2/services/server.dart';
import 'package:http/http.dart' as http;

class AssistanceRequestService extends ChangeNotifier {
  late List<AssistanceRequest> solicitudes = [];
  bool isLoading = true;
  Servidor servidor = Servidor();

  Future<List<AssistanceRequest>> loadSolicitudes(String userId) async {
    isLoading = true;

    solicitudes = [];

    final resp = await http.get(Uri.parse(
        '${servidor.baseUrl}/assistance_request/getAll/client_id=$userId'));

    final List<dynamic> solicitudesMap = json.decode(resp.body);

    solicitudesMap.forEach((element) {
      final map = AssistanceRequest.fromMap(element);
      solicitudes.add(map);
    });

    isLoading = false;
    notifyListeners();
    return solicitudes;
  }
}
