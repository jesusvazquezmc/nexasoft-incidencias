import 'package:flutter_test/flutter_test.dart';
import 'package:nexasoft_incidencias/model/incidencia.dart';
import 'package:nexasoft_incidencias/services/gestor_incidencias.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  test('Una incidencia antigua puede convertirse desde JSON', () {
    final registro = Incidencia.desdeJson({
      'id': 'INC-DEMO',
      'titulo': 'Prueba',
      'descripcion': 'Caso de ejemplo',
      'cliente': 'Cliente ficticio',
      'categoria': 'Redes',
      'estado': 'Pendiente',
      'prioridad': 'Media',
      'fecha': '2026-10-12',
    });
    expect(registro.id, 'INC-DEMO');
    expect(registro.toJson()['estado'], 'Pendiente');
    expect(registro.toJson()['prioridad'], 'Media');
  });

  test('La búsqueda ignora mayúsculas y considera título y descripción', () {
    final gestor = GestorIncidencias();
    gestor.incidencias = [
      Incidencia(
        id: 'INC-1',
        titulo: 'WiFi intermitente en recepción',
        descripcion: 'La red inalámbrica falla durante la mañana.',
        cliente: 'Cliente 1',
        categoria: 'Redes',
        estado: 'Pendiente',
        prioridad: 'Media',
        fecha: '2026-10-12',
      ),
      Incidencia(
        id: 'INC-2',
        titulo: 'Configuración de VPN',
        descripcion:
            'El personal remoto no puede establecer túnel de conexión seguro.',
        cliente: 'Cliente 2',
        categoria: 'Redes',
        estado: 'En proceso',
        prioridad: 'Alta',
        fecha: '2026-10-13',
      ),
      Incidencia(
        id: 'INC-3',
        titulo: 'Pantalla azul',
        descripcion: 'El monitor muestra errores del sistema.',
        cliente: 'Cliente 3',
        categoria: 'Hardware',
        estado: 'Pendiente',
        prioridad: 'Baja',
        fecha: '2026-10-14',
      ),
    ];

    expect(gestor.buscar(' wifi ').length, 1);
    expect(gestor.buscar('WiFi').map((x) => x.id).toList(), ['INC-1']);
    expect(gestor.buscar('túnel').map((x) => x.id).toList(), ['INC-2']);
    expect(gestor.buscar('   ').length, 3);
  });
}
