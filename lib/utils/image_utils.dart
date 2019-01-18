import 'package:flutter/material.dart';

enum ImageType {
  zero,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  bomb,
  facingDown,
  flagged,
}

Image getImage(ImageType type) {
  switch (type) {
    case ImageType.zero:
      return Image.asset('assets/images/0.png');
    case ImageType.one:
      return Image.asset('assets/images/1.png');
    case ImageType.two:
      return Image.asset('assets/images/2.png');
    case ImageType.three:
      return Image.asset('assets/images/3.png');
    case ImageType.four:
      return Image.asset('assets/images/4.png');
    case ImageType.five:
      return Image.asset('assets/images/5.png');
    case ImageType.six:
      return Image.asset('assets/images/6.png');
    case ImageType.seven:
      return Image.asset('assets/images/7.png');
    case ImageType.eight:
      return Image.asset('assets/images/8.png');
    case ImageType.bomb:
      return Image.asset('assets/images/bomb.png');
    case ImageType.facingDown:
      return Image.asset('assets/images/facingDown.png');
    case ImageType.flagged:
      return Image.asset('assets/images/flagged.png');
    default:
      return null;
  }
}

ImageType getImageTypeFromNumber(int number) {
  switch (number) {
    case 0:
      return ImageType.zero;
    case 1:
      return ImageType.one;
    case 2:
      return ImageType.two;
    case 3:
      return ImageType.three;
    case 4:
      return ImageType.four;
    case 5:
      return ImageType.five;
    case 6:
      return ImageType.six;
    case 7:
      return ImageType.seven;
    case 8:
      return ImageType.eight;
    default:
      return null;
  }
}