import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moviequotes/models/firestore_model_utils.dart';

const kMovieQuotesCollectionPath = "MovieQuotes";
const kMovieQuoteAuthorUid = "authorUid";
const kMovieQuoteQuote = "quote";
const kMovieQuoteMovie = "movie";
const kMovieQuoteLastTouched = "lastTouched";

class MovieQuote {
  String? documentId;
  String authorUid;
  String quote;
  String movie;
  Timestamp lastTouched;

  MovieQuote({
    this.documentId,
    required this.authorUid,
    required this.quote,
    required this.movie,
    required this.lastTouched,
  });

  // Need for listening.
  MovieQuote.from(DocumentSnapshot doc)
      : this(
          documentId: doc.id,
          authorUid:
              FirestoreModelUtils.getStringField(doc, kMovieQuoteAuthorUid),
          quote: FirestoreModelUtils.getStringField(doc, kMovieQuoteQuote),
          movie: FirestoreModelUtils.getStringField(doc, kMovieQuoteMovie),
          lastTouched: FirestoreModelUtils.getTimestampField(
              doc, kMovieQuoteLastTouched),
        );

  Map<String, Object?> toJsonMap() => {
        kMovieQuoteAuthorUid: authorUid,
        kMovieQuoteQuote: quote,
        kMovieQuoteMovie: movie,
        kMovieQuoteLastTouched: lastTouched,
      };

  @override
  String toString() {
    return "Quote: $quote  from Movie: $movie";
  }
}
