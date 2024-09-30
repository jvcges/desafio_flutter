import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/app/presentation/components/app_elevated_button.dart';
import 'package:desafio_flutter/core/routes/app_routes.dart';
import 'package:desafio_flutter/shared/extensions/e_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SaveAddressBottomSheet extends StatelessWidget {
  final String cep;
  final String address;
  final LatLng? latLng;
  final Function()? onAddressSaved;
  const SaveAddressBottomSheet({
    super.key,
    required this.cep,
    required this.address,
    this.onAddressSaved,
    required this.latLng,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 4,
                  width: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      cep,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                        color: Color(0xFF1C1B1F),
                      ),
                    ),
                    Text(
                      address,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xFF49454F),
                      ),
                    ),
                  ].addSpacing(16, direction: Axis.vertical),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            AppElevatedButton(
              text: "Salvar endereço",
              onPressed: () {
                AppRouters.goToSaveLocationPage(
                  AddressDto(
                    cep: cep,
                    address: address,
                    latLng: latLng,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
