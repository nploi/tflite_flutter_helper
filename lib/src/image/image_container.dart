import 'package:camera/camera.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/src/image/base_image_container.dart';
import 'package:tflite_flutter_helper/src/image/image_conversions.dart';
import 'package:tflite_flutter_helper/src/tensorbuffer/tensorbuffer.dart';
import 'package:tflite_flutter_helper/src/image/color_space_type.dart';

class ImageContainer extends BaseImageContainer {
  late final Image _image;

  ImageContainer._(Image image) {
    this._image = image;
  }

  static ImageContainer create(Image image) {
    return ImageContainer._(image);
  }

  @override
  BaseImageContainer clone() {
    return create(_image.clone());
  }

  @override
  ColorSpaceType get colorSpaceType {
    bool isGrayscale = true;
    for (int y = 0; y < _image.height; y++) {
      for (int x = 0; x < _image.width; x++) {
        final pixel = _image.getPixel(x, y);
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;
        if (r != g || g != b) {
          isGrayscale = false;
          break;
        }
      }
      if (!isGrayscale) break;
    }
    if (isGrayscale) {
      return ColorSpaceType.GRAYSCALE;
    } else {
      return ColorSpaceType.RGB;
    }
  }

  @override
  TensorBuffer getTensorBuffer(int dataType) {
    TensorBuffer buffer = TensorBuffer.createDynamic(dataType);
    ImageConversions.convertImageToTensorBuffer(image, buffer);
    return buffer;
  }

  @override
  int get height => _image.height;

  @override
  Image get image => _image;

  @override
  CameraImage get mediaImage => throw UnsupportedError(
      'Converting from Image to CameraImage is unsupported');

  @override
  int get width => _image.width;
}
