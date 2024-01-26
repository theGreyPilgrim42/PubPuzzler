import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    required this.errorMessage,
  });

  final String errorMessage;
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.error,
            size: 50,
          ),
          const SizedBox(height: 10),
          Text(
            "An error occured!",
            style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            errorMessage,
            style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 14),
          ),
        ],
      ),
    );
  }
}