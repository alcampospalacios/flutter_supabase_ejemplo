import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // ensure initialized
  WidgetsFlutterBinding.ensureInitialized();

  // initialize supabase
  await Supabase.initialize(
    url: 'https://bmgddvipkhdvmbcmioec.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJtZ2Rkdmlwa2hkdm1iY21pb2VjIiwicm9sZSI6ImFub24iLCJpYXQiOjE2Nzg2NjA2MjUsImV4cCI6MTk5NDIzNjYyNX0.GNPXNdrKL6-Ho9MsEPfcbbKX9EOd--aqJLnA-G2FeuA',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autenticacion supabase google',
      home: LoginPage(),
      theme: ThemeData.dark().copyWith(
          colorScheme: ThemeData()
              .colorScheme
              .copyWith(primary: const Color(0xFFda5316)),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xFFda5316)),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF202124),
            elevation: 0,
          ),
          scaffoldBackgroundColor: const Color(0xFF121212)),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final supabase = Supabase.instance.client;

  Future<bool> signInWithGoogle() async {
    const redirectTo = 'bmgddvipkhdvmbcmioec.supabase.co://login-callback/';

    return await supabase.auth.signInWithOAuth(
      Provider.google,
      redirectTo: redirectTo,
    );
  }

  @override
  void initState() {
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else if (event == AuthChangeEvent.signedOut) {
        // TODO: Desloguear al usuario
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Login with Google'),
          onPressed: () async {
            await signInWithGoogle();
          },
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const Center(
        child: Text('You are authenticated.'),
      ),
    );
  }
}
