import 'package:agriplant/data/products.dart';
import 'package:agriplant/models/order.dart';
import 'package:agriplant/utils/enum/order.dart';
String x = 'Delivered';
List<Order> orders = [
  Order(
    id: "202304a5",
    products: products.reversed.take(3).toList() +
        products.reversed.skip(2).take(3).toList(),
    orderingDate: DateTime.utc(2022, 1, 1),
    deliveringDate: DateTime.utc(2022, 2, 1),
    status: OrderStatus.Delivered,
  ),
  Order(
    id: "1031375",
    products:
        products.skip(2).take(3).toList() + products.reversed.take(3).toList(),
    orderingDate: DateTime.utc(2022, 3, 1),
    deliveringDate: DateTime.utc(2022, 5, 1),
    status: OrderStatus.Picking,
  ),
  Order(
    id: "312304a5",
    products: products.take(1).toList() +
        products.take(3).toList() +
        products.take(1).toList(),
    orderingDate: DateTime.utc(2022, 7, 1),
    deliveringDate: DateTime.utc(2022, 10, 1),
    status: OrderStatus.Processing,
  ),
  Order(
    id: "412304a5",
    products:
        products.reversed.take(3).toList() + products.skip(3).take(4).toList(),
    orderingDate: DateTime.utc(2022, 11, 1),
    deliveringDate: DateTime.utc(2022, 21, 1),
    status: OrderStatus.Shipping,
  ),
  Order(
    id: "512304a5",
    products: products.skip(1).take(4).toList(),
    orderingDate: DateTime.utc(2022, 11, 1),
    deliveringDate: DateTime.utc(2022, 21, 1),
    status: OrderStatus.Shipping,
  ),
  Order(
    id: "412304a5",
    products:
        products.reversed.take(1).toList() + products.reversed.take(1).toList(),
    orderingDate: DateTime.utc(2022, 11, 1),
    deliveringDate: DateTime.utc(2022, 21, 1),
    status: OrderStatus.Processing,
  ),
  Order(
    id: "512304a5",
    products:
        products.skip(1).take(4).toList() + products.skip(1).take(2).toList(),
    orderingDate: DateTime.utc(2022, 11, 1),
    deliveringDate: DateTime.utc(2022, 21, 1),
    status: OrderStatus.Processing,
  ),
];
