import 'package:flutter/material.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:naturub/Screens/Login/login_screen.dart';
import '../../../constants.dart';

class WelcomeImage extends StatefulWidget {
  const WelcomeImage({Key? key}) : super(key: key);

  @override
  _WelcomeImageState createState() => _WelcomeImageState();
}

class _WelcomeImageState extends State<WelcomeImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Duration connectionTimer = Duration.zero;
  String connectionStatus = "Disconnected";
  int downSpeed = 0;
  int upSpeed = 0;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Establish the SSL VPN connection
    _initializeVpnConnection();

    // Navigate to the Login screen after a delay
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  // Function to initialize the VPN connection
  Future<void> _initializeVpnConnection() async {
    try {
      final result = await FlutterVpn.connectIPSec(
          server: '202.65.172.162', // Replace with your VPN server address
          username: 'NAB-VPN', // Replace with your VPN username
          password: '#Naturub',
          port: 443,
          secret: '');
      setState(() {
        connectionStatus = "Connected";
      });
    } catch (e) {
      setState(() {
        connectionStatus = "Connection Failed";
      });
      print('Failed to connect: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _disconnectVpn(); // Disconnect from VPN when the widget is disposed
    super.dispose();
  }

  // Function to disconnect from VPN
  Future<void> _disconnectVpn() async {
    try {
      await FlutterVpn.disconnect();
      setState(() {
        connectionStatus = "Disconnected";
      });
    } catch (e) {
      print('Failed to disconnect: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    late final Animation<double> _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    return Column(
      children: [
        const SizedBox(height: defaultPadding * 8),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: FadeTransition(
                opacity: _animation,
                child: Image.asset(
                  "assets/images/NaturubLogo.png",
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding * 12),
        // Display connection status
        Text(
          "VPN Status: $connectionStatus",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: "Teko",
            color: Color.fromARGB(255, 27, 59, 85),
          ),
        ),
        Text(
          "Download Speed: $downSpeed KB/s | Upload Speed: $upSpeed KB/s",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: "Teko",
            color: Color.fromARGB(255, 27, 59, 85),
          ),
        ),
        const Text(
          "© Naturub IT Bangladesh 2024",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: "Teko",
            color: Color.fromARGB(255, 27, 59, 85),
          ),
        ),
      ],
    );
  }
}
