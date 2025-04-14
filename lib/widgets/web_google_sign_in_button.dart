import 'package:flutter/material.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart' as web;
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart'
show GoogleSignInPlatform;

class GoogleSigninCustomButton extends StatelessWidget {
  
  final VoidCallback? onTap; 
  final bool? isLoading;

  const GoogleSigninCustomButton({
    this.onTap,
    this.isLoading = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    _initializeGoogleSigninPlugin();
    final config = web.GSIButtonConfiguration(
      type: web.GSIButtonType.standard,
      shape: web.GSIButtonShape.rectangular,
      size: web.GSIButtonSize.large,
      text: web.GSIButtonText.continueWith,
      logoAlignment: web.GSIButtonLogoAlignment.left,
      minimumWidth: 400,
    );
    return (GoogleSignInPlatform.instance as web.GoogleSignInPlugin).renderButton(configuration: config);
  }

  Future<void> _initializeGoogleSigninPlugin() async {
    final plugin = GoogleSignInPlatform.instance as web.GoogleSignInPlugin;
    await plugin.init();
  }
}