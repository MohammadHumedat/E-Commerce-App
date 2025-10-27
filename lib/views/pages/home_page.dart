import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://media.istockphoto.com/id/1457536828/photo/japanese-young-man-enjoy-traveling-alone.webp?a=1&s=612x612&w=0&k=20&c=S4hwiclbLQV2aMlztJVdjUuXEAMhYuuw2ifKERrAw44=',
                          ),
                          radius: 25,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mohammad Hmedat',
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Text(
                              'Let\'s go shopping!',
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(fontSize: 15, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ), // Row 1
                    Row(
                      // Row 2
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
