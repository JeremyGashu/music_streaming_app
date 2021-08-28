import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/data/models/album.dart';

class FeaturedAlbumState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends FeaturedAlbumState {
  @override
  List<Object> get props => [];
}

class LoadingFeaturedAlbum extends FeaturedAlbumState {
  @override
  List<Object> get props => [];
}

class LoadedFeaturedAlbum extends FeaturedAlbumState {
  final List<Album> albums;
  LoadedFeaturedAlbum({@required this.albums}) : assert(albums != null);
  @override
  List<Object> get props => [albums];
}

class LoadingFeaturedAlbumError extends FeaturedAlbumState {
  final String message;
  LoadingFeaturedAlbumError({@required this.message});
  @override
  List<Object> get props => [message];
}
