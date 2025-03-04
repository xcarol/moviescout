import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moviescout/widgets/app_bar.dart';
import 'package:moviescout/widgets/app_drawer.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _looginController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _looginController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _looginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        context: context,
        title: AppLocalizations.of(context)!.loginTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: back,
            tooltip: AppLocalizations.of(context)!.back,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Center(child: loginBody()),
    );
  }

  back() async {
    Navigator.pop(context);
  }

  loginBody() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.loginDescription,
        ),
        const SizedBox(height: 8),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: TextField(
            controller: _looginController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          ),
        ),
        const SizedBox(height: 8),
        FractionallySizedBox(
          widthFactor: 0.9,
          child: TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {},
          child: Text(AppLocalizations.of(context)!.login),
        ),
      ],
    );
  }
}
