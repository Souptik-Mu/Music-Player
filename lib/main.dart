import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Music Player'),
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(child: NowPlayingView()),
      ),
    );
  }
}

class NowPlayingView extends StatefulWidget {
  const NowPlayingView({super.key});
  @override
  State<NowPlayingView> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlayingView> {
  bool _isPlaying = false;

  Future<void> _togglePlayPause() async {
    final endpoint = _isPlaying ? 'pause' : 'play';
    final response = await http.post(Uri.parse('http://localhost:8000/$endpoint')); //sends request.
    if (response.statusCode == 200) {
      setState(() {
        _isPlaying = !_isPlaying;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: IconButton(
          icon: Icon(
            _isPlaying ? Icons.play_arrow_rounded : Icons.pause_rounded, // ned to be swapped
          ),
          onPressed: _togglePlayPause,
          tooltip: _isPlaying ? 'Pause' : 'Play',
          color: _isPlaying ? Colors.green : Colors.red,
          //color: Colors.blue,
          iconSize: 50.0,
        ),
      ),
    );
  }
}
