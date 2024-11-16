import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vergoes_mobile_app/repository/location_repository.dart';

// Location Events
abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

class FetchLocationEvent extends LocationEvent {}

// Location States
abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final String currentLocation;

  const LocationLoaded(this.currentLocation);
}

class LocationFailure extends LocationState {
  final String error;

  const LocationFailure(this.error);
}

// Location BLoC
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository locationRepository;

  LocationBloc({required this.locationRepository}) : super(LocationInitial());

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (event is FetchLocationEvent) {
      yield LocationLoading();
      try {
        final location = await locationRepository.getCurrentLocation();
        yield LocationLoaded(location);
      } catch (e) {
        yield LocationFailure(e.toString());
      }
    }
  }
}
