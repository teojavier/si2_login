import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _PurpleBox(), 
          _HederIcon(), 
          child
          ],
      ),
    );
  }
}

class _HederIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ), // Margen superior del icono
          Center(
            child: SizedBox(
              width: 200,
              child: Image(
                image: AssetImage('assets/utils/splash.png'),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(top: 90, left: 30 ,child: _Bubble()),
          Positioned(top: -40, left: -30 ,child: _Bubble()),
          Positioned(top: -50, right: 20 ,child: _Bubble()),
          Positioned(bottom: -50, left: 10 ,child: _Bubble()),
          Positioned(bottom: -30, right: 90 ,child: _Bubble()),
          Positioned(bottom: 120, right: 30 ,child: _Bubble()),
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() => const BoxDecoration(
    gradient: LinearGradient(colors: [
      Color.fromARGB(255, 0, 90, 163),
      Color.fromARGB(255, 107, 179, 239)
    ])
  );
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.5)
      ),
    );
  }
}
