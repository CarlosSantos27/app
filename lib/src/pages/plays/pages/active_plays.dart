import 'package:flutter/material.dart';
import 'package:futgolazo/src/bloc/my_books/my_books.bloc.dart';
import 'package:futgolazo/src/components/custom_scafold/statefull_custom.dart';
import 'package:futgolazo/src/models/resume_book.model.dart';
import 'package:futgolazo/src/models/user.model.dart';
import 'package:futgolazo/src/pages/plays/components/book_section.dart';
import 'package:get_it/get_it.dart';

import '../../../services/pool_services.dart';

class ActivePlaysPage extends StateFullCustom {
  final MyBooksBloc myBooksBloc;

  ActivePlaysPage({
    Key key,
    @required this.myBooksBloc,
  }) : super(key: key);

  @override
  _ActivePlaysPageState createState() => _ActivePlaysPageState();
}

class _ActivePlaysPageState extends State<ActivePlaysPage> {
  UserModel _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = GetIt.I<PoolServices>().dataService.user;
    if (!_currentUser.isGuestUser) {
      widget.myBooksBloc.getActivePlays();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildBooksSection(),
          SizedBox(height: widget.responsive.hp(15.0)),
        ],
      ),
    );
  }

  _buildBooksSection() {
    return StreamBuilder<List<ResumeBookModel>>(
      stream: widget.myBooksBloc.activePlaysStream,
      initialData: [],
      builder: (BuildContext context,
          AsyncSnapshot<List<ResumeBookModel>> snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          return BookSection(
            data: snapshot.data,
            myBooksBloc: widget.myBooksBloc,
          );
        }
        return Container();
      },
    );
  }
}
