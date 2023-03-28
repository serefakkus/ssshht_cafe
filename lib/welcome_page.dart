import 'package:flutter/material.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

TextStyle _style = TextStyle(fontSize: _width / 20);

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return Scaffold(
      body: ListView(
        children: [
          const SsshhtLogo(),
          Row(
            children: const [
              AdminButon(),
              PersonelButon(),
            ],
          ),
        ],
      ),
    );
  }
}

class SsshhtLogo extends StatelessWidget {
  const SsshhtLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          (_width / 5), (_height / 20), (_width / 5), (_height / 6)),
      alignment: Alignment.topCenter,
      width: _width / 2.5,
      height: _height / 4,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/logo.png"),
        fit: BoxFit.contain,
      )),
    );
  }
}

class AdminButon extends StatelessWidget {
  const AdminButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: _width / 15,
        bottom: _height / 50,
        top: _height / 5,
      ),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            elevation: 10,
            fixedSize: Size(_width * 0.4, _width * 0.4),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.local_cafe,
              size: _width / 5,
              color: Colors.grey,
            ),
            Text(
              'YÖNETİCİ',
              style: _style,
            ),
          ],
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/CafeGirisPage');
        },
      ),
    );
  }
}

class PersonelButon extends StatelessWidget {
  const PersonelButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: _width / 15,
        bottom: _height / 50,
        top: _height / 5,
      ),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            elevation: 10,
            fixedSize: Size(_width * 0.4, _width * 0.4),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.person,
              size: _width / 5,
              color: Colors.grey,
            ),
            Text(
              'PERSONEL',
              style: _style,
            ),
          ],
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/PersonelGirisPage');
        },
      ),
    );
  }
}
