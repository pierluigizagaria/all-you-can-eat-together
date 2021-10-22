import 'dart:io';
import 'package:allyoucaneattogether/models/group.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class TableQRCodeScannerScreen extends StatefulWidget {
  static const String routeName = '/qrcodescanner';
  const TableQRCodeScannerScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TableQRCodeScannerScreenState();
}

class _TableQRCodeScannerScreenState extends State<TableQRCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool qrCodeProcessing = false;

  void _onPermissionSet(
    BuildContext context,
    QRViewController controller,
    bool hasPermission,
  ) {
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Non è possibile accedere alla fotocamera')),
      );
    }
  }

  void _onQRViewCreated(BuildContext context, QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((barcode) {
      _onScannedData(context, barcode);
    });
  }

  Future<void> _onScannedData(BuildContext context, Barcode barcode) async {
    String value = barcode.code;
    if (qrCodeProcessing) return;
    setState(() => qrCodeProcessing = true);
    if (value.length != Group.codeLength) {
      setState(() => qrCodeProcessing = false);
      return;
    }
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Unisciti al tavolo')),
      body: QRView(
        key: qrKey,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 240,
          cutOutBottomOffset: AppBar().preferredSize.height,
        ),
        onPermissionSet: (controller, hasPermission) {
          _onPermissionSet(context, controller, hasPermission);
        },
        onQRViewCreated: (controller) {
          _onQRViewCreated(context, controller);
        },
      ),
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) controller!.pauseCamera();
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
