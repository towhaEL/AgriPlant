import 'package:agriplant/models/service.dart';
import 'package:agriplant/repositories/services_repository.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController{
  static ServiceController get instance => Get.find();

  final isLoading = false.obs;
  final _serviceRepository = Get.put(ServiceRepository());
  RxList<Service> allServices = <Service>[].obs;

  @override
  void onInit() {
    fetchServices();
    super.onInit();
  }

  // Load service data
  Future<void> fetchServices() async {
    try {
      isLoading.value = true;

      final services = await _serviceRepository.getAllServices();

      allServices.assignAll(services);
      print(allServices);
    } catch (e) {
      
    } finally {
      isLoading.value = false;

    }
  }

}