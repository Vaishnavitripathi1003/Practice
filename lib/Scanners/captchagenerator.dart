import 'dart:math';
import 'package:flutter/material.dart';

class CaptchaScreen extends StatefulWidget {
  @override
  _CaptchaScreenState createState() => _CaptchaScreenState();
}

class _CaptchaScreenState extends State<CaptchaScreen> {
  late String _captchaText;
  late TextEditingController _captchaController;
  late bool _isCaptchaCorrect;
  late bool _showError;

  @override
  void initState() {
    super.initState();
    _generateAndSetCaptcha();
    _captchaController = TextEditingController();
    _isCaptchaCorrect = false;
    _showError = false;
  }

  void _generateAndSetCaptcha() {
    setState(() {
      _captchaText = _generateCaptcha();
      _isCaptchaCorrect = false; // Reset validation
      _showError = false; // Hide error
    });
  }

  String _generateCaptcha() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  void _validateCaptcha() {
    setState(() {
      _isCaptchaCorrect = _captchaController.text.toLowerCase() == _captchaText.toLowerCase();
      _showError = !_isCaptchaCorrect; // Show error if CAPTCHA is incorrect
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CAPTCHA Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Please enter the following CAPTCHA:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            Text(
              _captchaText,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _captchaController,
              decoration: InputDecoration(
                labelText: 'Enter CAPTCHA',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _isCaptchaCorrect = false; // Reset validation
                  _showError = false; // Hide error when text changes
                });
              },
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _generateAndSetCaptcha,
                  child: Text('Regenerate CAPTCHA'),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    _validateCaptcha();
                    if (_isCaptchaCorrect) {
                      // CAPTCHA is correct, do something
                      print('CAPTCHA is correct!');
                    } else {
                      // CAPTCHA is incorrect, show error
                      print('CAPTCHA is incorrect!');
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
            if (_showError)
              SizedBox(height: 10.0),
            if (_showError)
              Text(
                'Incorrect CAPTCHA! Please try again.',
                style: TextStyle(color: Colors.red),
              ),
            if (_isCaptchaCorrect)
              SizedBox(height: 10.0),
            if (_isCaptchaCorrect)
              Text(
                'CAPTCHA is correct!',
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _captchaController.dispose();
    super.dispose();
  }
}
