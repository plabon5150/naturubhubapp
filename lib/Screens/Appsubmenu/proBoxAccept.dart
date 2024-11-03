import 'package:flutter/material.dart';
import 'package:naturub/lightColor.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:naturub/Service/apiservice.dart';
import 'package:naturub/lightColor.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../Models/productionModel.dart';
import '../Main/home_screen.dart';
import '../Main/home_screen.dart';

class ProductionBoxAccept extends StatefulWidget {
  const ProductionBoxAccept({super.key});

  @override
  State<ProductionBoxAccept> createState() => _ProductionBoxAcceptState();
}

class _ProductionBoxAcceptState extends State<ProductionBoxAccept> {
  QRViewController? controller;
  bool isApiCallMade = false;
  bool isLoading = false;
  List<ProductionModel> _productionModel = [];
  List<ProductionModel> _selectedJobs = [];
  Barcode? result;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool ScannerOpen = false;
  @override
  Widget build(BuildContext context) {
    return ScannerOpen == true ? _buildQRView() : _buildBoxAssignView();
  }

  Widget _buildQRView() {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      formatsAllowed: const [
        BarcodeFormat.code128,
        BarcodeFormat.qrcode,
        BarcodeFormat.dataMatrix,
        BarcodeFormat.aztec,
        BarcodeFormat.rss14,
        BarcodeFormat.ean13,
        BarcodeFormat.upcA,
        BarcodeFormat.code39
      ],
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  Future<void> _save() async {
    setState(() {
      isLoading = true;
    });
    try {
      final machines = await HttpService().saveDailyAccept(_selectedJobs);
      setState(() {
        _selectedJobs = [];
        _productionModel = [];
      });
    } catch (e) {
      print('Error fetching machines: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _clear() {
    _selectedJobs = [];
    _productionModel = [];
    print('Clear button pressed');
  }

  Widget _assigningDetails() {
    return Material(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          _productionModel.isEmpty
                              ? "Box No"
                              : _productionModel[0].intBoxID.toString(),
                          style: TextStyle(
                              fontSize: 28,
                              fontFamily: "Teko",
                              color: Colors.grey),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.barcode_reader,
                            size: 40,
                          ), // Use your desired barcode scanner icon
                          color: Colors.amber,
                          onPressed: () {
                            // Implement your barcode scanning logic here
                            _startBarcodeScanning();
                          },
                        ),
                      ]),
                  SizedBox(height: 20),
                  ..._buildJobCards(),
                  SizedBox(
                    height: 150, // Specify a height that fits your layout

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _save,
                          icon: Icon(Icons.save), // Save icon
                          label: Text('Save'), // Save text
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.green[700])),
                        ),
                        SizedBox(
                            height: 20), // Changed to height instead of width
                        ElevatedButton.icon(
                          onPressed: _clear,
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.red[700])),
                          icon: Icon(Icons.clear), // Clear icon
                          label: Text('Clear'), // Clear text
                          // style: ElevatedButton.styleFrom(
                          //   padding:
                          //       EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          // ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget _buildBoxAssignView() {
    return Column(
      children: <Widget>[
        _header(context),
        const SizedBox(height: 20),
        isLoading ? _loadingIndicator() : _assigningDetails(),
      ],
    );
  }

  List<Widget> _buildJobCards() {
    return _productionModel.map((model) {
      return Card(
        margin: EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Job No: ${model.vcJobNo}",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Checkbox(
                    value: model.isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        model.isSelected = value ?? false;
                        if (model.isSelected) {
                          _selectedJobs.add(model);
                        } else {
                          _selectedJobs.remove(model);
                        }
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 5),
              // Always show the Net Weight input field
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Net Weight KG: ${model.netKg}",
                    style: TextStyle(fontSize: 16.0),
                  )),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Net Weight Yard: ${model.netYard}",
                    style: TextStyle(fontSize: 16.0),
                  )),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _loadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      apicall(result, isApiCallMade, () {
        setState(() {
          result = null;
          isApiCallMade = true;
          ScannerOpen = false;
        });
      });
    });
  }

  void _startBarcodeScanning() {
    setState(() {
      ScannerOpen = true;
    });
  }

  void apicall(
      dynamic result, bool isApiCallMade, VoidCallback setStateCallback) async {
    if (result != null) {
      final _listJob = await HttpService()
          .getJobDetailsAcceptUsingBoxBarcode(result.code.toString());
      setState(() {
        _productionModel = _listJob;
        ScannerOpen = false;
      });
    }
  }

  Widget _header(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
        child: Container(
            height: 200,
            width: width,
            decoration: const BoxDecoration(
              color: LightColor.grey,
            ),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                    top: 30,
                    right: -100,
                    child: _circularContainer(300, LightColor.logoBlue)),
                Positioned(
                    top: -100,
                    left: -45,
                    child: _circularContainer(width * .5, LightColor.darkBlue)),
                Positioned(
                    top: -180,
                    right: -30,
                    child: _circularContainer(width * .7, Colors.transparent,
                        borderColor: Colors.white38)),
                Positioned(
                    top: 40,
                    left: 0,
                    child: Container(
                        width: width,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_left,
                                color: Colors.white,
                                size: 40,
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Box Accept",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                          ],
                        )))
              ],
            )),
      ),
    );
  }

  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }
}
