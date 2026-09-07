import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:vocabulary_tracker/features/auth/presentation/auth_screen.dart';
import 'package:vocabulary_tracker/features/dashboard/presentation/dashboard_screen.dart';

import 'package:vocabulary_tracker/helpers.dart';

class RegisterState extends State<RegisterScreen> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _username = '';
  String _email = '';
  String _password = '';
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),
          child: Form(
            key: _formGlobalKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // heading
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Register',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),

                // username
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLength: 255,
                    decoration: InputDecoration(
                      label: Text('Username'),
                      errorMaxLines: 3,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username can\'t be empty';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value!;
                    },
                  ),
                ),

                // email address
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    maxLength: 255,
                    decoration: InputDecoration(
                      label: Text('Email Address'),
                      errorMaxLines: 3,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email Address can\'t be empty';
                      }
                      if (!AuthHelpers.isValidEmail(value)) {
                        return 'Invalid Email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                ),

                // password
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: _obscureText,
                    keyboardType: TextInputType.visiblePassword,

                    enableSuggestions: false,
                    autocorrect: false,
                    autofillHints: const [
                      AutofillHints.password,
                    ], // Enable operating system / manager password autofilling

                    maxLength: 255,
                    decoration: InputDecoration(
                      label: Text('Password'),
                      errorMaxLines: 3,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password can\'t be empty';
                      }
                      if (value.length < 8) {
                        return 'Password must be atleast 8 characters long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                ),

                // submit button
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                    onPressed: () async {
                      if (_formGlobalKey.currentState!.validate()) {
                        _formGlobalKey.currentState!.save();
                        print('form submitted');

                        String result = await Authentication(
                          AppDatabase.instance,
                        ).register(_username, _email, _password);

                        setState(() {
                          if (result == 'success') {
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DashboardScreen(),
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              // Show the backend error message (e.g., 'Email already in use') via SnackBar
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(result)));
                            }
                          }
                        });
                        _formGlobalKey.currentState!.reset();
                      }
                    },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Register'),
                  ),
                ),

                // login link
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.topRight,
                    child: LinkText(
                      text: 'Already have an account? ',
                      linkText: 'Login Now!',
                      linkWidget: LoginScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginState extends State<LoginScreen> {
  final _formGlobalKey = GlobalKey<FormState>();

  String _username = '';
  String _password = '';
  bool _obscureText = true;

  List<Object> _error = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),
          child: Form(
            key: _formGlobalKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // heading
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),

                // username
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLength: 255,
                    decoration: InputDecoration(
                      label: Text('Username'),
                      errorMaxLines: 3,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username can\'t be empty';
                      }
                      if (_error.contains('User not found')) {
                        _error.remove('User not found');
                        return 'User not found';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _username = value!;
                    },
                  ),
                ),

                // password
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    obscureText: _obscureText,
                    keyboardType: TextInputType.visiblePassword,

                    enableSuggestions: false,
                    autocorrect: false,
                    autofillHints: const [
                      AutofillHints.password,
                    ], // Enable operating system / manager password autofilling

                    maxLength: 255,
                    decoration: InputDecoration(
                      label: Text('Password'),
                      errorMaxLines: 3,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password can\'t be empty';
                      }
                      if (value.length < 8) {
                        return 'Password must be atleast 8 characters long';
                      }
                      if (_error.contains('Incorrect password')) {
                        _error.remove('Incorrect password');
                        return 'Incorrect password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                ),

                // submit button
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                    onPressed: () async {
                      if (_formGlobalKey.currentState!.validate()) {
                        _formGlobalKey.currentState!.save();
                        print('form submitted');

                        String result = await Authentication(
                          AppDatabase.instance,
                        ).login(_username, _password);

                        setState(() {
                          if (result == 'success') {
                            _error.clear();
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DashboardScreen(),
                                ),
                              );
                            }
                          } else {
                            _error.add(result);
                            if (context.mounted) {
                              // Show the backend error message (e.g., 'Email already in use') via SnackBar
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(result)));
                            }
                          }
                        });

                        _formGlobalKey.currentState!.reset();
                      }
                    },
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                    ),
                    child: const Text('Register'),
                  ),
                ),

                // register link
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.topRight,
                    child: LinkText(
                      text: 'No account? ',
                      linkText: 'Register Now!',
                      linkWidget: RegisterScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LinkText extends StatelessWidget {
  const LinkText({
    super.key,
    this.text,
    this.linkText,
    this.linkWidget = const RegisterScreen(),
  });
  final String? text;
  final String? linkText;
  final Widget linkWidget;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        children: [
          TextSpan(text: text),
          TextSpan(
            text: linkText,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline, // Makes it look like a link
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (context) => linkWidget),
                );
                // Your navigation or action goes here
              },
          ),
        ],
      ),
    );
  }
}
