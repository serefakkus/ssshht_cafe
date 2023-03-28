import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ssshht_cafe/welcome_page.dart';

import 'first_page.dart';
import 'admin/pages/login/giris_page.dart';
import 'admin/pages/login/kod_giris_page.dart';
import 'admin/pages/login/login_new_pass_page.dart';
import 'admin/pages/login/ref_token_page.dart';
import 'admin/pages/other/ayar_page.dart';
import 'admin/pages/other/hesap_page.dart';
import 'admin/pages/other/home_page.dart';
import 'admin/pages/other/kasa_page.dart';
import 'admin/pages/other/kategori_detay_page.dart';
import 'admin/pages/other/masa_detay_page.dart';
import 'admin/pages/other/masa_page.dart';
import 'admin/pages/other/menu_detay_page.dart';
import 'admin/pages/other/menu_page.dart';
import 'admin/pages/other/new_personel_page.dart';
import 'admin/pages/other/odeme_page.dart';
import 'admin/pages/other/pdf_menu_page.dart';
import 'admin/pages/other/personel_detay_page.dart';
import 'admin/pages/other/personel_page.dart';
import 'admin/pages/other/siparis_detay_page.dart';
import 'admin/pages/other/siparis_page.dart';
import 'admin/pages/other/static_menu_page.dart';
import 'admin/pages/other/urun_detay_page.dart';
import 'admin/pages/other/urun_page.dart';
import 'admin/pages/other/yeni_kategori_page.dart';
import 'admin/pages/other/yeni_urun_page.dart';

import 'personel/pages/login/giris_page.dart';
import 'personel/pages/login/kayit_page.dart';
import 'personel/pages/login/kod_giris_page.dart';
import 'personel/pages/login/login_new_pass_page.dart';
import 'personel/pages/login/ref_token_page.dart';
import 'personel/pages/login/yeni_sifre_page.dart';
import 'personel/pages/other/ayar_page.dart';
import 'personel/pages/other/hesap_page.dart';
import 'personel/pages/other/home_page_pers.dart';
import 'personel/pages/other/masa_cagri_page.dart';
import 'personel/pages/other/masa_detay_page.dart';
import 'personel/pages/other/masa_page.dart';
import 'personel/pages/other/menu_detay_page.dart';
import 'personel/pages/other/menu_page.dart';
import 'personel/pages/other/odeme_page.dart';
import 'personel/pages/other/siparis_detay_page.dart';
import 'personel/pages/other/siparis_page.dart';
import 'personel/pages/other/urun_detay_page.dart';
import 'personel/pages/other/urun_page.dart';
import 'personel/pages/other/yeni_urun_page.dart';

