
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WalletConnect connector;
  SessionStatus? session;
  String? account;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    connector = WalletConnect(
      bridge: 'https://b.bridge.walletconnect.org', // Updated bridge URL
      clientMeta: const PeerMeta(
        name: 'WalletConnect',
        description: 'WalletConnect Developer App',
        url: 'https://walletconnect.org',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );

    connector.on('connect', (session) {
      setState(() {
        account = (session as SessionStatus).accounts[0];
      });
      log('Connected: $account');
    });

    connector.on('session_update', (payload) {
      setState(() {
        account = (payload as SessionStatus).accounts[0];
      });
      log('Session updated: $account');
    });

    connector.on('disconnect', (session) {
      setState(() {
        account = null;
      });
      log('Disconnected');
    });
  }

  Future<void> connectWallet() async {
    // Create a connector
    final connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: PeerMeta(
        name: 'WalletConnect',
        description: 'WalletConnect Developer App',
        url: 'https://walletconnect.org',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );

// Subscribe to events
    connector.on('connect', (session) => print(session));
    connector.on('session_update', (payload) => print(payload));
    connector.on('disconnect', (session) => print(session));

// Create a new session
    if (connector.connected) {
      final session = await connector.createSession(
        chainId: 1, // Ethereum Mainnet
        onDisplayUri: (uri) async {
          log(uri);
          final _url = "https://metamask.app.link/wc?uri=$uri";
          log(_url);
          if (!await launch(_url, forceSafariVC: false)) {
            if (!await launch(_url)) {
              throw 'Could not launch $_url';
            }
          }
        },
      );
      log(session.accounts[0]);
    } else {
      final session = await connector.createSession(
        chainId: 1, // Ethereum Mainnet
        onDisplayUri: (uri) async {
          log(uri);
          final _url = "https://metamask.app.link/wc?uri=$uri";
          log(_url);
          if (!await launch(_url, forceSafariVC: false)) {
            if (!await launch(_url)) {
              throw 'Could not launch $_url';
            }
          }
        },
      );
      log(session.accounts[0]);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MetaMask Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: connectWallet,
                child: const Text('Connect Wallet'),
              ),
              const SizedBox(height: 30),
              if (account != null)
                Text('Address: $account', style: const TextStyle(fontSize: 20)),
              if (errorMessage != null)
                Text(errorMessage!, style: const TextStyle(fontSize: 16, color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
