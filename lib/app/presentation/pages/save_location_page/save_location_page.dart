import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/app/presentation/components/app_elevated_button.dart';
import 'package:desafio_flutter/app/presentation/components/app_text_field.dart';
import 'package:desafio_flutter/app/presentation/pages/main_wrapper/bloc/main_wrapper_bloc.dart';
import 'package:desafio_flutter/app/presentation/pages/save_location_page/bloc/save_location_bloc.dart';
import 'package:desafio_flutter/core/routes/app_routes.dart';
import 'package:desafio_flutter/shared/extensions/e_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SaveLocationPage extends StatefulWidget {
  final AddressDto selectedAddress;
  const SaveLocationPage({
    super.key,
    required this.selectedAddress,
  });

  @override
  State<SaveLocationPage> createState() => _SaveLocationPageState();
}

class _SaveLocationPageState extends State<SaveLocationPage> {
  final _cepController = TextEditingController();
  final _addressController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _saveLocationBloc = Modular.get<SaveLocationBloc>();

  @override
  void initState() {
    _cepController.text = widget.selectedAddress.cep ?? '';
    _addressController.text = widget.selectedAddress.address ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _saveLocationBloc,
      child: BlocConsumer<SaveLocationBloc, SaveLocationState>(
        listener: (context, state) {
          if (state is SaveLocationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Endereço salvo com sucesso!'),
              ),
            );
            final wrapperBloc = Modular.get<MainWrapperBloc>();
            wrapperBloc.add(ChangePage(index: 1));
            AppRouters.pop();
            Navigator.pop(context);
          }

          if (state is SaveLocationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text(
                "Revisão",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
              centerTitle: false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    AppTextField(
                      controller: _cepController,
                      readOnly: true,
                      label: "CEP",
                    ),
                    AppTextField(
                      controller: _addressController,
                      readOnly: true,
                      label: "Endereço",
                    ),
                    AppTextField(
                      controller: _numberController,
                      readOnly: false,
                      label: "Número",
                      keyboardType: TextInputType.number,
                    ),
                    AppTextField(
                      controller: _complementController,
                      readOnly: false,
                      label: "Complemento",
                    ),
                  ].addSpacing(24, direction: Axis.vertical),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppElevatedButton(
                    text: "Confirmar",
                    onPressed: () {
                      final address = widget.selectedAddress.copyWith(
                        complement: _complementController.text,
                        number: int.tryParse(_numberController.text),
                      );
                      _saveLocationBloc.add(SaveNewLocation(address));
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
