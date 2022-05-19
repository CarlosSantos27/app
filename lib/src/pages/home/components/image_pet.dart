import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../env/env.model.dart';
import '../../../services/pool_services.dart';

class ImagePet extends StatelessWidget {
  final BoxFit boxFit;
  final String supportedTeam;
  final EnvModel env = GetIt.I<PoolServices>().environment.environment;

  ImagePet({
    this.supportedTeam,
    this.boxFit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return _imagePetContainer();
  }

  Widget _imagePetContainer() {
    String logo = supportedTeam != null ? supportedTeam : 'Futgolazo';

    return CachedNetworkImage(
      fit: boxFit,
      imageUrl: '${env.imagePath}team_pets/single/desktop/$logo.png',
      errorWidget: (_, __, ___) {
        return Image.asset('assets/common/logo.png');
      },
    );
  }
}
