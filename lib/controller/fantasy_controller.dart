import 'package:fantasypremiereleague/apiConfig/api_repo.dart';
import 'package:fantasypremiereleague/model/history_model.dart';
import 'package:fantasypremiereleague/model/league_model.dart';
import 'package:fantasypremiereleague/model/live_model.dart';
import 'package:fantasypremiereleague/model/picks_model.dart';
import 'package:fantasypremiereleague/model/transfer_model.dart';
import 'package:fantasypremiereleague/widgets/custom_toast.dart';
import 'package:get/get.dart';

class FantasyController extends GetxController{
  late RxBool isLoading = true.obs;
  dynamic managersList = [];
  dynamic pickList = [];
  List<TransferModel> transferList = [];
  dynamic historyList = [];
  dynamic liveList = [];

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

  fetchTeamPicks(int teamId, int gw)  async {
    startLoading();
    try {
      var response = await ApiRepo.apiGet('entry/$teamId/event/$gw/picks/');
      if(response != null) {
        final allData = PicksModel.fromJson(response);
        pickList = allData;
        stopLoading();
      }
    } catch (e) {
      showToast(isSuccess: false,message: e.toString(),);
      stopLoading();
    } finally {
      stopLoading();
    }
  }

  fetchTransfer(int teamId)  async {
    startLoading();
    try {
      transferList.clear();
      var response = await ApiRepo.apiGet('entry/$teamId/transfers/');
      if(response != null) {
        for (var allData in response) {
          transferList.add(TransferModel.fromJson(allData));
        }
        stopLoading();
      }
    } catch (e) {
      showToast(isSuccess: false,message: e.toString(),);
      stopLoading();
    } finally {
      stopLoading();
    }
  }

  fetchHistory(int teamId)  async {
    startLoading();
    try {
      var response = await ApiRepo.apiGet('entry/$teamId/history/');
      if(response != null) {
        final allData = HistoryModel.fromJson(response);
        historyList = allData;
        stopLoading();
      }
    } catch (e) {
      showToast(isSuccess: false,message: e.toString(),);
      stopLoading();
    } finally {
      stopLoading();
    }
  }

  fetchLive(int gw)  async {
    startLoading();
    try {
      var response = await ApiRepo.apiGet('event/$gw/live/');
      if(response != null) {
        final allData = LiveModel.fromJson(response);
        liveList = allData;
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