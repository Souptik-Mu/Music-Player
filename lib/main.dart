import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String path = '';
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  Future<void> _togglePlayPause() async {
    final endpoint = 'path';

    if (path.isEmpty) {
      final response = await http.get(
        Uri.parse('http://localhost:8000/$endpoint'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        path = data['path'];
        await _audioPlayer.play(DeviceFileSource(path));
      }
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      await _audioPlayer.resume();
    } else {
      await _audioPlayer.pause();
    }
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    _audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _position = Duration.zero; // Reset position when playback completes
      });
    });
  }

  //TODO: Add a slider to display song duration and playback position
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          children: [
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
              onPressed: _togglePlayPause,
              tooltip: _isPlaying ? 'Pause' : 'Play',
              color: _isPlaying ? Colors.red : Colors.green,
              //color: Colors.blue,
              iconSize: 50.0,
            ),
            Slider(
              min: 0,
              max: _duration.inSeconds.toDouble(),
              value: _position.inSeconds
                  .clamp(0, _duration.inSeconds)
                  .toDouble(),
              onChanged: (_duration > Duration.zero)
                  ? (val) async {
                      final pos = Duration(seconds: val.toInt());
                      await _audioPlayer.seek(pos);
                      setState(() {
                        _position = pos;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
