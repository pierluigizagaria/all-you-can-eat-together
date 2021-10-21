import 'dart:io';

import 'package:allyoucaneattogether/widgets/group_code_text_field.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                const AspectRatio(
                  aspectRatio: 1,
                  child: GroupQRCodeScanner(),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: QrImage(
                    backgroundColor: Colors.white.withOpacity(0.3),
                    data: "1234567890",
                    version: QrVersions.auto,
                    size: 240.0,
                  ),
                ),
              ],
            ),
            Container(
              width: 240,
              child: GroupCodeTextField(),
            )
          ],
        ),
      ),
    );
  }
}

class GroupQRCodeScanner extends StatefulWidget {
  const GroupQRCodeScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupQRCodeScannerState();
}

class _GroupQRCodeScannerState extends State<GroupQRCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen(_onScannedData);
  }

  void _onPermissionSet(
    BuildContext context,
    QRViewController controller,
    bool hasPermission,
  ) {
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Non è possibile accedere alla fotocamera')),
      );
    }
  }

  void _onScannedData(Barcode barcode) {}

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      onPermissionSet: (controller, hasPermission) {
        return _onPermissionSet(context, controller, hasPermission);
      },
    );
  }
}
