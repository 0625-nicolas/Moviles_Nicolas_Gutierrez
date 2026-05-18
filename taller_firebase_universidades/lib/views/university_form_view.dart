import 'package:flutter/material.dart';
import '../models/university.dart';
import '../services/firebase_service.dart';

class UniversityFormView extends StatefulWidget {
  final University? university;

  const UniversityFormView({super.key, this.university});

  @override
  State<UniversityFormView> createState() => _UniversityFormViewState();
}

class _UniversityFormViewState extends State<UniversityFormView> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _nitController;
  late final TextEditingController _nombreController;
  late final TextEditingController _direccionController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _webController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los datos existentes en caso de edición
    _nitController = TextEditingController(text: widget.university?.nit ?? '');
    _nombreController = TextEditingController(text: widget.university?.nombre ?? '');
    _direccionController = TextEditingController(text: widget.university?.direccion ?? '');
    _telefonoController = TextEditingController(text: widget.university?.telefono ?? '');
    _webController = TextEditingController(text: widget.university?.paginaWeb ?? '');
  }

  @override
  void dispose() {
    _nitController.dispose();
    _nombreController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _webController.dispose();
    super.dispose();
  }

  // Ejecuta el proceso de guardado validando el formulario e interactuando con el servicio
  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final tempUni = University(
      id: widget.university?.id ?? '',
      nit: _nitController.text.trim(),
      nombre: _nombreController.text.trim(),
      direccion: _direccionController.text.trim(),
      telefono: _telefonoController.text.trim(),
      paginaWeb: _webController.text.trim(),
    );

    try {
      if (widget.university == null) {
        // Crear nuevo
        await FirebaseService.instance.addUniversity(tempUni);
      } else {
        // Editar existente
        await FirebaseService.instance.updateUniversity(tempUni);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.university == null
                  ? 'Universidad registrada exitosamente.'
                  : 'Universidad actualizada exitosamente.',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.university != null;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0E17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0E17),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? 'Editar Universidad' : 'Nueva Universidad',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado descriptivo
                Text(
                  isEditing
                      ? 'Actualiza los campos requeridos de la universidad en la base de datos.'
                      : 'Completa la información para registrar una nueva universidad en la colección.',
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),

                // Campo: NIT
                _buildFormField(
                  controller: _nitController,
                  labelText: 'NIT',
                  hintText: '890.123.456-7',
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El NIT es obligatorio.';
                    }
                    if (value.trim().length < 5) {
                      return 'Ingresa un NIT válido.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo: Nombre
                _buildFormField(
                  controller: _nombreController,
                  labelText: 'Nombre de la Universidad',
                  hintText: 'Universidad Central del Valle',
                  icon: Icons.business_outlined,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es obligatorio.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo: Dirección
                _buildFormField(
                  controller: _direccionController,
                  labelText: 'Dirección física',
                  hintText: 'Calle 48 # 27-10',
                  icon: Icons.location_on_outlined,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La dirección es obligatoria.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo: Teléfono
                _buildFormField(
                  controller: _telefonoController,
                  labelText: 'Teléfono de contacto',
                  hintText: '+57 602 2242202',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El teléfono es obligatorio.';
                    }
                    // Validación de longitud mínima para números telefónicos
                    if (value.trim().replaceAll(RegExp(r'\D'), '').length < 7) {
                      return 'Ingresa un número de teléfono válido (mínimo 7 dígitos).';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo: Página Web (URL)
                _buildFormField(
                  controller: _webController,
                  labelText: 'Página Web (URL)',
                  hintText: 'https://www.uceva.edu.co',
                  icon: Icons.language_outlined,
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La dirección web es obligatoria.';
                    }
                    // Expresión regular robusta para URLs que contengan http o https
                    final urlPattern = RegExp(
                      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
                      caseSensitive: false,
                    );
                    if (!urlPattern.hasMatch(value.trim())) {
                      return 'Formato URL inválido. Debe empezar con http:// o https://';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Botón de Acción de Guardado
                GestureDetector(
                  onTap: _isSaving ? null : _saveForm,
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: _isSaving
                          ? null
                          : const LinearGradient(
                              colors: [Color(0xFF7F00FF), Color(0xFF00F0FF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                      color: _isSaving ? Colors.white10 : null,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _isSaving
                          ? null
                          : [
                              const BoxShadow(
                                color: Color(0x3300F0FF),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                    ),
                    child: Center(
                      child: _isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00F0FF)),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isEditing ? Icons.save_rounded : Icons.check_circle_outline_rounded,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  isEditing ? 'Guardar Cambios' : 'Registrar Universidad',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper para construir campos de texto premium y consistentes
  Widget _buildFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x991E1B29),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white54, fontSize: 13),
          floatingLabelStyle: const TextStyle(color: Color(0xFF00F0FF), fontSize: 13),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.white30, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 11),
        ),
      ),
    );
  }
}
