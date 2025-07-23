import 'package:flutter/material.dart';

Widget chatWidget({required String title, required String message}) {
  return Container(
    height: 100,
    width: double.infinity,
    margin: EdgeInsets.all(11),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 40,
            ),
            SizedBox(width: 11),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22)),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '12:00 PM',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "2",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        )
      ],
    ),
  );
}
