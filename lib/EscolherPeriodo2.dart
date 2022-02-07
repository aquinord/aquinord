/// Flutter code sample for showDateRangePicker

// This sample demonstrates how to create a restorable Material date range picker.
// This is accomplished by enabling state restoration by specifying
// [MaterialApp.restorationScopeId] and using [Navigator.restorablePush] to
// push [DateRangePickerDialog] when the button is tapped.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';




//void main() => runApp(const MyApp());

/// This is the main application widget.
class EscolherPeriodo extends StatelessWidget {
  const EscolherPeriodo({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      title: "Defesa Civil de Ouro Preto",
      home: MyStatefulWidget(restorationId: 'main'),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('pt', 'BR'), // Hebrew
        // ... other locales the app supports
      ],

    );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key, this.restorationId}) : super(key: key);

  final String? restorationId;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
/// RestorationProperty objects can be used because of RestorationMixin.
class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with RestorationMixin {
  // In this example, the restoration ID for the mixin is passed in through
  // the [StatefulWidget]'s constructor.
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTimeN _startDate =
  RestorableDateTimeN(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day-5));
  final RestorableDateTimeN _endDate =
  RestorableDateTimeN(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
  late final RestorableRouteFuture<DateTimeRange?>
  _restorableDateRangePickerRouteFuture =
  RestorableRouteFuture<DateTimeRange?>(
    onComplete: _selectDateRange,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator
          .restorablePush(_dateRangePickerRoute, arguments: <String, dynamic>{
        'initialStartDate': _startDate.value?.millisecondsSinceEpoch,
        'initialEndDate': _endDate.value?.millisecondsSinceEpoch,
      });
    },
  );

  void _selectDateRange(DateTimeRange? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _startDate.value = newSelectedDate.start;
        _endDate.value = newSelectedDate.end;
      });
    }
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_startDate, 'start_date');
    registerForRestoration(_endDate, 'end_date');
    registerForRestoration(
        _restorableDateRangePickerRouteFuture, 'date_picker_route_future');
  }

  static Route<DateTimeRange?> _dateRangePickerRoute(
      BuildContext context,
      Object? arguments,
      ) {
    return DialogRoute<DateTimeRange?>(
      context: context,
      builder: (BuildContext context) {
        return DateRangePickerDialog(
          restorationId: 'date_picker_dialog',
          initialDateRange:
          _initialDateTimeRange(arguments! as Map<dynamic, dynamic>),
          firstDate: DateTime(2021, 1, 1),
          currentDate: DateTime(2021, 1, 25),
          lastDate: DateTime(2022, 1, 1),
        );
      },
    );
  }

  static DateTimeRange? _initialDateTimeRange(Map<dynamic, dynamic> arguments) {
    if (arguments['initialStartDate'] != null &&
        arguments['initialEndDate'] != null) {
      return DateTimeRange(
        start: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialStartDate'] as int),
        end: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialEndDate'] as int),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  //leading: Icon(Icons.arrow_drop_down_circle),
                    title: Text("Período 1",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,

                        //fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text("Início: " + DateFormat('dd-MM-yyyy').format(DateTime.now()) + "\nFim: "+
                        DateFormat('dd-MM-yyyy').format(DateTime.now()))
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IntrinsicHeight(
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () {


                          _restorableDateRangePickerRouteFuture.present(
                              Locale('pt','BR')

                          );
                        },
                        child: const Text('Alterar'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            elevation: 2,
            child: Column(
              children: [
                ListTile(
                  //leading: Icon(Icons.arrow_drop_down_circle),
                    title: Text("Período 2",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,

                        //fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text("Início: " + DateFormat('dd-MM-yyyy').format(DateTime.now()) + "\nFim: "+
                        DateFormat('dd-MM-yyyy').format(DateTime.now()))
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IntrinsicHeight(
                    child: Center(
                      child: OutlinedButton(
                        onPressed: () {


                          _restorableDateRangePickerRouteFuture.present(
                              Locale('pt','BR')

                          );
                        },
                        child: const Text('Alterar'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),







          Text(_startDate.value.toString()),
          Text(_endDate.value.toString()),

          Text("final"),
          Center(
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
                //Navigator.pop(context);

              },
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}