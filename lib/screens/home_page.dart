import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

///StatefulWidget SmsHomePage
class SmsHomePage extends StatefulWidget {
  const SmsHomePage({super.key});

  @override
  State<SmsHomePage> createState() => _SmsHomePageState();
}

class _SmsHomePageState extends State<SmsHomePage> {
  ///FormState Variable to manage the various formstates and facilitate proper data submission
  final _formKey = GlobalKey<FormState>();
  String? number;
  String? messageToBeSent;

  static const platform = MethodChannel('com.example.sms/sendSMS');

  Future<bool> sendSMS(BuildContext context) async {
    _formKey.currentState!.save();

    if (_formKey.currentState!.validate()) {
      if (!(await Permission.sms.isGranted)) {
        var status = await Permission.sms.request();
        if (!status.isGranted) {
          // Permission denied by user
          return false;
        }
      }
      try {
        await platform.invokeMethod(
            'sendSMS', {'phoneNumber': number, 'message': messageToBeSent});

        if (context.mounted) {
          ///A scaffold to show if the message was sent successfully
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Message sent successfully!',
              ),
              backgroundColor: Colors.green[300],
            ),
          );
        }
        _formKey.currentState!.reset();
      } on PlatformException catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$e',
              ),
              backgroundColor: Colors.red[200],
            ),
          );
        }

        _formKey.currentState!.reset();
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text(
          'Sms Sender',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: (value) {
                  number = value;
                },
                validator: (value) {
                  ///Function to validate the data before submission
                  if (value!.isEmpty || value.length < 12) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    hintText: 'Enter mobile number (Start with country code)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    )),
                    contentPadding: EdgeInsets.all(10)),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                onSaved: (value) {
                  messageToBeSent = value;
                },
                validator: (value) {
                  ///Function to validate the data before submission
                  if (value!.isEmpty) {
                    return 'Invalid input';
                  }
                  return null;
                },
                maxLines: 4,
                decoration: const InputDecoration(
                    hintText: 'Message to be sent',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    )),
                    contentPadding: EdgeInsets.all(10)),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    sendSMS(context);
                  },
                  child: const Text('Send now'))
            ],
          ),
        ),
      ),
    );
  }
}
