import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginsi2v2/models/models.dart';
import 'package:loginsi2v2/screens/assistance_request/assistance_request_screen.dart';
import 'package:loginsi2v2/services/api/vehicle_service.dart';
import 'package:loginsi2v2/services/auth/auth_service.dart';
import 'package:loginsi2v2/services/server.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

class CreateAssistanceScreen extends StatefulWidget {
  const CreateAssistanceScreen({super.key});

  @override
  State<CreateAssistanceScreen> createState() => _CreateAssistanceScreenState();
}

class _CreateAssistanceScreenState extends State<CreateAssistanceScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController clientIdController = TextEditingController();
  TextEditingController latitudController = TextEditingController();
  TextEditingController longitudController = TextEditingController();
  File? _image;
  String audioFilePath = '';
  late AudioPlayer audioPlayer;
  late Record audioRecord;

  bool isRecording = false;
  bool isLoading = true;
  late String user_id;
  late Position position;
  Servidor servidor = Servidor();

  late List<Vehicle> vehiculos = [];
  int selectedVehicleId = 1;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    final authService = context.read<AuthService>();
    user_id = authService.user.id.toString();
    getCurrentLocation();
    final vehicleService = Provider.of<VehicleService>(context, listen: false);
    vehicleService.loadVehiculos(user_id).then((loadedVehiculos) {
      setState(() {
        vehiculos = loadedVehiculos;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    audioRecord.dispose();
    super.dispose();
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print('ERROR EMPEZAR A GRABAR : $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioFilePath = path!;
      });
    } catch (e) {
      print('ERROR DETENER GRABAR : $e');
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioFilePath!);
      await audioPlayer.play(urlSource);
    } catch (e) {
      print('ERROR REPRODUCIR : $e');
    }
  }

  Future<Position> determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    position = await determinePosition();
    latitudController.text = position.latitude.toString();
    longitudController.text = position.longitude.toString();
    clientIdController.text = user_id;
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final uri = Uri.parse(
          '${servidor.baseUrl}/assistance_request/clientRequestAssistance');
      final request = http.MultipartRequest('POST', uri);

      request.fields['user_id'] = clientIdController.text;
      // request.fields['workshop_id'] = workshopIdController.text;
      request.fields['vehicle_id'] = selectedVehicleId.toString();
      // request.fields['problem_description'] = problemDescriptionController.text;
      request.fields['latitud'] = latitudController.text;
      request.fields['longitud'] = longitudController.text;

      if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'photos',
          _image!.path,
        ));
      }

      if (audioFilePath != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'voice_note',
          audioFilePath,
        ));
      }

      final response = await request.send();
      if (response.statusCode == 201) {
        // Asistencia creada con éxito
        // Puedes mostrar un mensaje de éxito o redirigir a otra pantalla
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AssistanceRequestScreen()));
      } else {
        // Manejar errores
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hubo un error al crear la asistencia'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Asistencia'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: clientIdController,
                      decoration: const InputDecoration(labelText: 'Client ID'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingresa el ID del cliente.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: latitudController,
                      decoration: const InputDecoration(labelText: 'Latitud'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingresa la Latitud.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: longitudController,
                      decoration: const InputDecoration(labelText: 'Longitud'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, ingresa la Longitud.';
                        }
                        return null;
                      },
                    ),
                    DropdownButton<int>(
                      value: selectedVehicleId,
                      items: vehiculos.map((Vehicle vehicle) {
                        return DropdownMenuItem<int>(
                          value: vehicle.id,
                          child: Text('${vehicle.brand} ${vehicle.model}'),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedVehicleId = newValue ?? 1;
                        });
                        print(selectedVehicleId);
                      },
                    ),
                    ElevatedButton(
                      onPressed: _getImage,
                      child: const Text('Seleccionar Imagen 2'),
                    ),
                    if (isRecording) const Text('Grabación en proceso'),
                    ElevatedButton(
                      onPressed: isRecording ? _stopRecording : _startRecording,
                      child: isRecording
                          ? const Text('Detener Grabación de Audio')
                          : const Text('Iniciar Grabación de Audio'),
                    ),
                    const SizedBox(height: 16.0),
                    if (!isRecording && audioFilePath != null)
                      ElevatedButton(
                        onPressed: playRecording,
                        child: const Text('Reproducir Audio'),
                      ),
                    const SizedBox(height: 16.0),
                    _image != null
                        ? Image.file(_image!)
                        : const Text('No se ha seleccionado ninguna imagen'),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Enviar Asistencia'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
