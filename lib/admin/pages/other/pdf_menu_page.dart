import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

import '../../../../main.dart';
import '../../helpers/send.dart';
import '../../helpers/sqldatabase.dart';
import '../../model/cafe.dart';
import '../../model/musterimodel.dart';
import '../../model/personel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

Cafe _cafe = Cafe();
// ignore: non_constant_identifier_names
bool _isEkle = false;
Uint8List? _imgbit;

File _file = File('');
String? _filePath;

int? pages = 0;
bool isReady = false;
bool _isWaiting = false;
bool _isDownloaded = false;
Directory dir = Directory('');
bool _isWaitingFile = false;
bool _newPdf = false;

class CafePdfMenuPage extends StatefulWidget {
  const CafePdfMenuPage({Key? key}) : super(key: key);

  @override
  State<CafePdfMenuPage> createState() => _CafePdfMenuPageState();
}

class _CafePdfMenuPageState extends State<CafePdfMenuPage> {
  @override
  void initState() {
    _isWaitingFile = false;
    _newPdf = false;
    _isEkle = false;
    _isWaiting = false;
    _isDownloaded = false;
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;

    if (_isWaiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_isEkle) {
      return PdfSelectedContainer(_setS);
    }

    if (_cafe.cafeAyar!.pdfUrl == null ||
        _cafe.cafeAyar!.pdfUrl == '' ||
        _newPdf) {
      return PdfSecContainer(_setS);
    }

    return PdfRemoteContainer(_setS);
  }

  _setS() {
    if (mounted) {
      setState(() {});
    }
  }
}

class PdfSelectedContainer extends StatefulWidget {
  const PdfSelectedContainer(this.callback, {Key? key}) : super(key: key);
  final void Function() callback;

  @override
  State<PdfSelectedContainer> createState() => _PdfSelectedContainerState();
}

class _PdfSelectedContainerState extends State<PdfSelectedContainer> {
  @override
  Widget build(BuildContext context) {
    return PDFScreenSelected(
      path: _filePath,
      callback: widget.callback,
    );
  }
}

class PdfRemoteContainer extends StatefulWidget {
  const PdfRemoteContainer(this.callback, {Key? key}) : super(key: key);
  final void Function() callback;

  @override
  State<PdfRemoteContainer> createState() => _PdfRemoteContainerState();
}

class _PdfRemoteContainerState extends State<PdfRemoteContainer> {
  @override
  void initState() {
    _isWaitingFile = true;
    _downloadPdfLocal(context, _cafe.cafeAyar!.pdfUrl!, widget.callback);
    _getPdfFile();
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDownloaded || _isWaitingFile) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    var fileP = '${dir.path}/reklamvideo/${_cafe.cafeAyar!.pdfUrl!}';
    return PDFScreenRemote(
      path: fileP,
      callback: widget.callback,
    );
  }

  _getPdfFile() async {
    dir = await getApplicationDocumentsDirectory();
    _isWaitingFile = false;
    setState(() {});
  }
}

_getPdf(BuildContext context, Function setS) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );
  if (result != null && result.files.single.path != null) {
    _filePath = result.files.single.path;
    _file = File(result.files.single.path!);
    var pathstr = _file.path;
    pathstr = pathstr.substring(pathstr.length - 4, pathstr.length);
    if (pathstr == '.pdf') {
      _imgbit = await _file.readAsBytes();
      _isEkle = true;
    }
    setS();
  } else {
    EasyLoading.showToast('PDF SEÇİLEMEDİ TEKRAR DENEYİNİZ');
  }
}

class PdfSecContainer extends StatefulWidget {
  const PdfSecContainer(this.callback, {Key? key}) : super(key: key);
  final void Function() callback;

  @override
  State<PdfSecContainer> createState() => _PdfSecContainerState();
}

class _PdfSecContainerState extends State<PdfSecContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const VazgecButon(),
            SecButon(widget.callback),
          ],
        ),
      ],
    );
  }
}

class SecButon extends StatefulWidget {
  const SecButon(this.callback, {Key? key}) : super(key: key);
  final void Function() callback;

  @override
  State<SecButon> createState() => _SecButonState();
}

class _SecButonState extends State<SecButon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 15, left: _width / 25),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 10,
              fixedSize: Size((_width * 0.40), (_height / 15)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          onPressed: () {
            _getPdf(context, widget.callback);
          },
          child: Text(
            'SEÇ',
            style: TextStyle(fontSize: _width / 15),
          )),
    );
  }
}

class PDFScreenSelected extends StatefulWidget {
  const PDFScreenSelected({Key? key, this.path, required this.callback})
      : super(key: key);
  final void Function() callback;
  final String? path;

  @override
  // ignore: library_private_types_in_public_api
  _PDFScreenSelectedState createState() => _PDFScreenSelectedState();
}

class _PDFScreenSelectedState extends State<PDFScreenSelected>
    with WidgetsBindingObserver {
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            pageSnap: false,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.HEIGHT,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter

            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
                if (kDebugMode) {
                  debugPrint(error);
                }
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? const Center()
                  : Container()
              : Center(
                  child: Text(errorMessage),
                ),
          Align(
            alignment: Alignment.topRight,
            child: SendButon(widget.callback),
          ),
          const Align(
            alignment: Alignment.topLeft,
            child: VazgecButon(),
          ),
        ],
      ),
    );
  }
}

