import 'package:flutter/material.dart';
import '../models/connection_state.dart';

class ConnectionStatus extends StatelessWidget {
  final VPNConnectionState connectionState;
  final AnimationController pulseController;

  const ConnectionStatus({
    super.key,
    required this.connectionState,
    required this.pulseController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Animated pulse effect for connected state
        if (connectionState == VPNConnectionState.connected)
          AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              return Container(
                width: 100 + (pulseController.value * 20),
                height: 100 + (pulseController.value * 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.2 - (pulseController.value * 0.15)),
                ),
              );
            },
          ),
        
        // Status icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getStatusColor().withOpacity(0.2),
            border: Border.all(
              color: _getStatusColor(),
              width: 3,
            ),
          ),
          child: Icon(
            _getStatusIcon(),
            color: _getStatusColor(),
            size: 40,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Status text
        Text(
          _getStatusText(),
          style: TextStyle(
            color: _getStatusColor(),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Status description
        Text(
          _getStatusDescription(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (connectionState) {
      case VPNConnectionState.connected:
        return Colors.green;
      case VPNConnectionState.connecting:
      case VPNConnectionState.disconnecting:
        return Colors.orange;
      case VPNConnectionState.disconnected:
      default:
        return Colors.red;
    }
  }

  IconData _getStatusIcon() {
    switch (connectionState) {
      case VPNConnectionState.connected:
        return Icons.check_circle;
      case VPNConnectionState.connecting:
      case VPNConnectionState.disconnecting:
        return Icons.sync;
      case VPNConnectionState.disconnected:
      default:
        return Icons.shield_outlined;
    }
  }

  String _getStatusText() {
    switch (connectionState) {
      case VPNConnectionState.connected:
        return 'Protected';
      case VPNConnectionState.connecting:
        return 'Connecting';
      case VPNConnectionState.disconnecting:
        return 'Disconnecting';
      case VPNConnectionState.disconnected:
      default:
        return 'Not Protected';
    }
  }

  String _getStatusDescription() {
    switch (connectionState) {
      case VPNConnectionState.connected:
        return 'Your connection is secure';
      case VPNConnectionState.connecting:
        return 'Establishing secure connection';
      case VPNConnectionState.disconnecting:
        return 'Closing connection';
      case VPNConnectionState.disconnected:
      default:
        return 'Tap below to connect';
    }
  }
}
