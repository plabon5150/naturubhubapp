import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:naturub/Service/apiservice.dart';
import 'package:naturub/lightColor.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../Models/productionModel.dart';
import '../../Models/weightScaleModel.dart';
import '../Main/home_screen.dart';

class ProductionBoxDispatch extends StatefulWidget {
  const ProductionBoxDispatch({super.key});

  @override
  State<ProductionBoxDispatch> createState() => _ProductionBoxDispatchState();
}

class _ProductionBoxDispatchState extends State<ProductionBoxDispatch> {
  QRViewController? controller;
  bool isApiCallMade = false;
  bool isLoading = false;
  List<ProductionModel> _productionModel = [];
  List<WeightMachine> _weightMachine = [];
  List<ProductionModel> _selectedJobs = [];
  Barcode? result;
  bool _isSaveEnabled = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool ScannerOpen = false;
  double _liveWeight = 0.0;
  bool _isUpdating = false; // Flag to control API calls
  Timer? _timer; // Timer to periodically call the API
  String errorMessage = "";

  Future<void> _fetchLiveWeight() async {
    final _listJob = await HttpService().getWeightFromScale();
    setState(() {
      _weightMachine = _listJob;
    });

    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _liveWeight =
          (_weightMachine.length != 0 ? _weightMachine[0].weightValue : 0)
              .toDouble();
    });
  }

  void _startUpdatingWeight() {
    setState(() {
      _isUpdating = true; // Start updating
    });

    // Call the API every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _fetchLiveWeight();
    });
  }

  void _stopUpdatingWeight() {
    setState(() {
      _isUpdating = false; // Stop updating
    });

    // Cancel the timer
    _timer?.cancel();
  }

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
      final machines = await HttpService().saveDailyDispatch(_selectedJobs);
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
                  IconButton(
                    icon: Icon(
                      _isUpdating ? Icons.scale : Icons.scale_outlined,
                      size: 40,
                      color: _isUpdating ? Colors.green : Colors.grey,
                    ),
                    onPressed: () {
                      if (_isUpdating) {
                        _stopUpdatingWeight();
                      } else {
                        _startUpdatingWeight();
                      }
                    },
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Weight: $_liveWeight kg',
                    style: TextStyle(
                        fontSize: 28, fontFamily: "Teko", color: Colors.grey),
                  ),
                  Text(
                    _productionModel.isEmpty
                        ? "Box No"
                        : _productionModel[0].intBoxID.toString(),
                    style: TextStyle(
                        fontSize: 28, fontFamily: "Teko", color: Colors.grey),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.barcode_reader,
                      size: 40,
                    ),
                    color: Colors.amber,
                    onPressed: () {
                      // Implement your barcode scanning logic here
                      _startBarcodeScanning();
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Wrap the job cards in a Container with a specific height
              Container(
                height: 400, // Set the height as needed
                child: ListView(
                  children:
                      _buildJobCards(_liveWeight), // Call your existing method
                ),
              ),
              SizedBox(
                height: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isSaveEnabled ? _save : null,
                      icon: Icon(Icons.save), // Save icon
                      label: Text('Save'), // Save text
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.green[700]),
                      ),
                    ),
                    SizedBox(height: 20), // Changed to height instead of width
                    ElevatedButton.icon(
                      onPressed: _clear,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.red[700]),
                      ),
                      icon: Icon(Icons.clear), // Clear icon
                      label: Text('Clear'), // Clear text
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  List<Widget> _buildJobCards(double scaleWeight) {
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
                        _validateTotalWeight(scaleWeight);
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Box Weight: ${model.decBoxWeight}",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Net Weight: ",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: model.netWeight != null
                            ? '${model.netWeight}'
                            : 'Enter Net Weight',
                      ),
                      onChanged: (String value) {
                        setState(() {
                          model.netWeight = double.tryParse(value);
                          _validateTotalWeight(scaleWeight);
                        });
                      },
                    ),
                  ),
                ],
              ),
              if (errorMessage != "") // Show error message if exists
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      );
    }).toList();
  }

  void _validateTotalWeight(double scaleWeight) {
    double totalNetWeight = 0;
    Set<int> processedBoxes = Set(); // To track which boxes have been processed

    // Calculate the total net weight from the selected jobs
    for (var job in _productionModel) {
      if (job.netWeight != null) {
        if (!processedBoxes.contains(job.intBoxID)) {
          // Subtract box weight only once per box
          totalNetWeight +=
              job.netWeight!; // Add the net weight input by the user
          processedBoxes.add(job.intBoxID!); // Mark this box as processed
        } else {
          totalNetWeight += job
              .netWeight!; // Add net weight without subtracting box weight again
        }
      }
    }

    double totalExpectedNetWeight = _liveWeight -
        _productionModel[0].decBoxWeight!; // Live weight minus box weight

    print(totalExpectedNetWeight);

    // Check if total net weight equals expected net weight (live weight - box weight)
    if (totalNetWeight == totalExpectedNetWeight) {
      setState(() {
        _isSaveEnabled = true;
        errorMessage = ''; // Clear any error message
      });
    } else {
      setState(() {
        _isSaveEnabled = false;
        Fluttertoast.showToast(
          msg: "Total net weight does not match the expected weight.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    }
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
          .getJobDetailsUsingBoxBarcode(result.code.toString());
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
                                  "Box Dispatch",
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
