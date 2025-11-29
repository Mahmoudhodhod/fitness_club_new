import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:utilities/utilities.dart';

import 'package:the_coach/Helpers/colors.dart';
import 'package:the_coach/Widgets/widgets.dart';
import 'package:the_coach/generated/locale_keys.g.dart';

class OfferingSheet extends StatelessWidget {
  const OfferingSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .7,
      builder: (context, scrollController) {
        return Container(
          color: CColors.nullableSwitchable(context,
              light: Colors.grey.shade100, dark: CColors.darkerBlack),
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: BlocBuilder<FetchPackagesCubit, FetchPackagesState>(
              builder: (context, state) {
                if (state is FetchPackagesFialure) {
                  return Center(
                    child: Text(
                      LocaleKeys.error_error_happened_because.tr(
                        namedArgs: {
                          'cause': state.e.toString(),
                        },
                      ),
                    ),
                  );
                } else if (state is FetchPackagesSucceeded) {
                  final packages = state.packages;
                  if (packages.isEmpty) {
                    return Center(
                      child: Text(
                        LocaleKeys.payment_general_titles_no_packages_found
                            .tr(),
                      ),
                    );
                  }
                  return _buildBody(scrollController, packages);
                }

                return const Center(
                    child: CircularProgressIndicator.adaptive());
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(ScrollController controller, List<Package> packages) {
    return ListView.builder(
      itemCount: packages.length,
      controller: controller,
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 40),
      itemBuilder: (context, index) {
        final package = packages[index];
        final product = package.storeProduct;
        return InkWell(
          onTap: () => Navigator.pop(context, package),
          borderRadius: BorderRadius.circular(15),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(product.title,
                    style: Theme.of(context).textTheme.titleLarge),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Space.v10(),
                    Text(
                      product.description,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                trailing: Text(
                  product.priceString,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CColors.primary(context),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

String formateCurrency(num number) {
  return NumberFormat.currency(decimalDigits: 2, symbol: 'EGP-')
      .format(number)
      .split("-")
      .reversed
      .join(" ");
}
