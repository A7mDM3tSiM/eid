# Emirates ID Scanner

The `emirates_id_scanner` package provides a seamless and efficient way to scan and extract data from Emirates ID cards using Google ML Kit. This package is designed to simplify the process of ID scanning in applications, making it a valuable tool for any app that requires data extraction.

## Features

- **Camera Overlay Preview**: Includes a built-in camera overlay that helps users capture the ID card image accurately. The overlay guides the user to position the ID card correctly, ensuring optimal image capture for data extraction.
- **ID Section Cropping**: After capturing the image, the package automatically crops the relevant ID section, focusing on the critical data areas of the Emirates ID card.

- **Data Extraction and Processing**: Utilizes advanced Google Machine Learning OCR technology to scan and extract data from the ID card. The extracted data is then processed and returned as a structured model, making it easy to integrate into your application.

- **Customizable Workflow**: Offers flexibility in its implementation, allowing you to customize the scanning and data extraction flow to suit your app's specific needs and user experience requirements.

## Requirements

### iOS

- Minimum iOS Deployment Target: 12.0
- Xcode: Version 13.2.1 or newer
- Swift Version: Swift 5
- Architecture Support: ML Kit does not support 32-bit architectures (i386 and armv7). It supports 64-bit architectures (x86_64 and arm64). [Check this list](https://developers.google.com/ml-kit) to see if your device has the required device capabilities.

> Excluding 32-bit Architectures: Since ML Kit does not support 32-bit architectures, you need to exclude armv7 architectures in Xcode to run `flutter build ios` or `flutter build ipa`.
>
> - Go to Project > Runner > Building Settings > Excluded Architectures > Any SDK > armv7

1. Your Podfile should include:

```ruby
platform :ios, '12.0'  # or newer version

...

# add this line:
$iOSVersion = '12.0'  # or newer version

post_install do |installer|
  # add these lines:
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=*]"] = "armv7"
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $iOSVersion
  end

  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)

    # add these lines:
    target.build_configurations.each do |config|
      if Gem::Version.new($iOSVersion) > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = $iOSVersion
      end
    end

  end
end
```

2. Add two rows to the ios/Runner/Info.plist:

- one with the key Privacy - Camera Usage Description and a usage description.
- and one with the key Privacy - Microphone Usage Description and a usage description.
  If editing Info.plist as text, add:

```
<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
<key>NSMicrophoneUsageDescription</key>
<string>your usage description here</string>
```

**Notice** that the minimum IPHONEOS_DEPLOYMENT_TARGET is 12.0, you can set it to something newer but not older.

### Android

- **minSdkVersion**: 21
- **targetSdkVersion**: 33
- **compileSdkVersion**: 33

## Getting Started

To start using `emirates_id_scanner`, add it to your Flutter project by including it in your `pubspec.yaml` file. Ensure you have camera permissions set up in your app as this package requires camera access for ID scanning.

### Supported Languages

**Notice** that By default, this package only supports recognition of Latin characters.

## Usage

To integrate the `emirates_id_scanner` into your Flutter application, follow this example. This demonstrates how to set up a camera overlay for scanning Emirates ID cards, capture an image, and then use the `EIDScanner` to scan and extract data from the ID.

```dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:emirates_id_scanner/camera_overlay/camera_overlay.dart';
import 'package:emirates_id_scanner/camera_overlay/overlay_model.dart';
import 'package:emirates_id_scanner/eid_scanner/eid_scanner.dart';
import 'package:emirates_id_scanner/eid_scanner/emirate_id_model.dart';
import 'package:flutter/material.dart';

class EidScreen extends StatefulWidget {
  const EidScreen({Key? key}) : super(key: key);

  @override
  _EidScreenState createState() => _EidScreenState();
}

class _EidScreenState extends State<EidScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<CameraDescription>>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data != null) {
            return CameraOverlay(
              onCapture: (XFile file) async {
                final EmirateIdModel? extractedText =
                    await EIDScanner.scanEmirateID(image: File(file.path));
                // Process the extracted data
                print(extractedText);
              },
              model: CardOverlay.byFormat(),
              camera: snapshot.data!.first,
            );
          } else {
            return const Align(
                alignment: Alignment.center,
                child: Text(
                  'No camera found',
                  style: TextStyle(color: Colors.black),
                ));
          }
        },
      ),
    );
  }
}
```
