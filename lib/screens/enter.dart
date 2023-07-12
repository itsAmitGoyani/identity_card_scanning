import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:identity_card_scanning/bloc/department_bloc/department_bloc.dart';
import 'package:identity_card_scanning/bloc/entry_bloc/entry_bloc.dart';
import 'package:identity_card_scanning/models/enums.dart';
import 'package:identity_card_scanning/screens/login.dart';
import 'package:identity_card_scanning/screens/receipt.dart';
import 'package:identity_card_scanning/services/cnic_scanner.dart';
import 'package:identity_card_scanning/util/app_text_theme.dart';
import 'package:identity_card_scanning/util/color_constants.dart';
import 'package:identity_card_scanning/util/extensions.dart';
import 'package:identity_card_scanning/util/shared_preference.dart';
import 'package:identity_card_scanning/widgets/kdropdown_button_form_field.dart';
import 'package:identity_card_scanning/widgets/ktext_form_field.dart';
import 'package:identity_card_scanning/widgets/rectangle_button.dart';

class Enter extends StatefulWidget {
  const Enter({Key? key}) : super(key: key);

  @override
  State<Enter> createState() => _EnterState();
}

class _EnterState extends State<Enter> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final DepartmentBloc _departmentBloc = DepartmentBloc();
  final EntryBloc _entryBloc = EntryBloc();

  TextEditingController mobileTEController = TextEditingController(),
      nameTEController = TextEditingController(),
      cnicTEController = TextEditingController(),
      dobTEController = TextEditingController(),
      doiTEController = TextEditingController(),
      doeTEController = TextEditingController(),
      addressTEController = TextEditingController(),
      noOfChildrenTEController = TextEditingController(),
      vehicleTEController = TextEditingController();
  DateTime? dateOfBirth, dateOfIssue, dateOfExpiry;
  String? selectedDepartmentId;
  Gender? gender;
  XFile? _frontFile, _backFile;
  bool carryChild = false;
  bool carryVehicle = false;

  @override
  void initState() {
    _departmentBloc.add(GetDepartments());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter to Department"),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: BlocProvider(
            create: (_) => _departmentBloc,
            child: BlocListener<DepartmentBloc, DepartmentState>(
              listener: (context, state) {},
              child: BlocBuilder<DepartmentBloc, DepartmentState>(
                builder: (context, state) {
                  if (state is DepartmentLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DepartmentError) {
                    if (state.error == "Unauthorized") {
                      removeAuthData();
                      removeUsername();
                      Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const Login()),
                          (route) => false);
                    }
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              state.error,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 18.h),
                            RectangleButton(
                              text: "Retry",
                              onPressed: () async {
                                _departmentBloc.add(GetDepartments());
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  } else if (state is DepartmentLoaded) {
                    var departments = state.response;
                    return Stack(
                      children: [
                        ListView(
                          padding: const EdgeInsets.all(16.0),
                          children: [
                            KDropdownButtonFormField(
                              labelText: "Department",
                              hintText: "--select department--",
                              value: selectedDepartmentId,
                              items: departments
                                  .map((e) => DropdownMenuItem<String>(
                                        value: e.id,
                                        child: Text(
                                          e.name,
                                          style: AppTextTheme.bodyText16
                                              .copyWith(color: primaryColor),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedDepartmentId = val;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Please select department";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 18.h),
                            KTextFormField(
                              labelText: "Mobile Number",
                              hintText: "0333-0101010",
                              controller: mobileTEController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter mobile number";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 18.h),
                            Column(
                              children: [
                                RectangleButton(
                                  text: _frontFile == null
                                      ? "Scan CNIC".toUpperCase()
                                      : "Re-Scan CNIC".toUpperCase(),
                                  textColor: Colors.white,
                                  buttonColor: primaryColor,
                                  onPressed: () async {
                                    await captureCnic();
                                  },
                                ),
                              ],
                            ),
                            if (_frontFile != null)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: 18.h),
                                  KTextFormField(
                                    labelText: 'Name',
                                    hintText: 'Enter name',
                                    controller: nameTEController,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return "Please enter name";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(height: 18.h),
                                  KDropdownButtonFormField(
                                    value: gender,
                                    items: [
                                      DropdownMenuItem<Gender>(
                                        value: Gender.male,
                                        child: Text(
                                          "Male",
                                          style: AppTextTheme.bodyText16
                                              .copyWith(color: primaryColor),
                                        ),
                                      ),
                                      DropdownMenuItem<Gender>(
                                        value: Gender.female,
                                        child: Text(
                                          "Female",
                                          style: AppTextTheme.bodyText16
                                              .copyWith(color: primaryColor),
                                        ),
                                      ),
                                    ],
                                    onChanged: (val) {
                                      setState(() {
                                        gender = val;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return "Please select gender";
                                      } else {
                                        return null;
                                      }
                                    },
                                    labelText: "Gender",
                                    hintText: "--select gender--",
                                  ),
                                  SizedBox(height: 18.h),
                                  KTextFormField(
                                    labelText: 'CNIC Number',
                                    hintText: 'Enter CNIC number',
                                    controller: cnicTEController,
                                    textInputAction: TextInputAction.next,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return "Please enter CNIC number";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(height: 18.h),
                                  KTextFormField(
                                    labelText: 'Date of Birth',
                                    hintText: 'Enter date of birth',
                                    readOnly: true,
                                    controller: dobTEController,
                                    textInputAction: TextInputAction.next,
                                    onTap: () async {
                                      var now = DateTime.now();
                                      var firstDate = DateTime(1900, 1, 1);
                                      var selectedDate = await showDatePicker(
                                          context: context,
                                          initialDate: dateOfBirth ?? now,
                                          firstDate: firstDate,
                                          lastDate: now);
                                      if (selectedDate != null) {
                                        setState(() {
                                          dateOfBirth = selectedDate;
                                          dobTEController.text =
                                              selectedDate.toStandardDate();
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return "Please enter date of birth";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(height: 18.h),
                                  KTextFormField(
                                    labelText: 'Date of Card Issue',
                                    hintText: 'Enter date of card issue',
                                    readOnly: true,
                                    controller: doiTEController,
                                    textInputAction: TextInputAction.next,
                                    onTap: () async {
                                      var now = DateTime.now();
                                      var firstDate = DateTime(
                                          now.year - 20, now.month, now.day);
                                      var selectedDate = await showDatePicker(
                                          context: context,
                                          initialDate: dateOfIssue ?? now,
                                          firstDate: firstDate,
                                          lastDate: now);
                                      if (selectedDate != null) {
                                        setState(() {
                                          dateOfIssue = selectedDate;
                                          doiTEController.text =
                                              selectedDate.toStandardDate();
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return "Please enter date of card issue";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(height: 18.h),
                                  KTextFormField(
                                    labelText: 'Date of Card Expiry',
                                    hintText: 'Enter date of card expiry',
                                    readOnly: true,
                                    controller: doeTEController,
                                    textInputAction: TextInputAction.next,
                                    onTap: () async {
                                      var now = DateTime.now();
                                      var lastDate = DateTime(
                                          now.year + 20, now.month, now.day);
                                      var selectedDate = await showDatePicker(
                                          context: context,
                                          initialDate: dateOfExpiry ?? now,
                                          firstDate: now,
                                          lastDate: lastDate);
                                      if (selectedDate != null) {
                                        setState(() {
                                          dateOfExpiry = selectedDate;
                                          doeTEController.text =
                                              selectedDate.toStandardDate();
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return "Please enter date of card expiry";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(height: 18.h),
                                  KTextFormField(
                                    labelText: 'Address',
                                    hintText: 'Enter address',
                                    controller: addressTEController,
                                    minLines: 3,
                                    maxLines: 5,
                                    textInputAction: TextInputAction.done,
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return "Please enter address";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            SizedBox(height: 18.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      "Child:",
                                      style: AppTextTheme.bodyText18,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Radio(
                                                  splashRadius: 0,
                                                  value: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      carryChild =
                                                          value as bool;
                                                    });
                                                  },
                                                  groupValue: carryChild,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                Text(
                                                  "Yes",
                                                  style:
                                                      AppTextTheme.bodyText16,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Radio(
                                                  splashRadius: 0,
                                                  value: false,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      carryChild =
                                                          value as bool;
                                                    });
                                                  },
                                                  groupValue: carryChild,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                Text(
                                                  "No",
                                                  style:
                                                      AppTextTheme.bodyText16,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (carryChild)
                                        KTextFormField(
                                          hintText: "No. of children",
                                          controller: noOfChildrenTEController,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter no. of children";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 18.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      "Vehicle:",
                                      style: AppTextTheme.bodyText18,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Radio(
                                                  splashRadius: 0,
                                                  value: true,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      carryVehicle =
                                                          value as bool;
                                                    });
                                                  },
                                                  groupValue: carryVehicle,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                Text(
                                                  "Yes",
                                                  style:
                                                      AppTextTheme.bodyText16,
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Radio(
                                                  splashRadius: 0,
                                                  value: false,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      carryVehicle =
                                                          value as bool;
                                                    });
                                                  },
                                                  groupValue: carryVehicle,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                Text(
                                                  "No",
                                                  style:
                                                      AppTextTheme.bodyText16,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (carryVehicle)
                                        KTextFormField(
                                          hintText: "Vehicle number",
                                          controller: vehicleTEController,
                                          textInputAction: TextInputAction.next,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter vehicle number";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 80.h),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  primaryColor.withOpacity(0.5)
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: BlocProvider(
                                    create: (_) => _entryBloc,
                                    child: BlocListener<EntryBloc, EntryState>(
                                      listener: (context, state) {
                                        if (state is EntryError) {
                                          if (state.error == "Unauthorized") {
                                            removeAuthData();
                                            removeUsername();
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        const Login()),
                                                (route) => false);
                                          }
                                          Fluttertoast.showToast(
                                              msg: state.error);
                                        } else if (state is EntryLoaded) {
                                          Fluttertoast.showToast(
                                              msg: "Entry saved successfully");
                                          Navigator.pushReplacement(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) => Receipt(
                                                    receiptId: state
                                                        .response.receiptId)),
                                          );
                                        }
                                      },
                                      child: BlocBuilder<EntryBloc, EntryState>(
                                        builder: (context, state) {
                                          return RectangleButton(
                                            isLoading: false,
                                            text: "Save".toUpperCase(),
                                            textColor: Colors.white,
                                            buttonColor: primaryColor,
                                            onPressed: () async {
                                              if (_formKey.currentState
                                                      ?.validate() ??
                                                  false) {
                                                if (_frontFile == null ||
                                                    _backFile == null) {
                                                  Fluttertoast.showToast(
                                                      msg: "Scan CNIC to save");
                                                } else {
                                                  _entryBloc
                                                      .add(SendEntryRequest(
                                                    departmentId:
                                                        selectedDepartmentId!,
                                                    mobileNumber:
                                                        mobileTEController.text,
                                                    name: nameTEController.text,
                                                    address: addressTEController
                                                        .text,
                                                    cnic: cnicTEController.text,
                                                    gender:
                                                        gender! == Gender.male
                                                            ? "Male"
                                                            : "Female",
                                                    children: carryChild
                                                        ? int.parse(
                                                            noOfChildrenTEController
                                                                .text)
                                                        : null,
                                                    vehicle: carryVehicle
                                                        ? vehicleTEController
                                                            .text
                                                        : null,
                                                    dateOfBirth: dateOfBirth!,
                                                    dateOfIssue: dateOfIssue!,
                                                    dateOfExpiry: dateOfExpiry!,
                                                  ));
                                                }
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> captureCnic() async {
    try {
      ImageSource? frontImageSource = await showScanDialog("front-side");
      if (frontImageSource == null) {
        Fluttertoast.showToast(msg: "Scanning canceled");
        return;
      }
      XFile? frontFile = await _picker.pickImage(source: frontImageSource);
      if (frontFile == null) {
        Fluttertoast.showToast(msg: "Scanning canceled");
        return;
      }
      var cnicModel = await CnicScanner().scanCnic(filePath: frontFile.path);

      ImageSource? backImageSource = await showScanDialog("back-side");
      if (backImageSource == null) {
        Fluttertoast.showToast(msg: "Scanning canceled");
        return;
      }
      XFile? backFile = await _picker.pickImage(source: backImageSource);
      if (backFile == null) {
        Fluttertoast.showToast(msg: "Scanning canceled");
        return;
      }
      setState(() {
        nameTEController.text = cnicModel.holderName;
        cnicTEController.text = cnicModel.identityNumber;
        var tempDateOfBirth = stringToDateTime(cnicModel.dateOfBirth);
        if (tempDateOfBirth != null) {
          dobTEController.text = tempDateOfBirth.toStandardDate();
          dateOfBirth = tempDateOfBirth;
        } else {
          dobTEController.text = "";
          dateOfBirth = null;
        }

        var tempDateOfIssue = stringToDateTime(cnicModel.issueDate);
        if (tempDateOfIssue != null) {
          doiTEController.text = tempDateOfIssue.toStandardDate();
          dateOfIssue = tempDateOfIssue;
        } else {
          doiTEController.text = "";
          dateOfIssue = null;
        }

        var tempDateOfExpiry = stringToDateTime(cnicModel.expiryDate);
        if (tempDateOfExpiry != null) {
          doeTEController.text = tempDateOfExpiry.toStandardDate();
          dateOfExpiry = tempDateOfExpiry;
        } else {
          doeTEController.text = "";
          dateOfExpiry = null;
        }

        gender = cnicModel.gender;
        _frontFile = frontFile;
        _backFile = backFile;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
      return;
    }
  }

  Future<ImageSource?> showScanDialog(String side) async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'CNIC Scanner',
                  style: AppTextTheme.headline20,
                ),
                SizedBox(
                  height: 15.h,
                ),
                Text(
                  'Please select any option to scan $side',
                  style: AppTextTheme.bodyText16,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 22.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RectangleButton(
                      text: "Camera".toUpperCase(),
                      onPressed: () async {
                        Navigator.pop(context, ImageSource.camera);
                      },
                    ),
                    RectangleButton(
                      text: "Gallery".toUpperCase(),
                      onPressed: () async {
                        Navigator.pop(context, ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  DateTime? stringToDateTime(String str) {
    try {
      var dateList = str.split('/');
      if (dateList.length == 3) {
        return DateTime(int.parse(dateList[2]), int.parse(dateList[1]),
            int.parse(dateList[0]));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