class PDFScreenRemote extends StatefulWidget {
  const PDFScreenRemote({Key? key, this.path, required this.callback})
      : super(key: key);
  final void Function() callback;
  final String? path;

  @override
  // ignore: library_private_types_in_public_api
  _PDFScreenRemoteState createState() => _PDFScreenRemoteState();
}

class _PDFScreenRemoteState extends State<PDFScreenRemote>
    with WidgetsBindingObserver {
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            pageSnap: false,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.HEIGHT,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter

            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
                if (kDebugMode) {
                  debugPrint(error);
                }
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? const Center()
                  : Container()
              : Center(
                  child: Text(errorMessage),
                ),
          const Align(
            alignment: Alignment.topLeft,
            child: VazgecButon(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: DegisButon(widget.callback),
          ),
        ],
      ),
    );
  }
}

class SendButon extends StatefulWidget {
  const SendButon(this.callback, {Key? key}) : super(key: key);
  final void Function() callback;

  @override
  State<SendButon> createState() => _SendButonState();
}

class _SendButonState extends State<SendButon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 15, right: _width / 25),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 10,
              fixedSize: Size((_width * 0.40), (_height / 15)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          onPressed: () {
            _isWaiting = true;
            _isEkle = false;
            _sendImage(context);
            widget.callback();
          },
          child: const Text('ONAYLA')),
    );
  }
}

class DegisButon extends StatefulWidget {
  const DegisButon(this.callback, {Key? key}) : super(key: key);
  final void Function() callback;

  @override
  State<DegisButon> createState() => _DegisButonState();
}

class _DegisButonState extends State<DegisButon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 15, right: _width / 25),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 10,
              fixedSize: Size((_width * 0.40), (_height / 15)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          onPressed: () {
            _isWaiting = false;
            _isEkle = false;
            _newPdf = true;
            widget.callback();
          },
          child: const Text('DEĞİŞTİR')),
    );
  }
}

class VazgecButon extends StatefulWidget {
  const VazgecButon({Key? key}) : super(key: key);

  @override
  State<VazgecButon> createState() => _VazgecButonState();
}

class _VazgecButonState extends State<VazgecButon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 15, left: _width / 25),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              elevation: 10,
              fixedSize: Size((_width * 0.40), (_height / 15)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          onPressed: () {
            _isWaiting = false;
            _imgbit = null;
            _isEkle = false;
            Navigator.pushNamedAndRemoveUntil(context, '/CafeHomePage',
                (route) => route.settings.name == '/CafeHomePage');
          },
          child: const Text('VAZGEÇ')),
    );
  }
}

_sendRefAyar(BuildContext context) async {
  print('send ref ayar');
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.tokens = tok;

  _cafe.istekTip = 'ayar_ref';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());
  _isEkle = false;

  _imgbit = null;
  print('send ref ayar2');
  // ignore: use_build_context_synchronously
  sendRefMenuAyarPdf(json, channel, context);
}

_sendImage(BuildContext context) async {
  _isEkle = false;
  _isWaiting = false;
  print('send image');
  MediaIp mediaip = MediaIp();
  mediaip.media = _imgbit;
  mediaip.objectTip = 'pdf';
  _cafe.mediaIp = [mediaip];

  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.tokens = tok;

  _cafe.istekTip = 'media_new';

  WebSocketChannel channel2 = IOWebSocketChannel.connect(urlAdmin);

  var json = jsonEncode(_cafe.toMap());
  print('send image 2');

  channel2.sink.add(json);

  channel2.stream.listen((data) {
    print('send image 3');
    var musteri = Cafe();
    var jsonobject = jsonDecode(data);
    musteri = Cafe.fromMap(jsonobject);

    if (musteri.status == true) {
      _cafe.cafeAyar!.pdfUrl = musteri.mediaIp![0].objectId;
      print('obje id = ${_cafe.cafeAyar!.pdfUrl}');

      _sendRefAyar(context);
    } else if (musteri.status == false) {
      EasyLoading.showToast(
          'PDF YÜKLERNİRKEN BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
    } else {
      EasyLoading.showToast(
          'PDF YÜKLERNİRKEN BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
    }

    channel2.sink.close();
  }, onError: (e) {
    debugPrint(e.toString());
  });
}

Future _downloadPdfLocal(
    BuildContext context, String videoId, Function setS) async {
  String? pdfId = await pdfIdGet();
  if (pdfId != null) {
    if (pdfId == videoId) {
      _isDownloaded = true;
      return;
    }
  }
  dir = await getApplicationDocumentsDirectory();
  Dio dio = Dio();
  try {
    await dio.download(
      imageurl + videoId,
      "${dir.path}/reklamvideo/$videoId",
    );
    _isDownloaded = true;
    pdfIdIntert(videoId);

    setS();
  } catch (e) {
    EasyLoading.showToast(
        'Pdf Yüklenemedi ! sorun devam ederse lütfen bize ulaşın',
        duration: const Duration(seconds: 6));
    if (kDebugMode) {
      debugPrint(e.toString());
    }
    // ignore: use_build_context_synchronously
    Navigator.pushNamedAndRemoveUntil(context, '/CafeHomePage',
        (route) => route.settings.name == '/CafeHomePage');
  }
}
