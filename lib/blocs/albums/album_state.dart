import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/data/models/album.dart';

class AlbumState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends AlbumState {
  @override
  List<Object> get props => [];
}

class LoadingAlbum extends AlbumState {
  @override
  List<Object> get props => [];
}

class LoadedAlbum extends AlbumState {
  final List<Album> albums;
  LoadedAlbum({@required this.albums}) : assert(albums != null);
  @override
  List<Object> get props => [albums];
}

class LoadingAlbumError extends AlbumState {
  final String message;
  LoadingAlbumError({@required this.message});
}
