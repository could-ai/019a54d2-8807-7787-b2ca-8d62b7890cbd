import 'package:flutter/material.dart';
import '../models/connection_state.dart';

class ConnectionButton extends StatelessWidget {
  final VPNConnectionState connectionState;
  final VoidCallback onPressed;

  const ConnectionButton({
    super.key,
    required this.connectionState,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: connectionState == VPNConnectionState.connecting ||
              connectionState == VPNConnectionState.disconnecting
          ? null
          : onPressed,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: _getGradient(),
          boxShadow: [
            BoxShadow(
              color: _getColor().withOpacity(0.4),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIcon(),
                size: 50,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                _getText(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _getGradient() {
    switch (connectionState) {
      case VPNConnectionState.connected:
        return const LinearGradient(
          colors: [Color(0xFF00C853), Color(0xFF00E676)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case VPNConnectionState.connecting:
      case VPNConnectionState.disconnecting:
        return LinearGradient(
          colors: [Colors.orange.shade600, Colors.orange.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case VPNConnectionState.disconnected:
      default:
        return LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Color _getColor() {
    switch (connectionState) {
      case VPNConnectionState.connected:
        return const Color(0xFF00C853);
      case VPNConnectionState.connecting:
      case VPNConnectionState.disconnecting:
        return Colors.orange;
      case VPNConnectionState.disconnected:
      default:
        return Colors.blue;
    }
  }

  IconData _getIcon() {
    switch (connectionState) {
      case VPNConnectionState.connected:
        return Icons.power_outlined;
      case VPNConnectionState.connecting:
      case VPNConnectionState.disconnecting:
        return Icons.sync;
      case VPNConnectionState.disconnected:
      default:
        return Icons.power_settings_new;
    }
  }

  String _getText() {
    switch (connectionState) {
      case VPNConnectionState.connected:
        return 'Connected';
      case VPNConnectionState.connecting:
        return 'Connecting...';
      case VPNConnectionState.disconnecting:
        return 'Disconnecting...';
      case VPNConnectionState.disconnected:
      default:
        return 'Connect';
    }
  }
}
