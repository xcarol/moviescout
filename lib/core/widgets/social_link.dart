import 'package:flutter/material.dart';
import 'package:moviescout/core/theme/app_tokens.dart';
import 'package:moviescout/core/widgets/boxed_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLink extends StatelessWidget {
  final String url;
  final Widget child;
  final LaunchMode launchMode;

  const SocialLink({
    super.key,
    required this.url,
    required this.child,
    this.launchMode = LaunchMode.externalApplication,
  });

  factory SocialLink.image({
    Key? key,
    required String url,
    required String assetPath,
    LaunchMode launchMode = LaunchMode.externalApplication,
  }) {
    return SocialLink(
      key: key,
      url: url,
      launchMode: launchMode,
      child: SizedBox(
        height: AppSizes.iconMd,
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  factory SocialLink.icon({
    Key? key,
    required String url,
    required IconData iconData,
    required Color color,
    LaunchMode launchMode = LaunchMode.externalApplication,
  }) {
    return SocialLink(
      key: key,
      url: url,
      launchMode: launchMode,
      child: SizedBox(
        height: AppSizes.iconMd,
        width: AppSizes.iconMd,
        child: Icon(
          iconData,
          size: AppSizes.iconMd,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BoxedWidget(
      padding: AppSpacing.chipPadding,
      onPressed: () {
        launchUrl(
          Uri.parse(url),
          mode: launchMode,
        );
      },
      child: child,
    );
  }
}
