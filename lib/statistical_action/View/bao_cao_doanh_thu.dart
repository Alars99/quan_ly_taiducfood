import 'package:flutter/material.dart';

class BaoCaoDoanhThuScreen extends StatefulWidget {
  @override
  _BaoCaoDoanhThuScreenState createState() => _BaoCaoDoanhThuScreenState();
}

class _BaoCaoDoanhThuScreenState extends State<BaoCaoDoanhThuScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Doanh thu theo ngày",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        ),
      ),
    );
  }
}
