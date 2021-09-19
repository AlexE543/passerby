import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passerby',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(title: 'Passerby'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailFilter = TextEditingController();
  final TextEditingController _passwordFilter = TextEditingController();
  String _email = "";
  String _password = "";
  FormType _form = FormType.login;

  _LoginPageState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  void _formChange() async {
    setState(() {
      if (_form == FormType.register) {
        _form = FormType.login;
      } else {
        _form = FormType.register;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFields() {
    return Column(
      children: <Widget>[
        TextField(
          controller: _emailFilter,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        TextField(
          controller: _passwordFilter,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
        )
      ],
    );
  }

  Widget _buildButtons() {
    if (_form == FormType.login) {
      return Column(
        children: <Widget>[
          RaisedButton(
            child: const Text('Login'),
            onPressed: _loginPressed,
          ),
          FlatButton(
            child: const Text('Dont have an account? Tap here to register.'),
            onPressed: _formChange,
          ),
          FlatButton(
            child: const Text('Forgot Password?'),
            onPressed: _passwordReset,
          )
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          RaisedButton(
            child: const Text('Next'),
            onPressed: _nextPressed,
          ),
          FlatButton(
            child: const Text('Have an account? Click here to login.'),
            onPressed: _formChange,
          )
        ],
      );
    }
  }

  void _loginPressed() {
    print('The user wants to login with $_email and $_password');
  }

  void _nextPressed() {
    print('The user wants to create an accoutn with $_email and $_password');
    print('add user to db');
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActivitySelectionPage(
            email: _email,
          ),
        ));
  }

  void _passwordReset() {
    print("The user wants a password reset request sent to $_email");
  }
}

class ActivitySelectionPage extends StatefulWidget {
  final String email;

  const ActivitySelectionPage({Key? key, required this.email})
      : super(key: key);
  @override
  State<ActivitySelectionPage> createState() => _ActivitySelectionPage();
}

class _ActivitySelectionPage extends State<ActivitySelectionPage> {
  Map<String, bool> activities = {
    'Spikeball': false,
    'Hiking': false,
    'Yoga': false,
    'Biking': false,
    'Reading': false
  };

  void _submitPressed(activities, email) {
    print('Add activites to db');
    print(email);
    print(activities);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activities"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _buildActivityButtons(),
            ElevatedButton(
              onPressed: () {
                _submitPressed(activities, widget.email);
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityButtons() {
    List<Widget> widgets = <Widget>[];
    activities.forEach((k, v) => {
          widgets.add(Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => {
                setState(() {
                  activities[k] = !activities[k]!;
                }),
                print(k)
              },
              style: ButtonStyle(
                  backgroundColor: activities[k]!
                      ? MaterialStateProperty.all<Color>(Colors.blue)
                      : MaterialStateProperty.all<Color>(Colors.green)),
              child: Text(k),
            ),
          ))
        });
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: widgets);
  }
}
