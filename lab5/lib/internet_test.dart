import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class SpeedTest extends StatefulWidget {
  const SpeedTest({super.key});

  @override
  State<SpeedTest> createState() => _SpeedTestState();
}

class _SpeedTestState extends State<SpeedTest> {
  String downloadResult = 'Press button to start download test';
  String uploadResult = 'Press button to start upload test';
  bool testingDownload = false;
  bool testingUpload = false;

  Future<void> _testDownload() async {
    const url = 'https://link.testfile.org/PDF10MB';

    setState(() {
      testingDownload = true;
      downloadResult = 'Downloading...';
    });

    final stopwatch = Stopwatch()..start();
    int totalBytes = 0;

    try {
      final request = await HttpClient().getUrl(Uri.parse(url));
      final response = await request.close();

      if (response.statusCode != 200) {
        setState(() {
          downloadResult = 'Error: HTTP ${response.statusCode}';
          testingDownload = false;
        });
        return;
      }

      await for (var chunk in response) {
        totalBytes += chunk.length;
      }

      stopwatch.stop();
      final seconds = stopwatch.elapsedMilliseconds / 1000;
      final speedMbps = (totalBytes * 8) / (seconds * 1000000);

      setState(() {
        downloadResult = 'Download Speed: ${speedMbps.toStringAsFixed(2)} Mbps';
      });
    } catch (e) {
      setState(() {
        downloadResult = 'Download error: $e';
      });
    } finally {
      setState(() {
        testingDownload = false;
      });
    }
  }

  Future<void> _testUpload() async {
    const url = 'https://speed.cloudflare.com/__upl';
    final data = _generateTestData(5 * 1024 * 1024); // 5 MB

    setState(() {
      testingUpload = true;
      uploadResult = 'Uploading...';
    });

    final stopwatch = Stopwatch()..start();
    bool success = false;

    try {
      final request = await HttpClient().postUrl(Uri.parse(url));
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/octet-stream');
      request.add(data);

      final response = await request.close();
      await response.drain();
      success = true;
    } catch (e) {
      setState(() {
        uploadResult = 'Upload error: $e';
      });
    } finally {
      stopwatch.stop();
    }

    if (success) {
      final seconds = stopwatch.elapsedMilliseconds / 1000;
      final speedMbps = (data.length * 8) / (seconds * 1000000);
      setState(() {
        uploadResult = 'Upload Speed: ${speedMbps.toStringAsFixed(2)} Mbps';
      });
    }

    setState(() {
      testingUpload = false;
    });
  }

  Uint8List _generateTestData(int byteCount) {
    final rand = Random();
    return Uint8List.fromList(List<int>.generate(byteCount, (_) => rand.nextInt(256)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speed Test'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(downloadResult, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: testingDownload ? null : _testDownload,
                child: Text(testingDownload ? 'Testing Download...' : 'Start Download Test'),
              ),
            ),
            const SizedBox(height: 32),
            Text(uploadResult, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: testingUpload ? null : _testUpload,
                child: Text(testingUpload ? 'Testing Upload...' : 'Start Upload Test'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}