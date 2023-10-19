import 'package:flutter/material.dart';

class ArticleItem extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final int index;
  const ArticleItem({super.key, required this.snapshot, required this.index});

  @override
  Widget build(BuildContext context) {
    print(snapshot.data[index]);
    return Column(
      children: [
        Image.network("https://velog.velcdn.com/images/thdrldud369/post/718b171f-0916-4f32-a8a4-7548e0c0d08b/image.png"),
        Text(snapshot.data[index]["contents"]),
        Divider(
          color: Colors.black.withOpacity(0.2),
          thickness: 1.0,
        )
      ],
    );
  }
}