import 'package:flutter/material.dart';

class NotfoundWidget extends StatelessWidget {
  final double size;

  const NotfoundWidget({Key? key, this.size = 50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Aligning the text in the center of the Stack
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Data Tidak Ada',
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10), // Spacing between texts
              const Text(
                'ops! nampaknya tidak ada data untuk ini.',
                style: TextStyle(
                  fontSize: 25,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}


 //   child: Text(
          //   "Meal not found",
          //   style: TextStyle(fontSize: 24),
          // )