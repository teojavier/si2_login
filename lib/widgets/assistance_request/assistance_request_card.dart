import 'package:flutter/material.dart';
import 'package:loginsi2v2/models/models.dart';

class AssistanceRequestCard extends StatelessWidget {
  final AssistanceRequest solicitud;
  const AssistanceRequestCard({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20), //es en general en el view
      child: Container(
        margin:
            const EdgeInsets.only(top: 10, bottom: 20), //es solo para el card
        width: double.infinity,
        height: 160,
        decoration: _carBorders(),
        child: Column(
          children: [
            _AssistanceRequestDetail(solicitud: solicitud),
          ],
        ),
      ),
    );
  }

  BoxDecoration _carBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 5), blurRadius: 10)
          ]);
}

class _AssistanceRequestDetail extends StatelessWidget {
  final AssistanceRequest solicitud;
  const _AssistanceRequestDetail({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 150,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cliente:  ${solicitud.clientUserName}',
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Taller:  ${solicitud.workshopUserName}',
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Vehiculo:  ${solicitud.vehicleBrand}',
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Problema:  ${solicitud.problemDescription}',
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Fecha:  ${solicitud.assistanceRequestDate}',
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Estado:  ${solicitud.status}',
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
      color: Color.fromARGB(255, 36, 87, 252),
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25)));
}
