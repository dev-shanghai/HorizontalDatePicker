import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_date_picker/date_helper.dart';
import 'package:horizontal_date_picker/date_row.dart';
import 'package:swipedetector/swipedetector.dart';

class HorizontalDatePicker extends StatefulWidget {
  HorizontalDatePicker(
      {@required this.inintialDate,
      this.height = _height,
      this.builder,
      this.onDateChoosen});
  Duration after = _after;
  Duration before = _before;
  DateTime inintialDate;
  double height;

  /// defualt after value
  static const Duration _after = Duration(days: 2);

  /// defualt before value
  static const Duration _before = Duration(days: 2);

  ///defualt height
  static const double _height = 50;

  ///builder[RawDateBuilder]
  RawDateBuilder builder;

  ///on date choosen
  OnDateChoosen onDateChoosen;
  @override
  State<StatefulWidget> createState() {
    return _HorizontalDateState();
  }
}

class _HorizontalDateState extends State<HorizontalDatePicker> {
  ///size of the date picker in days
  int size;
  int initalDateIndex;
  DateTime initialDate;
  @override
  void initState() {
    super.initState();
    size = widget.after.inDays + widget.before.inDays + 1;
    initalDateIndex = widget.after.inDays;
    initialDate = widget.inintialDate;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxConstraint) {
        print('width : '+boxConstraint.maxWidth.toString());
        return SwipeDetector(
          onSwipeLeft: () {
            setState(() {
              initialDate = initialDate.add(Duration(days: 1));
              widget.onDateChoosen(initialDate);
            });

            print('leftSwip');
          },
          onSwipeRight: () {
            setState(() {
              initialDate = initialDate.add(Duration(days: -1));
              widget.onDateChoosen(initialDate);
            });
            print('rightSwip');
          },
          child: Container(
            height: widget.height,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, i) {
                return widget.builder(context, i,
                    getCurrentDate(i, initalDateIndex, initialDate),boxConstraint.maxWidth/5);
/*             DateRow(getCurrentDate(i, initalDateIndex, initialDate))
 */
              },
            ),
          ),
          swipeConfiguration: SwipeConfiguration(
              horizontalSwipeMaxHeightThreshold: 100.0,
              horizontalSwipeMinDisplacement: 50.0,
              horizontalSwipeMinVelocity: 100.0),
        );
      },
    );
  }
}

typedef RawDateBuilder = Widget Function(
    BuildContext context, int index, DateTime rawDateTime,double maxWidth);
typedef OnDateChoosen = void Function(DateTime dateChoosen);
