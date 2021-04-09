import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quan_ly_taiducfood/customer_action/view/customer_Details.dart';
import 'package:quan_ly_taiducfood/models/customer.dart';

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  String selectedResult;
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  final List<Customer> listExmaple;
  Search(this.listExmaple);
  @override
  Widget buildSuggestions(BuildContext context) {
    List<Customer> suggestionList = [];

    query.isEmpty
        ? suggestionList = listExmaple
        : suggestionList.addAll(
            listExmaple.where((element) => element.name.contains(query)));
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index].phone,
          ),
          onTap: () {
            selectedResult = suggestionList[index].id;
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsCustomer(
                    customer: suggestionList[index],
                  ),
                ));
          },
        );
      },
    );
  }
}
