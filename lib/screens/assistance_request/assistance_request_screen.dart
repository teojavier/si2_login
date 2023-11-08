import 'package:flutter/material.dart';
import 'package:loginsi2v2/components/componets.dart';
import 'package:loginsi2v2/models/models.dart';
import 'package:loginsi2v2/screens/screens.dart';
import 'package:loginsi2v2/services/api/assistance_request_service.dart';
import 'package:loginsi2v2/services/auth/auth_service.dart';
import 'package:loginsi2v2/widgets/assistance_request/assistance_request_card.dart';
import 'package:provider/provider.dart';

class AssistanceRequestScreen extends StatefulWidget {
  const AssistanceRequestScreen({super.key});

  @override
  State<AssistanceRequestScreen> createState() =>
      _AssistanceRequestScreenState();
}

class _AssistanceRequestScreenState extends State<AssistanceRequestScreen> {
  late String user_id;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final solicitudService = context.read<AssistanceRequestService>();
    final authService = context.read<AuthService>();
    user_id = authService.user.id.toString();

    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        title: const Text('Solicitudes de Servicio'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateAssistanceScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text('Crear una Solicitud'),
          ),
          Expanded(
              child: FutureBuilder<List<AssistanceRequest>>(
            future: solicitudService.loadSolicitudes(user_id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: solicitudService.solicitudes.length,
                  itemBuilder: (BuildContext context, int index) =>
                      AssistanceRequestCard(
                    solicitud: solicitudService.solicitudes[index],
                  ),
                );
              }
            },
          ))
        ],
      ),
    );
  }
}
