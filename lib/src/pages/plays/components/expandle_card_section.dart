import 'package:flutter/material.dart';
import 'package:futgolazo/src/components/container_default/contain_default.dart';
import 'package:futgolazo/src/components/custom_scafold/stateless_custom.dart';

typedef ExpandleCardItemBuilder<T> = Widget Function(
    BuildContext context, T item);

class ExpandleCardSection<T> extends StateLessCustom {
  final List<T> data;
  final ExpandleCardItemBuilder<T> itemBuilder;
  final String title;

  /// space bottom card item in list data. Default _responsive.hp(1.25)_
  final double space;

  ExpandleCardSection({
    Key key,
    @required this.itemBuilder,
    this.title,
    this.space,
    this.data = const [],
  })  : assert(data != null, 'Data of component is required'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerDefault(
      padding: EdgeInsets.all(responsive.ip(1.6)),
      background: colorsTheme.getColorOnSurface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeaderSection(),
          SizedBox(height: responsive.hp(1.0)),
          Flexible(
            child: Column(
              children: List.generate(
                data.length,
                (index) => _buildItem(context, data[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title ?? '',
          style: fontSize.headline6(),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, T item) {
    return Column(
      children: [
        itemBuilder(context, item),
        SizedBox(height: space ?? responsive.hp(1.25)),
      ],
    );
  }
}
