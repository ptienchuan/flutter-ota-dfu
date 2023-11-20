import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ota_dfu/screens/scan_screen.dart';
import 'package:ota_dfu/widgets/loading.dart';
import 'package:ota_dfu/widgets/scaffold_body_container.dart';

import 'package:mcumgr_flutter/mcumgr_flutter.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:io';

class DeviceScreen extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceScreen({
    super.key,
    required this.device,
  });

  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  bool _isConnected = false;
  int _sentPercent = -1;
  late BluetoothCharacteristic smpCharacteristic;
  final UpdateManagerFactory managerFactory = FirmwareUpdateManagerFactory();

  void discoverServices() async {
    final services = await widget.device.discoverServices();
    for (var service in services) {
      if (service.serviceUuid.toString() ==
          '8d53dc1d-1db7-4cd3-868b-8a527460aa84') {
        smpCharacteristic = service.characteristics[0];
      }
    }
    setState(() {
      _isConnected = true;
    });
  }

  void connectToDevice() {
    widget.device
        .connect(
          autoConnect: true,
          timeout: const Duration(seconds: 2),
        )
        .then((_) => discoverServices());
  }

  void disconnectCurrentDevice() {
    widget.device.disconnect().then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const ScanScreen()),
      );
    });
  }

  void onSendFirmware() async {
    final device = widget.device;
    print('device: ${device.remoteId.toString()}');
    final updateManager =
        await managerFactory.getUpdateManager(device.remoteId.toString());

    final updateStream = updateManager.setup();

    updateStream.listen((event) {
      print(event);
      if (event == FirmwareUpgradeState.confirm) {
        setState(() {
          _sentPercent = 101;
        });
      }
    });
    updateManager.progressStream.listen((event) {
      // print("${event.bytesSent} / ${event.imageSize}} bytes sent");
      final percent = (event.bytesSent / event.imageSize) * 100;
      setState(() {
        _sentPercent = percent.toInt();
      });
      print("${percent.toInt()}% sent");
    });

    List<Tuple2<int, Uint8List>> firmwareScheme = [];
    final fileContent = await rootBundle.load('assets/app_update.bin');
    final part = 1;
    firmwareScheme.add(Tuple2(part, fileContent.buffer.asUint8List()));

    updateManager.update(
      firmwareScheme,
      configuration:
          const FirmwareUpgradeConfiguration(eraseAppSettings: false),
    );
  }

  void onResetDevice() async {
    List<int> resetCommand = [
      0x02,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x05,
    ];
    smpCharacteristic.write(
      resetCommand,
      withoutResponse: true,
    );
    disconnectCurrentDevice();
  }

  @override
  void initState() {
    super.initState();
    connectToDevice();
  }

  @override
  Widget build(BuildContext context) {
    Widget body =
        Loading(waitingMessage: 'Connecting to ${widget.device.platformName}');

    Widget row1 = _sentPercent < 0
        ? OutlinedButton(
            onPressed: onSendFirmware,
            child: const Text('Send firmware'),
          )
        : Text(_sentPercent == 101 ? 'DFU Done' : 'Sent: ${_sentPercent}%');

    if (_isConnected) {
      body = Column(
        children: [
          Column(
            children: [
              row1,
              OutlinedButton(
                onPressed: onResetDevice,
                child: const Text('Reset'),
              ),
            ],
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.platformName),
        actions: [
          TextButton(
            onPressed: disconnectCurrentDevice,
            child: const Text('Disconnect'),
          ),
        ],
      ),
      body: ScaffoldBodyContainer(child: body),
    );
  }
}
