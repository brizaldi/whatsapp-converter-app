import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _phoneNumberController;
  TextEditingController _textMessageController;

  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    _textMessageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _textMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Whatsapp Converter'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
        child: Form(
          key: _formKey,
          child: _formContent(),
        ),
      ),
    );
  }

  Widget _formContent() {
    return Column(
      children: [
        TextFormField(
          controller: _phoneNumberController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: 'Phone number',
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please input phone number';
            } else if (!_isValidPhoneNumber(value)) {
              return 'Please input a valid phone number';
            }
            return null;
          },
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: _textMessageController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            labelText: '(Optional) Message',
          ),
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState.validate()) _send();
          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(240, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Text(
            'Send Message',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _send() async {
    final String phoneNumber = _phoneNumberController.text;
    final String text = _textMessageController.text;
    final String link = _parseMessage(
      phoneNumber: phoneNumber,
      text: text,
    );

    if (link != null) await launch('$link');
  }

  String _parseMessage({@required String phoneNumber, String text}) {
    final sb = StringBuffer('https://wa.me/');

    phoneNumber =
        phoneNumber.replaceAll(RegExp(r'\D'), '').replaceAll(RegExp('^0+'), '');

    print(phoneNumber);

    if (phoneNumber.isNotEmpty) {
      if (phoneNumber.length <= 2 || phoneNumber.substring(0, 2) != '62')
        phoneNumber = "+62" + phoneNumber;

      print(phoneNumber);

      sb.write(phoneNumber);

      if (text != null) {
        sb..write('?text=')..write(Uri.encodeComponent(text));
      }
      return sb.toString();
    } else {
      _showErrorMessage("Please input phone number");
      return null;
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(message),
      ),
    );
  }

  bool _isValidPhoneNumber(String string) {
    if (string == null || string.isEmpty) {
      return false;
    }

    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(string)) {
      return false;
    }
    return true;
  }
}
