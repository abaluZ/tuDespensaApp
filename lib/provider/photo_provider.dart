import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:tudespensa/Utils/preferences.dart';

class PhotoProvider with ChangeNotifier {
  final prefs = Preferences();
  bool isLoading = false;
  String? errorMessage;
  String? currentPhotoUrl;
  final ImagePicker _picker = ImagePicker();

  // URL base del backend
  final String baseUrl = 'http://192.168.0.57:4000/api';

  // Método para construir URLs
  String _buildUrl(String endpoint) {
    final url = '$baseUrl$endpoint';
    print('[PhotoProvider] URL construida: $url');
    return url;
  }

  Future<bool> uploadProfilePhoto(File profilePhoto) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = prefs.authToken;
      print('[PhotoProvider] Token para subida: $token');

      if (token.isEmpty) {
        errorMessage = "Token no encontrado";
        isLoading = false;
        notifyListeners();
        return false;
      }

      final url = _buildUrl('/profile/upload-profile-photo');
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      print(
          '[PhotoProvider] Preparando archivo para subir: ${profilePhoto.path}');
      final fileStats = await profilePhoto.stat();
      print('[PhotoProvider] Tamaño del archivo: ${fileStats.size} bytes');

      // Detectar el tipo MIME usando el paquete mime
      final mimeType = lookupMimeType(profilePhoto.path);
      print('[PhotoProvider] Tipo MIME detectado: $mimeType');

      if (mimeType == null || !mimeType.startsWith('image/')) {
        errorMessage = "El archivo seleccionado no es una imagen válida";
        isLoading = false;
        notifyListeners();
        return false;
      }

      // Separar el tipo MIME en tipo y subtipo
      final mimeTypeParts = mimeType.split('/');
      final mediaType = MediaType(mimeTypeParts[0], mimeTypeParts[1]);
      print('[PhotoProvider] MediaType configurado: $mediaType');

      final multipartFile = await http.MultipartFile.fromPath(
        'profilePhoto',
        profilePhoto.path,
        contentType: mediaType,
      );

      print(
          '[PhotoProvider] Tipo de contenido del archivo: ${multipartFile.contentType}');
      request.files.add(multipartFile);

      print('[PhotoProvider] Enviando foto al servidor...');
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      print('[PhotoProvider] Código de respuesta: ${response.statusCode}');
      print('[PhotoProvider] Respuesta: $responseData');
      print('[PhotoProvider] Headers de la respuesta: ${response.headers}');

      if (response.statusCode == 200) {
        print('[PhotoProvider] Foto subida exitosamente');
        // Parsear la respuesta JSON
        final responseJson = json.decode(responseData);
        // Actualizar la URL de la foto
        currentPhotoUrl = '${baseUrl}/${responseJson['profilePhoto']}';
        print('[PhotoProvider] Nueva URL de foto: $currentPhotoUrl');
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = "Error al subir la foto (${response.statusCode})";
        print('[PhotoProvider] Error al subir la foto: $responseData');
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = "Error de conexión";
      print('[PhotoProvider] Error: $e');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProfilePhoto() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final token = prefs.authToken;
      print('[PhotoProvider] Token para eliminación: $token');

      if (token.isEmpty) {
        errorMessage = "Token no encontrado";
        isLoading = false;
        notifyListeners();
        return false;
      }

      final url = _buildUrl('/profile/delete-profile-photo');
      print('[PhotoProvider] Intentando eliminar foto con URL: $url');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('[PhotoProvider] Headers enviados: ${response.request?.headers}');
      print('[PhotoProvider] Código de respuesta: ${response.statusCode}');
      print('[PhotoProvider] Respuesta completa: ${response.body}');

      if (response.statusCode == 200) {
        print('[PhotoProvider] Foto eliminada exitosamente');
        currentPhotoUrl = null;
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        errorMessage = "Error al eliminar la foto (${response.statusCode})";
        print('[PhotoProvider] Error al eliminar la foto: ${response.body}');
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      errorMessage = "Error de conexión";
      print('[PhotoProvider] Error detallado: $e');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> pickAndUploadImage(BuildContext context) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
        requestFullMetadata: true,
      );

      if (pickedImage != null) {
        // Verificar la extensión del archivo
        final String extension = pickedImage.path.split('.').last.toLowerCase();
        if (!['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Por favor selecciona una imagen en formato JPG, PNG, GIF o WebP'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        final File imageFile = File(pickedImage.path);
        final result = await uploadProfilePhoto(imageFile);

        if (result) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Foto actualizada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage ?? 'Error al actualizar la foto'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      print('[PhotoProvider] Error al seleccionar imagen: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al seleccionar la imagen'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
