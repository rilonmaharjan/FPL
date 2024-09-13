import 'package:fantasypremiereleague/apiConfig/api_repo.dart';
import 'package:fantasypremiereleague/model/league_model.dart';
import 'package:fantasypremiereleague/widgets/custom_toast.dart';
import 'package:get/get.dart';

class FantasyController extends GetxController{
  late RxBool isLoading = true.obs;
  dynamic managersList = [];

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

  getManagersList() async {
    startLoading();
    try {
      managersList.clear();
      var response = await ApiRepo.apiGet('leagues-classic/679963/standings/');
      if(response != null) {
        final allData = LeagueModel.fromJson(response);
        managersList = allData.standings.results;
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