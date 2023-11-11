import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:loginsi2v2/models/assistance_request.dart';
import 'package:loginsi2v2/services/server.dart';

class ShowAssistanceScreen extends StatefulWidget {
  final AssistanceRequest solicitud;
  const ShowAssistanceScreen({super.key, required this.solicitud});

  @override
  State<ShowAssistanceScreen> createState() =>
      _ShowAssistanceScreenState(solicitud: solicitud);
}

class _ShowAssistanceScreenState extends State<ShowAssistanceScreen> {
  final AssistanceRequest solicitud;
  _ShowAssistanceScreenState({Key? key, required this.solicitud});

  Servidor servidor = Servidor();
  TextEditingController clientController = TextEditingController();
  TextEditingController workshopController = TextEditingController();
  TextEditingController techniciansController = TextEditingController();
  TextEditingController vehicleController = TextEditingController();
  TextEditingController problemDescriptionController = TextEditingController();
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    uploadData();
    super.initState();
    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void uploadData() {
    clientController.text = solicitud.clientUserName;
    workshopController.text = solicitud.workshopUserName;
    techniciansController.text = solicitud.technicians;
    vehicleController.text =
        '${solicitud.vehicleBrand} - ${solicitud.vehicleModel} -${solicitud.vehicleYear}';
    problemDescriptionController.text = solicitud.problemDescription;
  }

  Future setAudio() async {
    // repite si audio termina
    audioPlayer.setReleaseMode(ReleaseMode.loop);

    // cargar audio desde una url
    String url = 'https://s27.aconvert.com/convert/p3r68-cdx67/df1wm-63z70.mp3';
    await audioPlayer.setSourceUrl(url);
  }

  String formatTime(Duration duration) {
    String twoDigits(int m) => m.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Asistencia'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: clientController,
              decoration: const InputDecoration(labelText: 'Cliente'),
            ),
            TextField(
              controller: workshopController,
              decoration: const InputDecoration(labelText: 'Taller'),
            ),
            TextField(
              controller: techniciansController,
              decoration: const InputDecoration(labelText: 'Tecnico'),
            ),
            TextField(
              controller: vehicleController,
              decoration: const InputDecoration(labelText: 'Vehiculo'),
            ),
            TextField(
              controller: problemDescriptionController,
              decoration:
                  const InputDecoration(labelText: 'Descripcion del Problema'),
            ),
            const SizedBox(height: 16.0),
            Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);
                  await audioPlayer.resume();
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration)),
                ],
              ),
            ),
            CircleAvatar(
              radius: 35,
              child: IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 50,
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    await audioPlayer.resume();
                  }
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Image.network(
              '${servidor.baseDocuments}${solicitud.photos}',
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            )
          ],
        ),
      ),
    );
  }
}
