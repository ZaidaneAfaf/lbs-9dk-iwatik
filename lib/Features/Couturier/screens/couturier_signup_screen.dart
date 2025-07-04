import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:file_selector/file_selector.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../auth/screens/auth_screen.dart';
import '../controllers/couturierRegisterController.dart';
import '../models/couturierModel.dart';

class CouturierSignupScreen extends StatefulWidget {
  const CouturierSignupScreen({super.key});

  @override
  State<CouturierSignupScreen> createState() => _CouturierSignupScreenState();
}

class _CouturierSignupScreenState extends State<CouturierSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  // Contrôleurs
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _introductionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // États
  String? _selectedSex;
  DateTime? _selectedDate;
  File? _imageFile;
  File? _certificateFile;
  bool _acceptTerms = false;
  bool _isLoading = false;

  // Constantes de style
  static const _pinkColor = Color(0xFFE91E63);
  static const _lightGrey = Color(0xFFF5F5F5);
  static const _darkGrey = Color(0xFF616161);

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _nationalityController.dispose();
    _introductionController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null && mounted) {
        setState(() => _imageFile = File(picked.path));
      }
    } catch (e) {
      _showError('Erreur lors de la sélection de l\'image');
    }
  }

  Future<void> _pickCertificate() async {
    try {
      const typeGroup = XTypeGroup(label: 'Documents', extensions: ['pdf', 'docx']);
      final file = await openFile(acceptedTypeGroups: [typeGroup]);
      if (file != null && mounted) {
        setState(() => _certificateFile = File(file.path));
      }
    } catch (e) {
      _showError('Erreur lors de la sélection du certificat');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  bool _validateDate() => _selectedDate != null;

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) return false;
    if (!_validateDate()) {
      _showError('Veuillez sélectionner votre date de naissance');
      return false;
    }
    if (_selectedSex == null) {
      _showError('Veuillez sélectionner votre sexe');
      return false;
    }
    if (_imageFile == null || _certificateFile == null) {
      _showError('L\'image et le certificat sont requis');
      return false;
    }
    if (!_acceptTerms) {
      _showError('Veuillez accepter les conditions d\'utilisation');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToAuthScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (route) => false,
    );
  }

  Future<void> _submitForm() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      final model = CouturierModel(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        nationality: _nationalityController.text.trim(),
        sex: _selectedSex!,
        dateOfBirth: _selectedDate!,
        introduction: _introductionController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await CouturierRegisterController.registerCouturier(
        model,
        _imageFile!,
        _certificateFile!,
      );

      // Forcer la déconnexion après inscription
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inscription réussie! Un administrateur validera votre compte.'),
          duration: Duration(seconds: 4),
        ),
      );

      _navigateToAuthScreen();
    } catch (e) {
      _showError('Erreur lors de l\'inscription: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // En-tête
              Container(
                width: double.infinity,
                height: screenHeight * 0.2,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDDDE3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo_lbs9dkiwatik.png',
                    width: 160,
                    height: 100,
                  ),
                ),
              ),

              // Illustration
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Image.asset(
                  'assets/images/registerCouturier.png',
                  width: 140,
                  height: 140,
                ),
              ),

              // Formulaire
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: MediaQuery.of(context).size.width < 440 ? double.infinity : 400,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField('Prénom', _firstNameController),
                        _buildTextField('Nom', _lastNameController),
                        _buildTextField('Email', _emailController,
                            keyboardType: TextInputType.emailAddress),
                        _buildPasswordField('Mot de passe', _passwordController),
                        _buildPasswordField('Confirmer le mot de passe',
                            _confirmPasswordController,
                            confirm: true),
                        _buildTextField('Adresse', _addressController),
                        _buildTextField('Téléphone', _phoneController,
                            keyboardType: TextInputType.phone),
                        _buildNationalityPicker(),
                        _buildDropdownSex(),
                        _buildDatePicker(),
                        _buildImagePicker(),
                        _buildTextField('Présentation', _introductionController,
                            maxLines: 4, required: false),
                        _buildCertificatePicker(),

                        // Conditions d'utilisation
                        Row(
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() => _acceptTerms = value ?? false);
                                }
                              },
                            ),
                            const Expanded(
                              child: Text(
                                "J'accepte les conditions d'utilisation",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Bouton d'inscription
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Créer mon compte",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool required = true,
      bool obscure = false,
      TextInputType keyboardType = TextInputType.text,
      int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: _pinkColor,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(color: Colors.grey[800]),
          validator: required
              ? (val) =>
                  (val == null || val.isEmpty) ? 'Ce champ est requis' : null
              : null,
          decoration: InputDecoration(
            hintText: 'Saisir...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: false,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _pinkColor, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      {bool confirm = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: _pinkColor,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: true,
          style: TextStyle(color: Colors.grey[800]),
          validator: (val) {
            if (val == null || val.isEmpty) return 'Ce champ est requis';
            if (confirm && val != _passwordController.text) {
              return 'Les mots de passe ne correspondent pas';
            }
            if (val.length < 8) return '8 caractères minimum';
            if (!RegExp(r'[A-Z]').hasMatch(val)) {
              return '1 majuscule minimum';
            }
            if (!RegExp(r'[0-9]').hasMatch(val)) {
              return '1 chiffre minimum';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Saisir...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: false,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _pinkColor, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildNationalityPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nationalité',
          style: TextStyle(
            fontSize: 16,
            color: _pinkColor,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _nationalityController,
          readOnly: true,
          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: false,
              onSelect: (Country country) {
                if (mounted) {
                  setState(() => _nationalityController.text = country.name);
                }
              },
            );
          },
          validator: (val) =>
              val == null || val.isEmpty ? 'Veuillez sélectionner un pays' : null,
          decoration: InputDecoration(
            hintText: 'Sélectionner un pays',
            hintStyle: TextStyle(color: _darkGrey.withOpacity(0.6)),
            filled: false,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _pinkColor, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: const Icon(Icons.arrow_drop_down, color: _darkGrey),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdownSex() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sexe',
          style: TextStyle(
            fontSize: 16,
            color: _pinkColor,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _selectedSex,
          items: const [
            DropdownMenuItem(value: 'Femme', child: Text('Femme')),
            DropdownMenuItem(value: 'Homme', child: Text('Homme')),
          ],
          onChanged: (value) {
            if (mounted) {
              setState(() => _selectedSex = value);
            }
          },
          decoration: InputDecoration(
            filled: false,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _pinkColor, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (val) =>
              val == null ? 'Veuillez sélectionner votre sexe' : null,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date de naissance',
          style: TextStyle(
            fontSize: 16,
            color: _pinkColor,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: _lightGrey,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black),
            ),
            child: Text(
              _selectedDate != null
                  ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                  : 'Sélectionner une date',
              style: TextStyle(color: _darkGrey),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photo de profil',
          style: TextStyle(
            fontSize: 16,
            color: _pinkColor,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: _lightGrey,
                foregroundColor: Colors.black,
              ),
              child: const Text('Choisir une image'),
            ),
            const SizedBox(width: 16),
            if (_imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _imageFile!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCertificatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Certificat (PDF/DOCX)',
          style: TextStyle(
            fontSize: 16,
            color: _pinkColor,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            ElevatedButton(
              onPressed: _pickCertificate,
              style: ElevatedButton.styleFrom(
                backgroundColor: _lightGrey,
                foregroundColor: Colors.black,
              ),
              child: const Text('Choisir un fichier'),
            ),
            const SizedBox(width: 16),
            if (_certificateFile != null)
              Expanded(
                child: Text(
                  _certificateFile!.path.split('/').last,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: _darkGrey),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
