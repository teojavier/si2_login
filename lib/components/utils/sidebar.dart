import 'package:flutter/material.dart';
import 'package:loginsi2v2/screens/login/login_screen.dart';
import 'package:loginsi2v2/screens/login/register_screen.dart';
import 'package:loginsi2v2/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<AuthService>(builder: (context, auth, child) {
        if (!auth.authentificated) {
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.login),
                title: const Text('Iniciar Sessión'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.recycling_sharp),
                title: const Text('Registrar'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterSreen()));
                },
              ),
            ],
          );
        } else {
          return ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(auth.user.name),
                accountEmail: Text(auth.user.email),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      'https://cdn.pixabay.com/photo/2018/11/13/22/01/avatar-3814081_640.png',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/utils/sidebar_fondo.jpg'),
                        fit: BoxFit.cover)),
              ),
              ListTile(
                leading: const Icon(Icons.shop),
                title: const Text('Modulo Compras'),
                onTap: () {
                  print('Precionado iniciar sesion');
                },
              ),
              const Divider(
                thickness: 3,
                indent: 15,
                endIndent: 15,
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('carrar Sessión'),
                onTap: () {
                  Provider.of<AuthService>(context, listen: false).logout();
                },
              ),
            ],
          );
        }
      }),
    );
  }
}
