import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:path_mobile/ui/core/app_theme.dart';
import 'package:path_mobile/ui/core/page_frame.dart';

class CropFotoScreen extends StatefulWidget {
  final Uint8List image;

  const CropFotoScreen({super.key, required this.image});

  @override
  State<CropFotoScreen> createState() => _CropFotoScreenState();
}

class _CropFotoScreenState extends State<CropFotoScreen> {
  final _controller = CropController();
  bool _isCropping = false;

  void _onCropped(CropResult result) {
    if (!mounted) return;

    switch (result) {
      case CropSuccess(:final croppedImage):
        Navigator.of(context).pop(croppedImage);
      case CropFailure(:final cause):
        debugPrint('Crop gagal: $cause');
        setState(() => _isCropping = false);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Foto gagal dipotong')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BackTitleRow(title: 'Potong Foto'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Crop(
              image: widget.image,
              controller: _controller,
              onCropped: _onCropped,
              withCircleUi: true,
              progressIndicator: const CircularProgressIndicator(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _isCropping
                    ? null
                    : () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(foregroundColor: AppColors.text),
                child: const Text('Batal'),
              ),
              const SizedBox(width: 16),
              FilledButton(
                onPressed: _isCropping
                    ? null
                    : () {
                        setState(() => _isCropping = true);
                        _controller.crop();
                      },
                style: FilledButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                ),
                child: _isCropping
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Pakai'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
