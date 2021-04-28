import 'package:flutter/cupertino.dart';
import 'package:valex_agro_audit_app/All.dart';

class QuestionItem extends StatefulWidget {
  final ClientAdditionalQuestion question;
  final bool isEditable;
  QuestionItem(this.question, {this.isEditable = true});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<QuestionItem> {
  TextEditingController? question, answer, change;

  @override
  void initState() {
    question = TextEditingController(text: widget.question.question);
    answer = TextEditingController(text: widget.question.answer);
    change = TextEditingController(text: widget.question.change);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        key: Key("contact_people_item_${widget.question.id}"),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: greyMedium)
        ),
        child: Wrap(
            runSpacing: 10,
            children: [
              CustomRoundedTextField(question, hint: "question", helperText: "question", maxLines: 3,
                  onChanged: (n) => widget.question.question = n, isEnable: widget.isEditable).center(),
              CustomRoundedTextField(answer, hint: "answer", helperText: "answer", maxLines: 3,
                  onChanged: (w) => widget.question.answer = w, isEnable: widget.isEditable),
              CustomRoundedTextField(change, hint: "change", helperText: "change", maxLines: 3,
                  onChanged: (p) => widget.question.change = p, isEnable: widget.isEditable)
            ]
        )
    );
  }
}