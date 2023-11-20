import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ota_dfu/screens/device_screen.dart';
import 'package:ota_dfu/widgets/scanned_result_item.dart';
import 'package:ota_dfu/widgets/loading.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _bluetoothIsReady = false;
  bool _isScanning = false;
  List<ScanResult> _scannedResults = [];
  late StreamSubscription<List<ScanResult>> _scanSubcription;

  void onScanned(List<ScanResult> results) {
    setState(() {
      _scannedResults = results
          .where((result) => result.device.platformName.isNotEmpty)
          .toList();
    });
  }

  void onTapConnect(BluetoothDevice device, BuildContext currentContext) async {
    FlutterBluePlus.stopScan();
    Navigator.of(currentContext).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => DeviceScreen(device: device),
      ),
    );
    return;
  }

  @override
  void initState() {
    super.initState();
    FlutterBluePlus.adapterState
        .where((state) => state == BluetoothAdapterState.on)
        .first
        .then((_) {
      setState(() {
        _bluetoothIsReady = true;
      });
    });
    _scanSubcription = FlutterBluePlus.scanResults.listen(onScanned);
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    _scanSubcription.cancel();
    super.dispose();
  }

  void toggleScanning() {
    if (FlutterBluePlus.isScanningNow) {
      FlutterBluePlus.stopScan();
      return;
    }

    FlutterBluePlus.startScan(
      withServices: [Guid('8D53DC1D-1DB7-4CD3-868B-8A527460AA84')],
    ).whenComplete(() {
      setState(() {
        _isScanning = false;
        _scannedResults = [];
      });
    });
    setState(() {
      _isScanning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const Loading(
      waitingMessage: 'Waiting for bluetooth is ready!',
    );
    if (_bluetoothIsReady) {
      body = _scannedResults.isEmpty
          ? const Center(
              child: Text('Press Scan button to find Bluetooth devices'),
            )
          : Column(
              children: _scannedResults
                  .map((scannedResult) => ScannedResultItem(
                        scannedResult: scannedResult,
                        onTapConnect: onTapConnect,
                      ))
                  .toList(),
            );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices List'),
        actions: [
          TextButton(
            onPressed: _bluetoothIsReady ? toggleScanning : null,
            child: Text(_isScanning ? 'Stop Scan' : 'Scan'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: body,
      ),
    );
  }
}
