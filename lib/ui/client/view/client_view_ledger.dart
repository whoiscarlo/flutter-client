import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:invoiceninja_flutter/ui/app/lists/list_divider.dart';
import 'package:invoiceninja_flutter/ui/app/loading_indicator.dart';
import 'package:invoiceninja_flutter/ui/client/view/client_view_vm.dart';
import 'package:invoiceninja_flutter/utils/formatting.dart';

class ClientViewLedger extends StatefulWidget {
  const ClientViewLedger({Key key, this.viewModel}) : super(key: key);

  final ClientViewVM viewModel;

  @override
  _ClientViewLedgerState createState() => _ClientViewLedgerState();
}

class _ClientViewLedgerState extends State<ClientViewLedger> {
  @override
  void didChangeDependencies() {
    if (widget.viewModel.client.areActivitiesStale) {
      widget.viewModel.onRefreshed(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final client = widget.viewModel.client;

    if (client.areActivitiesStale) {
      return LoadingIndicator();
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: client.ledger.length,
      separatorBuilder: (context, index) => ListDivider(),
      itemBuilder: (BuildContext context, index) {
        final ledger = client.ledger[index];
        final textTheme = Theme.of(context).textTheme;

        return ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ENTITY'),
              Text(
                formatNumber(ledger.balance, context),
                textAlign: TextAlign.end,
              ),
            ],
          ),
          subtitle: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatDate(
                convertTimestampToDateString(ledger.createdAt),
                context,
                showTime: true,
              )),
              Text(
                formatNumber(ledger.adjustment, context),
                textAlign: TextAlign.end,
              ),
            ],
          ),
        );
      },
    );
  }
}