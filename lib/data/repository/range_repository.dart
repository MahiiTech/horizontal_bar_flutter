
import '../models/range_model.dart';
import '../services/api_service.dart';

class RangeRepository {
  final RangeApiService _apiService;

  RangeRepository(this._apiService);

  Future<List<RangeModel>> getRanges() {
    return _apiService.fetchRanges();
  }
}
