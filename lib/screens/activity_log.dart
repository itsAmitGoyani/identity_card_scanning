import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:identity_card_scanning/util/app_text_theme.dart';
import 'package:identity_card_scanning/util/color_constants.dart';
import 'package:identity_card_scanning/util/extensions.dart';
import 'package:identity_card_scanning/widgets/rectangle_button.dart';

class ActivityLog extends StatefulWidget {
  const ActivityLog({Key? key}) : super(key: key);

  @override
  State<ActivityLog> createState() => _ActivityLogState();
}

class _ActivityLogState extends State<ActivityLog> {
  DateTime selectedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity Log"),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Activity of ${selectedDateTime.toStandardDate()}",
                        style: AppTextTheme.bodyText18,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: () async {
                        var dateTime = await showDatePicker(
                          context: context,
                          initialDate: selectedDateTime,
                          firstDate: DateTime(2001, 1, 1),
                          lastDate: DateTime.now(),
                        );
                        if (dateTime != null) {
                          setState(() {
                            selectedDateTime = dateTime;
                          });
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 18.h,
                ),
                Row(
                  children: const [
                    Expanded(
                      child: ActivityLogCard(
                        title: "INN",
                        titleColor: Colors.green,
                        male: 10,
                        female: 8,
                        children: 5,
                        vehicle: 17,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ActivityLogCard(
                        title: "OUT",
                        titleColor: Colors.red,
                        male: 8,
                        female: 6,
                        children: 4,
                        vehicle: 13,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: const ActivityLogCard(
                      title: "INSIDE",
                      titleColor: Colors.orange,
                      male: 2,
                      female: 2,
                      children: 1,
                      vehicle: 4,
                    ),
                  ),
                ),
                SizedBox(
                  height: 80.h,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, primaryColor.withOpacity(0.5)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RectangleButton(
                        isLoading: false,
                        text: "Download/Share".toUpperCase(),
                        textColor: Colors.white,
                        buttonColor: primaryColor,
                        onPressed: () async {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityLogCard extends StatelessWidget {
  final String title;
  final Color titleColor;
  final int male, female, children, vehicle;

  const ActivityLogCard({
    Key? key,
    required this.title,
    required this.male,
    required this.female,
    required this.children,
    required this.vehicle,
    required this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextTheme.headline18.copyWith(color: titleColor),
                  ),
                ),
                Text(
                  "${male + female}",
                  style: AppTextTheme.headline18,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Male",
                    style: AppTextTheme.bodyText14,
                  ),
                ),
                Text(
                  "$male",
                  style: AppTextTheme.bodyText14,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Female",
                    style: AppTextTheme.bodyText14,
                  ),
                ),
                Text(
                  "$female",
                  style: AppTextTheme.bodyText14,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Children",
                    style: AppTextTheme.bodyText14,
                  ),
                ),
                Text(
                  "$children",
                  style: AppTextTheme.bodyText14,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Vehicle",
                    style: AppTextTheme.bodyText14,
                  ),
                ),
                Text(
                  "$vehicle",
                  style: AppTextTheme.bodyText14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
