import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(150), width: 0.6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prabowo Pekok',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Prabowo@pekok.com',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 5),
                ),
                child: const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    'https://scontent.fjog3-1.fna.fbcdn.net/v/t39.30808-1/386773642_718330246985113_5729260925684290444_n.png?stp=dst-png_s200x200&_nc_cat=1&ccb=1-7&_nc_sid=2d3e12&_nc_ohc=tq40IofcxKAQ7kNvwG1MKrd&_nc_oc=AdmnwWlHwNZZvgSp8Jbzq_S9X0Afpkgv9spIJn5bwQPTpQeC1esIfzIpJHi5A9EaqDU&_nc_zt=24&_nc_ht=scontent.fjog3-1.fna&_nc_gid=UKKHXTWLZSsjZqcXBW5FQQ&oh=00_AfMQci4RogODi4wMWgCUoC49clplBF8CF47x46BcWYmodg&oe=68548C91',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class ProfileMain extends StatelessWidget {
  const ProfileMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(150), width: 0.6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Prabowo Pekok',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Prabowo@pekok.com',
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 5),
                ),
                child: const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    'https://scontent.fjog3-1.fna.fbcdn.net/v/t39.30808-1/386773642_718330246985113_5729260925684290444_n.png?stp=dst-png_s200x200&_nc_cat=1&ccb=1-7&_nc_sid=2d3e12&_nc_ohc=tq40IofcxKAQ7kNvwG1MKrd&_nc_oc=AdmnwWlHwNZZvgSp8Jbzq_S9X0Afpkgv9spIJn5bwQPTpQeC1esIfzIpJHi5A9EaqDU&_nc_zt=24&_nc_ht=scontent.fjog3-1.fna&_nc_gid=UKKHXTWLZSsjZqcXBW5FQQ&oh=00_AfMQci4RogODi4wMWgCUoC49clplBF8CF47x46BcWYmodg&oe=68548C91',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
