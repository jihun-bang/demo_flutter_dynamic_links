import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Links Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Dynamic Links Test App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String text = '';

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  void setData(PendingDynamicLinkData? data) {
    setState(() {
      if (data != null) {
        final link = data.link.toString();
        if (link.contains('detail')) {
          final strings = link.split('detail/');
          text = '다이나믹링크로 실행\n${Uri.decodeComponent(strings.last)}';
        } else {
          text = '다이나믹링크로 실행\n${data.asMap()}';
        }
      } else {
        text = '일반 실행';
      }
    });
  }

  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    setData(data);

    dynamicLinks.onLink.listen((data) {
      setData(data);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Text(text),
        ));
  }
}
