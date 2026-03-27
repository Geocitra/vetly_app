import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../core/constants/theme.dart';

class ClinicMapScreen extends StatefulWidget {
  const ClinicMapScreen({super.key});

  @override
  State<ClinicMapScreen> createState() => _ClinicMapScreenState();
}

class _ClinicMapScreenState extends State<ClinicMapScreen> {
  // Koordinat Tengah (Pusat Pencarian)
  final LatLng _userLocation = const LatLng(-6.200000, 106.816666);

  bool _isSatellite = false;
  final MapController _mapController = MapController();

  // Mock Data Ekosistem Peliharaan (Pure Fabrication)
  // Tidak ada lagi POI restoran atau mal, murni ekosistem vely
  final List<Map<String, dynamic>> _petEcosystemPOIs = [
    {
      'name': 'Klinik Hewan PawCare',
      'location': const LatLng(-6.195000, 106.810000),
      'distance': '1.2 km',
      'status': 'Buka 24 Jam',
      'type': 'clinic', // Jenis POI
      'isEmergency': true,
    },
    {
      'name': 'Fluffy Pet Grooming & Spa',
      'location': const LatLng(-6.205000, 106.825000),
      'distance': '2.5 km',
      'status': 'Buka • Tutup 18.00',
      'type': 'grooming',
      'isEmergency': false,
    },
    {
      'name': 'vely Mart (Pet Shop)',
      'location': const LatLng(-6.190000, 106.820000),
      'distance': '3.1 km',
      'status': 'Buka • Tutup 21.00',
      'type': 'petshop',
      'isEmergency': false,
    },
    {
      'name': 'Sehat Satwa Vet Clinic',
      'location': const LatLng(-6.208000, 106.805000),
      'distance': '4.5 km',
      'status': 'Buka • Tutup 20.00',
      'type': 'clinic',
      'isEmergency': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: velyTheme.backgroundLight,
      body: Stack(
        children: [
          // 1. BASE MAP LAYER (Kanvas Bersih tanpa POI luar)
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation,
              initialZoom: 14.0,
              maxZoom: 20.0,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                // PERUBAHAN ARSITEKTUR TILE:
                // Menggunakan CartoDB Positron untuk peta bersih tanpa POI
                // Jika satelit, tetap menggunakan Google Satellite
                urlTemplate: _isSatellite
                    ? "https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}"
                    : "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.vely.app',
              ),

              // 2. LAYER CUSTOM POI KITA SENDIRI
              MarkerLayer(
                markers: [
                  // Pin Lokasi User
                  Marker(
                    point: _userLocation,
                    width: 60,
                    height: 60,
                    child: _buildUserMarker(),
                  ),
                  // Pin Lokasi Ekosistem vely
                  ..._petEcosystemPOIs.map(
                    (poi) => Marker(
                      point: poi['location'] as LatLng,
                      width: 44,
                      height: 44,
                      alignment: Alignment.topCenter,
                      child: _buildPOIMarker(poi),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 3. OVERLAY UI
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: _buildTopOverlay(),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            right: 16,
            child: _buildLayerToggle(),
          ),

          // 4. BOTTOM HORIZONTAL POI LIST
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 140,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _petEcosystemPOIs.length,
                itemBuilder: (context, index) {
                  return _buildPOICard(_petEcosystemPOIs[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk menentukan visual marker berdasarkan tipe POI
  Widget _buildPOIMarker(Map<String, dynamic> poi) {
    IconData icon;
    Color color;

    switch (poi['type']) {
      case 'clinic':
        icon = Icons.local_hospital_rounded;
        color = poi['isEmergency']
            ? Colors.red.shade600
            : velyTheme.primaryTeal;
        break;
      case 'grooming':
        icon = Icons.content_cut_rounded;
        color = Colors.purple.shade500;
        break;
      case 'petshop':
        icon = Icons.shopping_bag_rounded;
        color = Colors.orange.shade500;
        break;
      default:
        icon = Icons.location_on_rounded;
        color = velyTheme.primaryTeal;
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _mapController.move(poi['location'] as LatLng, 16.0);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildUserMarker() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.5),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopOverlay() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: velyTheme.surfaceWhite.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: velyTheme.textDark,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: velyTheme.surfaceWhite.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: velyTheme.textGrey.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Klinik, Grooming, atau Petshop...',
                      style: TextStyle(
                        color: velyTheme.textGrey.withValues(alpha: 0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLayerToggle() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() {
              _isSatellite = !_isSatellite;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: velyTheme.surfaceWhite.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            ),
            child: Icon(
              _isSatellite ? Icons.map_rounded : Icons.satellite_alt_rounded,
              color: velyTheme.primaryTeal,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  // Helper untuk menentukan Tag Kategori di Kartu List
  Widget _buildPOICard(Map<String, dynamic> poi) {
    String tagText;
    Color tagColor;
    Color tagBgColor;

    switch (poi['type']) {
      case 'clinic':
        tagText = poi['isEmergency'] ? 'UGD 24 Jam' : 'Klinik Hewan';
        tagColor = poi['isEmergency']
            ? Colors.red.shade700
            : velyTheme.primaryTeal;
        tagBgColor = poi['isEmergency']
            ? Colors.red.shade50
            : velyTheme.primaryTeal.withValues(alpha: 0.1);
        break;
      case 'grooming':
        tagText = 'Grooming & Spa';
        tagColor = Colors.purple.shade700;
        tagBgColor = Colors.purple.shade50;
        break;
      case 'petshop':
        tagText = 'Pet Shop (Retail)';
        tagColor = Colors.orange.shade700;
        tagBgColor = Colors.orange.shade50;
        break;
      default:
        tagText = 'Layanan';
        tagColor = velyTheme.primaryTeal;
        tagBgColor = velyTheme.primaryTeal.withValues(alpha: 0.1);
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        _mapController.move(poi['location'] as LatLng, 16.0);
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: velyTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: tagBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tagText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: tagColor,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.directions_walk_rounded,
                      size: 12,
                      color: velyTheme.textGrey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      poi['distance'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: velyTheme.textGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              poi['name'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: velyTheme.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              poi['status'],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: velyTheme.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
