import 'dart:io';
import 'dart:convert';

import 'package:flutter_spotify_search/domain/entities/album/album.dart';
import 'package:flutter_spotify_search/domain/entities/artist/artist.dart';

String fixtureFilms(String name) => File('test/fixtures/$name').readAsStringSync();

List<Album> getMockAlbums() {
  final response = json.decode(fixtureFilms('album_model.json'));
  final results = response['albums']['items'];
  return (results as List).map((album) => Album.fromJson(album as Map<String, dynamic>)).toList();
}

List<Artist> getMockArtists() {
  final response = json.decode(fixtureFilms('artist_model.json'));
  final results = response['artists']['items'];
  return (results as List).map((artist) => Artist.fromJson(artist as Map<String, dynamic>)).toList();
}