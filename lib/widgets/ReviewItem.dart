import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:valex_agro_audit_app/All.dart';

class ReviewItem extends StatelessWidget {
  final ClientReview review;
  final DateFormat dateFormat = DateFormat('dd.MM.yyyy');
  ReviewItem(this.review);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: greyMedium)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(review.user, style: styleBoldP14, softWrap: true).expanded(),
            Container(width: 10),
            Text(dateFormat.format(review.date!), style: styleBoldP11)
          ]
        )
    );
  }
}