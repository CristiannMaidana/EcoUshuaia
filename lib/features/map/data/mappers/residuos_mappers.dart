import 'package:eco_ushuaia/features/map/data/dtos/residuos_dto.dart';
import 'package:eco_ushuaia/features/map/domain/entities/residuos_entity.dart';

extension ResiduosMappers on ResiduosDto {
  ResiduosEntity toEntity() => ResiduosEntity(
    nombre: nombre,
    categoria: categoria, 
    peso: peso, 
    instruccion_reciclado: instruccion_reciclado, 
    descripcion: descripcion
  );
}