class RouteGenerator {
  static Route<dynamic>? _rotaOlustur(Widget hedef, RouteSettings settings) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageRoute(
          settings: settings, builder: (context) => hedef);
    } else {
      return MaterialPageRoute(settings: settings, builder: (context) => hedef);
    }
  }

  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _rotaOlustur(const FirstPage(), settings);

      case '/WelcomePage':
        return _rotaOlustur(const WelcomePage(), settings);

      case '/CafeGirisPage':
        return _rotaOlustur(const CafeGirisPage(), settings);

      case '/CafeRefTokenPage':
        return _rotaOlustur(const CafeRefTokenPage(), settings);
      case '/CafeHomePage':
        return _rotaOlustur(const CafeHomePage(), settings);

      case '/CafeKodGirisPage':
        return _rotaOlustur(const CafeKodGirisPage(), settings);

      case '/CafeNewPassPage2':
        return _rotaOlustur(const CafeNewPassLoginPage(), settings);

      case '/CafeAyarPage':
        return _rotaOlustur(const CafeAyarPage(), settings);

      case '/CafeMenuPage':
        return _rotaOlustur(const CafeMenuPage(), settings);

      case '/CafeMenuDetayPage':
        return _rotaOlustur(const CafeMenuDetayPage(), settings);

      case '/CafeMasaPage':
        return _rotaOlustur(const CafeMasaPage(), settings);

      case '/CafeHesapPage':
        return _rotaOlustur(const CafeHesapPage(), settings);

      case '/CafeOdemePage':
        return _rotaOlustur(const CafeOdemePage(), settings);

      case '/CafeSiparisPage':
        return _rotaOlustur(const CafeSiparisPage(), settings);

      case '/CafeSiparisDetayPage':
        return _rotaOlustur(const CafeSiparisDetayPage(), settings);

      case '/CafeIptal':
        return _rotaOlustur(const CafeIptal(), settings);

      case '/CafeUrunPage':
        return _rotaOlustur(const CafeUrunPage(), settings);

      case '/CafeKasaPage':
        return _rotaOlustur(const CafeKasaPage(), settings);

      case '/CafePersonelPage':
        return _rotaOlustur(const CafePersonelPage(), settings);

      case '/CafePersonelDetayPage':
        return _rotaOlustur(const CafePersonelDetayPage(), settings);

      case '/CafeNewPersonelPage':
        return _rotaOlustur(const CafeNewPersonelPage(), settings);

      case '/CafeYeniUrunPage':
        return _rotaOlustur(const CafeYeniUrunPage(), settings);

      case '/CafeUrunDetayPage':
        return _rotaOlustur(const CafeUrunDetayPage(), settings);

      case '/CafeMasaDetayPage':
        return _rotaOlustur(const CafeMasaDetayPage(), settings);

      case '/CafeYeniKategoriPage':
        return _rotaOlustur(const CafeYeniKatePage(), settings);

      case '/CafeKategoriDuzenlePage':
        return _rotaOlustur(const CafeKateDetayPage(), settings);

      case '/CafeStaticMenuPage':
        return _rotaOlustur(const CafeStaticMenuPage(), settings);

      case '/CafePdfMenuPage':
        return _rotaOlustur(const CafePdfMenuPage(), settings);

      //------------------------------personel---------------------------
      //---------------------------------|-------------------------------
      //---------------------------------v-------------------------------

      case '/PersonelGirisPage':
        return _rotaOlustur(const PersonelGirisPage(), settings);

      case '/PersonelRefTokenPage':
        return _rotaOlustur(const PersonelRefTokenPage(), settings);

      case '/PersonelHomePage':
        return _rotaOlustur(const PersonelHomePage(), settings);

      case '/PersonelKayitPage':
        return _rotaOlustur(const PersonelKayitPage(), settings);

      case '/PersonelKodGirisPage':
        return _rotaOlustur(const PersonelKodGirisPage(), settings);

      case '/PersonelNewPassPage':
        return _rotaOlustur(const PersonelNewLoginPage(), settings);

      case '/PersonelNewPassPage2':
        return _rotaOlustur(const PersonelNewPassLoginPage(), settings);

      case '/PersonelAyarPage':
        return _rotaOlustur(const PersonelAyarPage(), settings);

      case '/PersonelMenuPage':
        return _rotaOlustur(const PersonelMenuPage(), settings);

      case '/PersonelMenuDetayPage':
        return _rotaOlustur(const PersonelMenuDetayPage(), settings);

      case '/PersonelMasaPage':
        return _rotaOlustur(const PersonelMasaPage(), settings);

      case '/PersonelHesapPage':
        return _rotaOlustur(const PersonelHesapPage(), settings);

      case '/PersonelOdemePage':
        return _rotaOlustur(const PersonelOdemePage(), settings);

      case '/PersonelSiparisPage':
        return _rotaOlustur(const PersonelSiparisPage(), settings);

      case '/PersonelSiparisDetayPage':
        return _rotaOlustur(const PersonelSiparisDetayPage(), settings);

      case '/PersonelIptal':
        return _rotaOlustur(const PersonelIptal(), settings);

      case '/PersonelUrunPage':
        return _rotaOlustur(const PersonelUrunPage(), settings);

      case '/PersonelYeniUrunPage':
        return _rotaOlustur(const PersonelYeniUrunPage(), settings);

      case '/PersonelUrunDetayPage':
        return _rotaOlustur(const PersonelUrunDetayPage(), settings);

      case '/PersonelMasaDetayPage':
        return _rotaOlustur(const PersonelMasaDetayPage(), settings);

      case '/PersonelMasaCagriPage':
        return _rotaOlustur(const PersonelMasaCagriPage(), settings);

      default:
        return (MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Bir Hata Oluştu Bos sayfa'),
            ),
          ),
        ));
    }
  }
}
