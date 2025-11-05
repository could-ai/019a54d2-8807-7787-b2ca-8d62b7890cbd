import 'package:flutter/material.dart';
import 'dart:async';
import '../models/connection_state.dart';
import '../widgets/connection_button.dart';
import '../widgets/connection_status.dart';
import '../widgets/server_info.dart';
import '../widgets/stats_display.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  VPNConnectionState _connectionState = VPNConnectionState.disconnected;
  String _currentServer = 'United States';
  String _ipAddress = '---';
  Duration _connectionDuration = Duration.zero;
  Timer? _timer;
  late AnimationController _pulseController;

  double _downloadSpeed = 0.0;
  double _uploadSpeed = 0.0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleConnection() {
    if (_connectionState == VPNConnectionState.disconnected) {
      _connect();
    } else if (_connectionState == VPNConnectionState.connected) {
      _disconnect();
    }
  }

  void _connect() async {
    setState(() {
      _connectionState = VPNConnectionState.connecting;
    });

    // Simulate connection process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _connectionState = VPNConnectionState.connected;
      _ipAddress = '192.168.${(100 + (DateTime.now().millisecond % 50))}.${(10 + (DateTime.now().millisecond % 240))}';
      _connectionDuration = Duration.zero;
    });

    // Start connection timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _connectionDuration = Duration(seconds: _connectionDuration.inSeconds + 1);
        // Simulate speed fluctuation
        _downloadSpeed = 5.0 + (DateTime.now().millisecond % 50) / 10;
        _uploadSpeed = 2.0 + (DateTime.now().millisecond % 30) / 10;
      });
    });
  }

  void _disconnect() async {
    setState(() {
      _connectionState = VPNConnectionState.disconnecting;
    });

    _timer?.cancel();
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _connectionState = VPNConnectionState.disconnected;
      _ipAddress = '---';
      _connectionDuration = Duration.zero;
      _downloadSpeed = 0.0;
      _uploadSpeed = 0.0;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {},
                  ),
                  const Text(
                    'CXZVPN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // Connection Status
                      ConnectionStatus(
                        connectionState: _connectionState,
                        pulseController: _pulseController,
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Connection Button
                      ConnectionButton(
                        connectionState: _connectionState,
                        onPressed: _toggleConnection,
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Server Info
                      ServerInfo(
                        server: _currentServer,
                        ipAddress: _ipAddress,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Connection Duration
                      if (_connectionState == VPNConnectionState.connected)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.timer_outlined,
                                color: Colors.white70,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatDuration(_connectionDuration),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      const SizedBox(height: 20),
                      
                      // Stats Display
                      if (_connectionState == VPNConnectionState.connected)
                        StatsDisplay(
                          downloadSpeed: _downloadSpeed,
                          uploadSpeed: _uploadSpeed,
                        ),
                      
                      const SizedBox(height: 30),
                      
                      // Features
                      _buildFeaturesList(),
                      
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      children: [
        _buildFeatureItem(
          icon: Icons.flash_on,
          title: 'Lightning Fast',
          description: 'Optimized servers for maximum speed',
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          icon: Icons.security,
          title: 'Secure & Private',
          description: 'Military-grade encryption',
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          icon: Icons.language,
          title: 'Global Network',
          description: 'Servers in 50+ countries',
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
