import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Phone Field Example'),
        ),
        // body:  SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       ...List.generate(20, (_)=>ListTile(title: Text('data'),))
        //     ],
        //   ),
        // ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30),
                IntlPhoneField(
                  initialCountryCode: 'INVALID',
                  decoration: const InputDecoration(
                    labelText: ' Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  spacing: 10,
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                IntlPhoneField(
                  initialCountryCode: 'NG',
                  initialValue: '08034339010',
                  decoration: const InputDecoration(
                    labelText: ' Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  spacing: 10,
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                IntlPhoneField(
                  initialCountryCode: 'NG',
                  initialValue: '+2348034339010',
                  decoration: const InputDecoration(
                    labelText: ' Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  spacing: 10,
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                ),
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    _formKey.currentState?.validate();
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
