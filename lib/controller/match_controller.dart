import 'package:fantasypremiereleague/apiConfig/api_repo.dart';
import 'package:fantasypremiereleague/model/bootstrap_model.dart';
import 'package:fantasypremiereleague/model/fixture_model.dart';
import 'package:fantasypremiereleague/widgets/custom_toast.dart';
import 'package:get/get.dart';

class MatchController extends GetxController{
  late RxBool isLoading = true.obs;
  List<FixtureModel> matchList = [];
  dynamic bootstrapList = [];
  int currentGw = 0;
  int matchLength = 0;

  // Start Loading
  startLoading(){
    isLoading(true);
    update();
  }

  // Stop Loading
  stopLoading(){
    isLoading(false);
    update();
  }

  getBootstrapList() async {
    startLoading();
    try {
      matchList.clear();
      var response = await ApiRepo.apiGet('bootstrap-static/');
      if(response != null) {
        final allData = BootStrapModel.fromJson(response);
        bootstrapList = allData;
        var filteredEvents = bootstrapList.events!.where((element) => element.isNext == true);
        var eventIds = filteredEvents.map((e) => e.id);
        var firstEventId = eventIds.first; 
        currentGw = firstEventId!.toInt();
        stopLoading();
      }
    } catch (e) {
      showToast(isSuccess: false,message: e.toString(),);
      stopLoading();
    } finally {
      stopLoading();
    }
  }  

  getMatchList() async {
    startLoading();
    try {
      matchList.clear();
      var response = await ApiRepo.apiGet('fixtures/');
      if(response != null) {
        for (var fixture in response) {
          matchList.add(FixtureModel.fromJson(fixture));
        }
        matchLength = matchList
          .where((element) => element.event == currentGw)
          .length;
        stopLoading();
      }
    } catch (e) {
      showToast(isSuccess: false,message: e.toString(),);
      stopLoading();
    } finally {
      stopLoading();
    }
  }
}