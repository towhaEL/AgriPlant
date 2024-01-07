import 'package:agriplant/controllers/user_controller.dart';
import 'package:agriplant/models/order.dart';
import 'package:agriplant/utils/enum/extensions/date.dart';
import 'package:agriplant/utils/enum/order.dart';
import 'package:agriplant/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:get/get.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());

    const steps = OrderStatus.values;
    final activeStep = steps.indexOf(order.status);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Order details"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            EasyStepper(
              activeStep:
                  activeStep == steps.length - 1 ? activeStep + 1 : activeStep,
              stepRadius: 8,
              activeStepTextColor: Colors.black87,
              finishedStepTextColor: Theme.of(context).colorScheme.primary,
              unreachedStepTextColor: Colors.red.shade300,
              lineStyle: LineStyle(
                defaultLineColor: Colors.grey.shade300,
                lineLength:
                    MediaQuery.of(context).size.width * (.6 / steps.length),
                activeLineColor: Theme.of(context).colorScheme.primary,
              ),
              steps: List.generate(
                steps.length,
                (index) {
                  return EasyStep(
                    icon: const Icon(Icons.local_shipping),
                    finishIcon: const Icon(Icons.done),
                    title: steps[index].name,
                    topTitle: true,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 0.1,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                side: BorderSide(
                  width: 0.2,
                  color: Colors.grey.shade400,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ("Order: ${order.id}#${order.orderingDate.hashCode}"),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Chip(
                            shape: const StadiumBorder(),
                            side: BorderSide.none,
                            label: Text(steps[activeStep].name),
                            avatar: const Icon(Icons.local_shipping_outlined),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(0.3),
                            labelPadding: EdgeInsets.zero,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Delivery estimate",
                          ),
                          Text(
                            order.deliveringDate.formatDate,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      userController.user.value.fullname,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.home_outlined,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            child: Text('${userController.user.value.address}\n${userController.user.value.city}-${userController.user.value.postCode}')),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                        ),
                        SizedBox(width: 10),
                        Expanded(child: Text(userController.user.value.phoneNumber)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.payment_outlined,
                        ),
                        SizedBox(width: 10),
                        Text("Payment method"),
                        Spacer(),
                        Text(
                          "Credit Card **1234",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            OrderItem(order: order, visibleProduct: 1, isClickable: false),
          ],
        ));
  }
}
