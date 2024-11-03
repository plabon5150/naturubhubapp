import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:lottie/lottie.dart';
import 'package:naturub/Models/requestDetailsSMS.dart';
import 'package:naturub/Models/sectionwiseuser.dart';
import 'package:naturub/Models/smsDispatchDetails.dart';
import 'package:naturub/Screens/Main/home_screen.dart';
import 'package:naturub/Service/apiservice.dart';
import 'package:naturub/StateManagement/appDetails.dart';
import 'package:naturub/lightColor.dart';
import 'package:naturub/sharedDate/appData.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SmsTransection extends StatefulWidget {
  const SmsTransection({super.key});

  @override
  State<SmsTransection> createState() => _SmsTransectionState();
}

class _SmsTransectionState extends State<SmsTransection> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  List<RequestDetails> detailsList = [];
  List<SmsDispacthDetails> sectionDetails = [];
  List<sectionwiseuser> retrievedList = [];
  bool isApiCallMade = false;
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
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.keyboard_arrow_left,
                              color: Colors.white,
                              size: 40,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "SMS Transection",
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

  Widget _buildDetailsView() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _header(context),
              const SizedBox(
                height: 20,
              ),
              _transectionDetails(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isApiCallMade == false ? _buildQRView() : _buildDetailsView();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void apicall(
      dynamic result, bool isApiCallMade, VoidCallback setStateCallback) async {
    if (result != null && !isApiCallMade) {
      try {
        detailsList =
            await HttpService().mktDetailsByBarcode(result!.code.toString());
        if (detailsList.isNotEmpty) {
          sectionDetails = await HttpService()
              .dispatchDetailsSection(detailsList[0].sampleCode.toString());

          setStateCallback(); // Call the callback function to update the state

          // Rest of your code...
        } else {
          controller?.dispose();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return const HomePage();
          }));
          showToastWidget(
            const Text('No Data found', selectionColor: Colors.red),
            duration: const Duration(seconds: 5),
            context: context,
          );
        }
      } catch (e) {
        // Handle any errors that might occur during the API call
        print('Error calling mktDetailsByBarcode: $e');
      }
    }
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
          isApiCallMade = true; // Set the flag to true after the API call
        });
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getSection();
    super.initState();
  }

  void getSection() async {
    retrievedList = await AppData.getListSection();
  }

  bool _isSectionNameMatch(
      String sectionName, List<sectionwiseuser> updatedList) {
    // Check if sectionName exists in the updatedList
    for (var user in updatedList) {
      if (user.sectionName == sectionName) {
        return true;
      }
    }
    return false;
  }

  Widget _transectionDetails() {
    return Consumer<AppState>(builder: (context, appState, child) {
      var height = MediaQuery.of(context).size.height;
      List<sectionwiseuser> updatedList = appState.list;

      return Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
              height: height,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: LightColor.logoBlue),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.red[900],
                            radius: 40,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.request_quote,
                                size: 40,
                              ),
                              color: Colors.white,
                              onPressed: () => {},
                            ),
                          ),
                          const Dash(
                              direction: Axis.vertical,
                              length: 120,
                              dashLength: 5,
                              dashThickness: 3,
                              dashColor: Colors.red)
                        ],
                      ),
                      Container(
                        height: 100,
                        width: 250,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: Column(
                          children: [
                            const Padding(padding: EdgeInsets.all(5)),
                            Text(
                              "Request No: ${detailsList.isNotEmpty ? detailsList[0].sampleCode : 'No data'}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Request By:${detailsList.isNotEmpty ? detailsList[0].mktExName : 'No data'}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Request on: ${detailsList.isNotEmpty ? detailsList[0].requestedOn : 'No data'}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Quantity: ${detailsList.isNotEmpty ? detailsList[0].decSampleDispatchQty : 'No data'}",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: (height / 4.2)),
                      child: SizedBox(
                        height: height * 2,
                        child: ListView.builder(
                          itemCount: sectionDetails.length,
                          itemBuilder: (context, index) {
                            bool isAcceptButtonEnabled =
                                (sectionDetails[index].acptDispOn != null ||
                                        sectionDetails[index].dispatchOn !=
                                            null) &&
                                    (sectionDetails[index].acptDispOn == null &&
                                        _isSectionNameMatch(
                                            sectionDetails[index].toSection!,
                                            retrievedList));

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: sectionDetails[index]
                                                      .dispatchOn !=
                                                  null &&
                                              sectionDetails[index]
                                                      .acptDispOn !=
                                                  null
                                          ? Colors.red[900]
                                          : sectionDetails[index].acptDispOn ==
                                                      null &&
                                                  sectionDetails[index]
                                                          .dispatchOn ==
                                                      null
                                              ? Colors.orange
                                              : Colors.green,
                                      radius: 40,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          sectionDetails[index].acptDispOn !=
                                                      null &&
                                                  sectionDetails[index]
                                                          .dispatchOn !=
                                                      null
                                              ? Icons.done
                                              : sectionDetails[index]
                                                              .acptDispOn ==
                                                          null &&
                                                      sectionDetails[index]
                                                              .dispatchOn ==
                                                          null
                                                  ? Icons.next_plan_rounded
                                                  : Icons.waves,
                                          size: 40,
                                        ),
                                        color: Colors.white,
                                        onPressed: () => {},
                                      ),
                                    ),
                                    Dash(
                                      direction: Axis.vertical,
                                      length: 120,
                                      dashLength: 5,
                                      dashThickness: 3,
                                      dashColor: sectionDetails[index]
                                                      .acptDispOn !=
                                                  null &&
                                              sectionDetails[index]
                                                      .dispatchOn !=
                                                  null
                                          ? Colors.red
                                          : sectionDetails[index].acptDispOn ==
                                                      null &&
                                                  sectionDetails[index]
                                                          .dispatchOn !=
                                                      null
                                              ? Colors.green
                                              : Colors.orange,
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 150,
                                  width: 250,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                  child: Column(
                                    children: [
                                      const Padding(padding: EdgeInsets.all(5)),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          "Section: ${sectionDetails[index].sectionName}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        sectionDetails[index].dispatchOn != null
                                            ? "Dispatch on: ${sectionDetails[index].dispatchOn}"
                                            : "",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      isAcceptButtonEnabled
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: Container(
                                                height: 50,
                                                width: 200,
                                                child: ElevatedButton.icon(
                                                  icon: const Icon(
                                                    Icons.handshake,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                  label: const Text(
                                                    'Accept',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _showPopup(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : sectionDetails[index].acptDispOn !=
                                                  null
                                              ? Text(
                                                  "Accept on: ${sectionDetails[index].acptDispOn}",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Container(
                                                  height: 80,
                                                  width: 150,
                                                  child: Lottie.asset(
                                                      'assets/icons/nextstep.json'),
                                                ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );
    });
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sample Details'),
          content: Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Request No: ${detailsList.isNotEmpty ? detailsList[0].sampleCode : ''}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Item: ${detailsList.isNotEmpty ? detailsList[0].itemDescription!.toLowerCase() : ''}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Quantity: ${detailsList.isNotEmpty ? detailsList[0].totalItemQty : ''}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Customer: ${detailsList.isNotEmpty ? detailsList[0].customerName : ''}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                HttpService()
                    .smsJobAccept(
                        detailsList[0].sampleDispatchHeaderID!,
                        26562,
                        detailsList[0].bIsSectionDispatchCompleted!,
                        detailsList[0].sampleDispatchDetailID!,
                        detailsList[0].decSampleDispatchQty!,
                        detailsList[0].dispatchMeasureUnitID!)
                    .then((value) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const HomePage();
                  }));
                });
              },
              child: Text('Accept'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
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
