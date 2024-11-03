import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:naturub/Models/company.dart';
import 'package:naturub/Models/productionBoxModel.dart';
import 'package:naturub/Models/sectionModel.dart';
import 'package:naturub/lightColor.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../Models/productionModel.dart';
import '../../Service/apiservice.dart';
import '../Main/home_screen.dart';

class ProductBoxAssign extends StatefulWidget {
  const ProductBoxAssign({Key? key}) : super(key: key);

  @override
  State<ProductBoxAssign> createState() => _ProductBoxAssignState();
}

class _ProductBoxAssignState extends State<ProductBoxAssign> {
  QRViewController? controller;
  Barcode? result;
  List<BoxModel> boxList = [];
  List<ProductionModel> detailsList = [];
  List<Section> sectionsList = [];
  List<Section> packingsectionsList = [];
  List<ProductionModel> jobList = [];
  List<Company> comList = [];
  List<ProductionModel> jobDetails = [];
  List<int> selectedJobIDs = [];
  int? selectedMCID;
  int? sectionID;
  int? jobID;
  int? companyID;
  int? psectionID;
  bool isLoading = true;
  bool isApiCallMade = false;
  bool ScannerOpen = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  void initState() {
    super.initState();
    fetchCompany();
  }

  Future<void> fetchJobs() async {
    try {
      final jobLists =
          await HttpService().getJobListStart(sectionID!, selectedMCID!);
      setState(() {
        jobList = jobLists;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching machines: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchCompany() async {
    try {
      final comLists = await HttpService().getCompany();
      setState(() {
        comList = comLists;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching machines: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchPackingSection() async {
    try {
      final machines = await HttpService().getPackingSection();
      setState(() {
        packingsectionsList = machines;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching machines: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchJobDetailsForSelectedJobs() async {
    setState(() {
      isLoading = true;
    });

    for (int jobID in selectedJobIDs) {
      try {
        final jobLists = await HttpService().getJobDetailsForActualStart(jobID);
        setState(() {
          jobDetails.addAll(
              jobLists); // Assuming jobLists is a list, otherwise use add if it's a single object
        });
      } catch (e) {
        print('Error fetching job details for Job ID $jobID: $e');
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchMachines() async {
    try {
      final machines = await HttpService().getMachineUsingSection(sectionID!);
      setState(() {
        detailsList = machines;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching machines: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchSection() async {
    try {
      final machines = await HttpService().getSection();
      setState(() {
        sectionsList = machines;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching machines: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScannerOpen == true ? _buildQRView() : _buildBoxAssignView();
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

  Widget _loadingIndicator() {
    return const Center(child: CircularProgressIndicator());
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
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                        child: DropdownSearch<int>(
                      popupProps: PopupProps.dialog(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.5),
                            ),
                            hintText: 'Search Company',
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                        itemBuilder: (context, int item, bool isSelected) {
                          var machine = comList.firstWhere(
                            (machine) => machine.companyID == item,
                          );
                          return ListTile(
                            title: Text(machine.company),
                            selected: isSelected,
                          );
                        },
                      ),
                      items:
                          comList.map((machine) => machine.companyID!).toList(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Select Sections",
                          labelStyle: TextStyle(color: Colors.blue),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      selectedItem: sectionID,
                      dropdownBuilder: (context, selectedItem) {
                        var machine = comList.firstWhere(
                          (item) => item.companyID == selectedItem,
                          orElse: () => Company(companyID: 0, company: ""),
                        );

                        return Text(
                          machine.companyID != 0
                              ? machine.company
                              : "Select Company",
                          style: TextStyle(color: Colors.black),
                        );
                      },
                      filterFn: (int item, String? searchValue) {
                        var machine = comList.firstWhere(
                          (machine) => machine.companyID == item,
                          orElse: () => Company(companyID: 0, company: ""),
                        );

                        return machine.company!
                            .contains(searchValue!.toLowerCase());
                      },
                      onChanged: (int? newValue) {
                        setState(() {
                          companyID = newValue;
                          fetchPackingSection();
                        });
                        print('Selected Company ID: $newValue');
                      },
                    )),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: DropdownSearch<int>(
                        popupProps: PopupProps.dialog(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1.5),
                              ),
                              hintText: 'Search Section',
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          itemBuilder: (context, int item, bool isSelected) {
                            var machine = packingsectionsList.firstWhere(
                              (machine) => machine.sECTIONID == item,
                            );
                            return ListTile(
                              title: Text(machine.sECTIONNAME!),
                              selected: isSelected,
                            );
                          },
                        ),
                        items: packingsectionsList
                            .map((machine) => machine.sECTIONID!)
                            .toList(),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Select Packing Section",
                            labelStyle: TextStyle(color: Colors.blue),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 2),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                        selectedItem: sectionID,
                        dropdownBuilder: (context, selectedItem) {
                          var machine = packingsectionsList.firstWhere(
                            (item) => item.sECTIONID == selectedItem,
                            orElse: () =>
                                Section(sECTIONID: 0, sECTIONNAME: ""),
                          );

                          return Text(
                            machine.sECTIONID != 0
                                ? machine.sECTIONNAME!
                                : "Packing Section",
                            style: TextStyle(color: Colors.black),
                          );
                        },
                        filterFn: (int item, String? searchValue) {
                          var machine = packingsectionsList.firstWhere(
                            (machine) => machine.sECTIONID == item,
                            orElse: () =>
                                Section(sECTIONID: 0, sECTIONNAME: ""),
                          );

                          return machine.sECTIONNAME!
                              .contains(searchValue!.toLowerCase());
                        },
                        onChanged: (int? newValue) {
                          setState(() {
                            psectionID = newValue;
                            fetchSection();
                          });
                          print('Selected Machine ID: $newValue');
                        },
                      ),
                    )
                  ]),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DropdownSearch<int>(
                          popupProps: PopupProps.dialog(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 1.5),
                                ),
                                hintText: 'Search Section',
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            itemBuilder: (context, int item, bool isSelected) {
                              var machine = sectionsList.firstWhere(
                                (machine) => machine.sECTIONID == item,
                              );
                              return ListTile(
                                title: Text(machine.sECTIONNAME!),
                                selected: isSelected,
                              );
                            },
                          ),
                          items: sectionsList
                              .map((machine) => machine.sECTIONID!)
                              .toList(),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Select Production Sections",
                              labelStyle: TextStyle(color: Colors.blue),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          selectedItem: sectionID,
                          dropdownBuilder: (context, selectedItem) {
                            var machine = sectionsList.firstWhere(
                              (item) => item.sECTIONID == selectedItem,
                              orElse: () =>
                                  Section(sECTIONID: 0, sECTIONNAME: ""),
                            );

                            return Text(
                              machine.sECTIONID != 0
                                  ? machine.sECTIONNAME!
                                  : "Select Section",
                              style: TextStyle(color: Colors.black),
                            );
                          },
                          filterFn: (int item, String? searchValue) {
                            var machine = sectionsList.firstWhere(
                              (machine) => machine.sECTIONID == item,
                              orElse: () =>
                                  Section(sECTIONID: 0, sECTIONNAME: ""),
                            );

                            return machine.sECTIONNAME!
                                .contains(searchValue!.toLowerCase());
                          },
                          onChanged: (int? newValue) {
                            setState(() {
                              sectionID = newValue;
                              fetchMachines();
                            });
                            print('Selected Machine ID: $newValue');
                          },
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: DropdownSearch<int>(
                          popupProps: PopupProps.dialog(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 1.5),
                                ),
                                hintText: 'Search Machine by Code',
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            itemBuilder: (context, int item, bool isSelected) {
                              var machine = detailsList.firstWhere(
                                (machine) => machine.intMCID == item,
                              );
                              return ListTile(
                                title: Text(machine.vcMCCODE),
                                selected: isSelected,
                              );
                            },
                          ),
                          items: detailsList
                              .map((machine) => machine.intMCID)
                              .toList(),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Select Machine",
                              labelStyle: TextStyle(color: Colors.blue),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          selectedItem: selectedMCID,
                          dropdownBuilder: (context, selectedItem) {
                            var machine = detailsList.firstWhere(
                              (item) => item.intMCID == selectedItem,
                              orElse: () => ProductionModel(
                                intJobID: 0,
                                vcJobNo: '',
                                machineBarcode: '',
                                intMCPlanID: 0,
                                decAllocQty: 0.0,
                                decOutPut: 0.0,
                                decWPM: 0.0,
                                intNoofTapes: 0,
                                intMCCounterCount: 0,
                                decMCCounterRate: 0.0,
                                intMCID: 0,
                                vcMCCODE: '',
                                companyID: 0,
                              ),
                            );

                            return Text(
                              machine.intMCID != 0
                                  ? machine.vcMCCODE
                                  : "Select Machine",
                              style: TextStyle(color: Colors.black),
                            );
                          },
                          filterFn: (int item, String? searchValue) {
                            var machine = detailsList.firstWhere(
                              (machine) => machine.intMCID == item,
                              orElse: () => ProductionModel(
                                intJobID: 0,
                                vcJobNo: '',
                                machineBarcode: '',
                                intMCPlanID: 0,
                                decAllocQty: 0.0,
                                decOutPut: 0.0,
                                decWPM: 0.0,
                                intNoofTapes: 0,
                                intMCCounterCount: 0,
                                decMCCounterRate: 0.0,
                                intMCID: 0,
                                vcMCCODE: '',
                                companyID: 0,
                              ),
                            );

                            return machine.vcMCCODE
                                .toLowerCase()
                                .contains(searchValue!.toLowerCase());
                          },
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedMCID = newValue;
                              fetchJobs();
                            });
                            print('Selected Machine ID: $newValue');
                          },
                        ),
                      ),
                      SizedBox(width: 5), // Space between dropdown and icon
                      IconButton(
                        icon: Icon(
                          Icons.barcode_reader,
                          size: 40,
                        ),
                        color: Colors.amber,
                        onPressed: () {
                          _startBarcodeScanning();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  DropdownSearch<int>.multiSelection(
                    popupProps: PopupPropsMultiSelection.dialog(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 1.5),
                          ),
                          hintText: 'Search Job by Job Number',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      itemBuilder: (context, int item, bool isSelected) {
                        var job = jobList.firstWhere(
                          (job) => job.intJobID == item,
                        );
                        return ListTile(
                          title: Text(job.vcJobNo ?? "Unknown Job"),
                          selected: isSelected,
                        );
                      },
                    ),
                    items: jobList.map((job) => job.intJobID).toList(),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Select Jobs",
                        labelStyle: TextStyle(color: Colors.blue),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                    selectedItems:
                        selectedJobIDs, // Use the list of selected job IDs
                    dropdownBuilder: (context, List<int>? selectedItems) {
                      if (selectedItems != null && selectedItems.isNotEmpty) {
                        final selectedJobs = selectedItems
                            .map((id) => jobList
                                .firstWhere((job) => job.intJobID == id)
                                .vcJobNo)
                            .join(', ');
                        return Text(
                          selectedJobs,
                          style: TextStyle(color: Colors.black),
                        );
                      }
                      return Text(
                        "Select Jobs",
                        style: TextStyle(color: Colors.black),
                      );
                    },
                    filterFn: (int item, String? searchValue) {
                      var job = jobList.firstWhere(
                        (job) => job.intJobID == item,
                        orElse: () => ProductionModel(
                          intJobID: 0,
                          vcJobNo: '',
                          machineBarcode: '',
                          intMCPlanID: 0,
                          decAllocQty: 0.0,
                          decOutPut: 0.0,
                          decWPM: 0.0,
                          intNoofTapes: 0,
                          intMCCounterCount: 0,
                          decMCCounterRate: 0.0,
                          intMCID: 0,
                          vcMCCODE: '',
                          companyID: 0,
                        ),
                      );

                      return job.vcJobNo!
                          .toLowerCase()
                          .contains(searchValue!.toLowerCase());
                    },
                    onChanged: (List<int>? newValues) {
                      setState(() {
                        selectedJobIDs = newValues ?? [];
                        fetchJobDetailsForSelectedJobs();
                      });
                      print('Selected Job IDs: $selectedJobIDs');
                    },
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 140,
                    child: ListView.builder(
                      itemCount: jobDetails.length,
                      itemBuilder: (context, index) {
                        final jobDetail = jobDetails[index];

                        return Card(
                          margin: EdgeInsets.all(10),
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: "Allocated Qty",
                                          labelStyle:
                                              TextStyle(color: Colors.blue),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue, width: 1.5),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1.5),
                                          ),
                                        ),
                                        controller: TextEditingController(
                                            text: jobDetail.decAllocQty
                                                .toString()),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: "MC Counter Rate",
                                          labelStyle:
                                              TextStyle(color: Colors.blue),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue, width: 1.5),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1.5),
                                          ),
                                        ),
                                        controller: TextEditingController(
                                            text: jobDetail.decMCCounterRate
                                                .toString()),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: "MC OutPut",
                                          labelStyle:
                                              TextStyle(color: Colors.blue),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue, width: 1.5),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1.5),
                                          ),
                                        ),
                                        controller: TextEditingController(
                                            text:
                                                jobDetail.decOutPut.toString()),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: "WPM",
                                          labelStyle:
                                              TextStyle(color: Colors.blue),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue, width: 1.5),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1.5),
                                          ),
                                        ),
                                        controller: TextEditingController(
                                            text: jobDetail.decWPM.toString()),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: "MC Counter Count",
                                          labelStyle:
                                              TextStyle(color: Colors.blue),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue, width: 1.5),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1.5),
                                          ),
                                        ),
                                        controller: TextEditingController(
                                            text: jobDetail.intMCCounterCount
                                                .toString()),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          labelText: "No of Tape",
                                          labelStyle:
                                              TextStyle(color: Colors.blue),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blue, width: 1.5),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          disabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1.5),
                                          ),
                                        ),
                                        controller: TextEditingController(
                                            text: jobDetail.intNoofTapes
                                                .toString()),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add_box_rounded,
                          size: 40,
                        ), // Use your desired barcode scanner icon
                        color: Colors.amber,
                        onPressed: () {
                          _startBarcodeScanning();
                        },
                      ),
                      Text(
                        'Box Adding',
                        style: TextStyle(
                            fontSize: 28,
                            fontFamily: "Teko",
                            color: Colors.grey),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      height: 140,
                      child: ListView.builder(
                          itemCount: boxList.length,
                          itemBuilder: (context, index) {
                            final box = boxList[index];
                            return Card(
                                color: Colors.white,
                                margin: EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text('Box No: ${box.intBoxNo}'),
                                  subtitle: Text(
                                      'Weight: ${box.decBoxWeight} kg\nPartitions: ${box.intNoOfPartition}'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteBox(box.intBoxID),
                                  ),
                                ));
                          })),
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
            ),
          ),
        ));
  }

  Future<void> _save() async {
    setState(() {
      isLoading = true;
    });

    // Create a new list to store the resulting BoxModels
    List<BoxModel> boxLists = [];

    // Iterate over each job
    jobDetails.forEach((job) {
      // For each job, iterate over each box
      boxList.forEach((box) {
        // Create a new BoxModel object with updated properties
        BoxModel updatedBox = BoxModel(
            intBoxID: box.intBoxID,
            intBoxNo: box.intBoxNo,
            decBoxWeight: box.decBoxWeight,
            intNoOfPartition: box.intNoOfPartition,
            barcode: box.barcode,
            intMCPlanID: job.intMCPlanID, // Assign job's intMCPlanID
            intMCID: selectedMCID!, // Assign job's intMCID
            companyID: companyID,
            toSection: psectionID,
            sectionID: sectionID);

        // Add the updated box to the list
        boxLists.add(updatedBox);
      });
    });

    try {
      final machines = await HttpService().saveBoxAssign(boxLists);
      setState(() {
        selectedJobIDs = [];
        selectedMCID = 0;
        jobDetails = [];
        boxList = [];
        boxLists = [];
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
    selectedJobIDs = [];
    selectedMCID = 0;
    jobDetails = [];
    boxList = [];
    print('Clear button pressed');
  }

  void deleteBox(int id) {
    setState(() {
      boxList.removeWhere((box) => box.intBoxID == id);
    });
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
      try {
        // Get the list of BoxModel objects from the API call
        final List<BoxModel> boxLists =
            await HttpService().getBoxDetails(result.code.toString());

        setState(() {
          // Iterate over each BoxModel in the retrieved list
          for (var box in boxLists) {
            // Check if the current box already exists in the boxList
            if (!boxList.any((item) => item.intBoxID == box.intBoxID)) {
              boxList.add(box);
            }
          }

          if (boxList.isEmpty) {
            showToastWidget(
              const Text('No box found', selectionColor: Colors.red),
              duration: const Duration(seconds: 5),
              context: context,
            );
            ScannerOpen = false;
          } else {
            ScannerOpen = false;
          }
        });
      } catch (e) {
        // Handle any errors that might occur during the API call
        print('Error calling getBoxDetails: $e');
      }
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
                                  "Box Assign",
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
