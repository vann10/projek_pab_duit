import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projek_pab_duit/themes/colors.dart';

class UserProfileSection extends StatefulWidget {
  const UserProfileSection({super.key});

  @override
  State<UserProfileSection> createState() => _UserProfileSectionState();
}

class _UserProfileSectionState extends State<UserProfileSection> {
  File? _imageFile;

  // Fungsi untuk membuka galeri dan memilih gambar
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF29175C), DarkColors.bg.withOpacity(0.1)],
          stops: const [0.0, 1.0],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildUserProfileInfo(),
        ],
      ),
    );
  }

  // Widget untuk header: tombol kembali, judul, dan tombol aksi
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          borderRadius: BorderRadius.circular(24),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        const Text(
          'User Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        InkWell(
          onTap: () {
            // Aksi untuk tombol 'more'
          },
          borderRadius: BorderRadius.circular(24),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(Icons.more_vert, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }

  // Widget untuk informasi profil: nama, kontak, dan foto
  Widget _buildUserProfileInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chandrama Saha',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '+91 XXXXX XXXXX',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'chandramasaha@xxxxx',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildProfilePicture(),
      ],
    );
  }

  // Widget untuk foto profil dengan ikon QR
  Widget _buildProfilePicture() {
    ImageProvider imageProvider =
        _imageFile != null
            ? FileImage(_imageFile!)
            : const NetworkImage(
              'https://i.pravatar.cc/150?u=a042581f4e29026704d',
            );

    return SizedBox(
      width: 84,
      height: 84,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
              child:
                  _imageFile == null
                      ? const Center(
                        child: Icon(Icons.camera_alt, color: Colors.white38),
                      )
                      : null,
            ),
          ),
          Positioned(
            bottom: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF4A3184),
                shape: BoxShape.circle,
                border: Border.all(color: DarkColors.bg, width: 2),
              ),
              child: const Icon(Icons.qr_code, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
