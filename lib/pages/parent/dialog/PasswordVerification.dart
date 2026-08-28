import 'package:flutter/material.dart';

class PasswordVerificationDialog extends StatefulWidget {
  final Future<bool> Function(String password) onVerify;

  const PasswordVerificationDialog({super.key, required this.onVerify});

  @override
  State<PasswordVerificationDialog> createState() =>
      _PasswordVerificationDialogState();
}

class _PasswordVerificationDialogState
    extends State<PasswordVerificationDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  String? _errorMessage;

  static const Color primaryOrange = Color(0xFFE87A1E);
  static const Color borderGreen = Color(0xFFA8D5B5);
  static const Color iconGreen = Color(0xFF2E6B3E);

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final password = _passwordController.text.trim();
    if (password.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final isValid = await widget.onVerify(password);

    if (!mounted) return;

    if (isValid) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Mot de passe incorrect.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canSubmit =
        _passwordController.text.trim().isNotEmpty && !_isLoading;

    return Dialog(
      backgroundColor: const Color(0xFFF9FBF8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            const Text(
              'Espace parent',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            // Subtitle / Label
            const Text(
              'Mot de passe',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            // Champ texte avec ombre légère
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) {
                  if (canSubmit) _submit();
                },
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  errorText: _errorMessage,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: borderGreen,
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: borderGreen,
                      width: 1.8,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.red, width: 1.8),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: iconGreen,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Actions Buttons
            Row(
              children: [
                // Bouton Annuler
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: primaryOrange,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(
                          color: primaryOrange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Bouton Valider
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: canSubmit ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        disabledBackgroundColor: primaryOrange.withOpacity(0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Valider',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
