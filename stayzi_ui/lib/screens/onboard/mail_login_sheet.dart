import 'package:flutter/material.dart';
import 'package:stayzi_ui/screens/onboard/get_info_screen.dart';
import 'package:stayzi_ui/screens/onboard/widgets/basic_button.dart';
import 'package:stayzi_ui/screens/onboard/widgets/form_widget.dart';

// kullanıcı eğer maille giriş yapmak isterse alttan açılan bu sheet ile giris yapacak..
//Yeni bir sayfa değil mevcut sayfada alttan açılan bir bar şeklinde olacak.
class MailLogInSheet extends StatefulWidget {
  const MailLogInSheet({super.key});

  @override
  State<MailLogInSheet> createState() => _MailLogInSheetState();
}

class _MailLogInSheetState extends State<MailLogInSheet> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkFormValid() {
    setState(() {
      _isButtonEnabled =
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkFormValid);
    _passwordController.addListener(_checkFormValid);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          MediaQuery.of(
            context,
          ).viewInsets, // Klavye açıldığında otomatik padding
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Log in with Email",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            FormWidget(hintText: 'Email', controller: _emailController),
            const SizedBox(height: 20),
            FormWidget(
              hintText: 'Password',
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButtonWidget(
                buttonText: 'Log in',
                buttonColor: Color.fromRGBO(213, 56, 88, 1),
                textColor: Colors.white,
                onPressed:
                    _isButtonEnabled
                        ? () {
                          Navigator.pop(context); //shetti kapatmak icin
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GetInfoScreen(),
                            ),
                          );
                        }
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
