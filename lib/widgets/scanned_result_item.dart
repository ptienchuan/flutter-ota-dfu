import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScannedResultItem extends StatelessWidget {
  final ScanResult scannedResult;
  final void Function(BluetoothDevice device, BuildContext currentContext)
      onTapConnect;

  const ScannedResultItem({
    super.key,
    required this.scannedResult,
    required this.onTapConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.secondaryContainer,
        leading: const Icon(Icons.bluetooth_audio),
        trailing: TextButton(
          onPressed: () {
            onTapConnect(scannedResult.device, context);
          },
          child: const Text('Connect'),
        ),
        title: Text(scannedResult.device.localName),
        subtitle: Text('rssi: ${scannedResult.rssi.toString()}'),
      ),
    );
  }
}
