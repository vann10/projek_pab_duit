import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'credit_card.dart';

class CardCarouselWidget extends StatefulWidget {
  const CardCarouselWidget({super.key});

  @override
  State<CardCarouselWidget> createState() => _CardCarouselWidgetState();
}

class _CardCarouselWidgetState extends State<CardCarouselWidget> {
  int _currentCard = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: cardData.length,
          itemBuilder: (context, index, realIndex) {
            return CreditCardWidget(card: cardData[index]);
          },
          options: CarouselOptions(
            height: 210,
            aspectRatio: 16 / 9,
            viewportFraction: 0.85,
            initialPage: 0,
            enableInfiniteScroll: true,
            enlargeCenterPage: true,
            enlargeFactor: 0.15,
            onPageChanged: (index, reason) {
              setState(() {
                _currentCard = index;
              });
            },
          ),
        ),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cardData.asMap().entries.map((entry) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.white)
                    .withOpacity(_currentCard == entry.key ? 0.9 : 0.4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}