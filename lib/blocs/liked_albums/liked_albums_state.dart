//playlist loading error

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:streaming_mobile/data/models/album.dart';

class LikedAlbumsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends LikedAlbumsState {
  @override
  List<Object> get props => [];
}

class LoadingState extends LikedAlbumsState {
  @override
  List<Object> get props => [];
}

class LoadedLikedAlbums extends LikedAlbumsState {
  final List<Album> albums;
  LoadedLikedAlbums({@required this.albums}) : assert(albums != null);
  @override
  List<Object> get props => [albums];
}

class ErrorState extends LikedAlbumsState {
  final String message;
  ErrorState({@required this.message});
  @override
  List<Object> get props => [message];
}
