import 'package:flutter/material.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;

  const RatingBar({
    super.key,
    required this.rating,
    this.size = 20,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          // 完整星星
          return Icon(Icons.star, size: size, color: color);
        } else if (index < rating.ceil() && rating % 1 != 0) {
          // 半颗星星
          return Icon(Icons.star_half, size: size, color: color);
        } else {
          // 空心星星
          return Icon(Icons.star_border, size: size, color: color);
        }
      }),
    );
  }
}

class RatingInput extends StatefulWidget {
  final double initialRating;
  final ValueChanged<double> onRatingChanged;
  final double size;

  const RatingInput({
    super.key,
    this.initialRating = 0,
    required this.onRatingChanged,
    this.size = 32,
  });

  @override
  State<RatingInput> createState() => _RatingInputState();
}

class _RatingInputState extends State<RatingInput> {
  double _currentRating = 0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _currentRating = index + 1.0;
            });
            widget.onRatingChanged(_currentRating);
          },
          child: Icon(
            index < _currentRating.floor()
                ? Icons.star
                : index < _currentRating.ceil() && _currentRating % 1 != 0
                    ? Icons.star_half
                    : Icons.star_border,
            size: widget.size,
            color: Colors.amber,
          ),
        );
      }),
    );
  }
}