import 'package:flutter/material.dart';
import 'package:loginsi2v2/providers/providers.dart';
import 'package:loginsi2v2/services/auth/auth_service.dart';
import 'package:loginsi2v2/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterSreen extends StatelessWidget {
  const RegisterSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Regístrate'),
        ),
        body: AuthBackground(
            child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Regístrate',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                        create: (_) => registerformprovider(),
                        child: _RegisterForm())
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Text('Bienvenido a nuestra App movil',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
            ],
          ),
        )));
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final registerForm = Provider.of<registerformprovider>(context);

    return Form(
      key: registerForm.formkey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            onChanged: (value) => registerForm.name = value,
            decoration: const InputDecoration(
              hintText: 'Nombre',
            ),
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => registerForm.email = value,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.text,
            onChanged: (value) => registerForm.type = value,
            decoration: const InputDecoration(
              hintText: 'Tipo',
            ),
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            onChanged: (value) => registerForm.password = value,
            decoration: const InputDecoration(
              hintText: 'Contraseña',
            ),
          ),
          const SizedBox(height: 30),
          MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.blue,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  registerForm.isLoading ? 'Espere' : 'Ingresar',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              onPressed: registerForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      if (!registerForm.isValidForm()) return;
                      registerForm.isLoading = true;
                      // await Future.delayed(const Duration(seconds: 2));

                      // print(registerForm.name + " " + registerForm.email + " " + registerForm.type + " " + registerForm.password);

                      final authService =
                          Provider.of<AuthService>(context, listen: false);

                      String respuesta = await authService.register(
                          registerForm.name,
                          registerForm.email,
                          registerForm.type,
                          registerForm.password);

                      if (respuesta == 'correcto') {
                        registerForm.isLoading = false;
                        Navigator.pop(context);
                      }
                    })
        ],
      ),
    );
  }
}

class _DialogoAlerta extends StatelessWidget {
  final String mensaje;

  const _DialogoAlerta({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Error'),
      content: Text(mensaje),
    );
  }
}
