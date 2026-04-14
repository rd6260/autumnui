import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PinterestScreen extends StatelessWidget {
  const PinterestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imageList = [
      "https://i.pinimg.com/736x/6a/de/3d/6ade3d7fd1688f0f3ebd788afb98baaf.jpg",
      "https://i.pinimg.com/736x/59/dd/3a/59dd3a67d5837204144eba86fffc19ef.jpg",
      "https://i.pinimg.com/736x/8c/e4/c0/8ce4c0a67fd7e0fbe62e8edaba4eb519.jpg",
      "https://i.pinimg.com/736x/e4/48/b0/e448b0003fc997c121e32e0b3a1d59d4.jpg",
      "https://i.pinimg.com/736x/45/a7/8d/45a78d0d64a76d2cab2788e0469507a0.jpg",
      "https://i.pinimg.com/736x/79/7b/c5/797bc549ef060414cb89d8e431ef0b1a.jpg",
      "https://i.pinimg.com/736x/15/60/14/156014d9d668239285070155c6712c53.jpg",
      "https://i.pinimg.com/736x/f7/28/6c/f7286cffbbbf68722c213a5697ef404f.jpg",
      "https://i.pinimg.com/736x/69/b7/1e/69b71e3e8699e57cb0f5dfa8444af9e0.jpg",
      "https://i.pinimg.com/1200x/d4/e5/2a/d4e52af0e4d7b59bd5c1f759ae7527ba.jpg",
      "https://i.pinimg.com/736x/98/2a/6f/982a6f793a8a3e2c93484edccd219e9a.jpg",
      "https://i.pinimg.com/736x/5f/d0/aa/5fd0aaf5c79fb691448da33d5af5867f.jpg",
      "https://i.pinimg.com/736x/cd/f1/b1/cdf1b1774b4a99b4336ff9e33be3e5ef.jpg",
      "https://i.pinimg.com/1200x/e0/41/35/e0413517ff936850147d4337c7fa8ddf.jpg",
      "https://i.pinimg.com/1200x/9f/f0/fe/9ff0fe9eca9591a7fdcb103a30573363.jpg",
    ];
    imageList.shuffle();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[800],
              // padding: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
              ),
            ),
          ),
        ],
      ),
      body: MasonryGridView.builder(
        itemCount: imageList.length,
        // padding: EdgeInsets.all(8),
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(20),
            child: Image.network(imageList[index]),
          ),
        ),
      ),
    );
  }
}
