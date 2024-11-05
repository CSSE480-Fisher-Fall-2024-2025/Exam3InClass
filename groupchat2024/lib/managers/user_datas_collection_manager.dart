import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moviequotes/managers/auth_manager.dart';
import 'package:moviequotes/models/movie_quote.dart';

class MovieQuotesCollectionManager {
  // Not needed if using Firebase UI Firestore
  // var latestMovieQuotes = <MovieQuote>[];
  final CollectionReference _ref;

  static final MovieQuotesCollectionManager instance =
      MovieQuotesCollectionManager._privateConstructor();

  MovieQuotesCollectionManager._privateConstructor()
      : _ref =
            FirebaseFirestore.instance.collection(kMovieQuotesCollectionPath);

// Not needed if using Firebase UI Firestore
  // StreamSubscription startListening(Function observer) => _ref
  //         .orderBy(kMovieQuoteLastTouched, descending: true)
  //         .snapshots()
  //         .listen((QuerySnapshot querySnapshot) {
  //       latestMovieQuotes =
  //           querySnapshot.docs.map((doc) => MovieQuote.from(doc)).toList();
  //       observer();
  //     }, onError: (error) {
  //       print("Error listening for Movie Quotes $error");
  //     });

  // void stopListening(StreamSubscription? subscription) {
  //   subscription?.cancel();
  // }

  Future<void> add({
    required String quote,
    required String movie,
  }) {
    return _ref.add({
      kMovieQuoteAuthorUid: AuthManager.instance.uid,
      kMovieQuoteQuote: quote,
      kMovieQuoteMovie: movie,
      kMovieQuoteLastTouched: Timestamp.now(),
    }).then((DocumentReference docRef) {
      print("The add is finished, the doc id was ${docRef.id}");
    }).catchError((error) {
      print("There was an error: $error");
    });
  }

  Query<MovieQuote> get allMovieQuotesQuery =>
      _ref.orderBy(kMovieQuoteLastTouched, descending: true).withConverter(
            fromFirestore: (documentSnapshot, _) =>
                MovieQuote.from(documentSnapshot),
            toFirestore: (movieQuote, _) => movieQuote.toJsonMap(),
          );

  Query<MovieQuote> get onlyMyMovieQuotesQuery => allMovieQuotesQuery
      .where(kMovieQuoteAuthorUid, isEqualTo: AuthManager.instance.uid);
}
