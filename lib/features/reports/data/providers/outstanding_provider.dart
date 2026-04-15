import 'package:flutter/foundation.dart';
import '../models/outstanding_model.dart';
import '../services/outstanding_service.dart';

class OutstandingProvider extends ChangeNotifier {
  final OutstandingService _service = OutstandingService();

  // Data states
  List<OutstandingItem> _reportItems = [];
  OutstandingSummary? _summary;
  List<String> _stations = [];
  List<String> _groups = [];
  
  // Selection state
  final Set<int> _selectedIndices = {};

  // Filter states
  DateTime _fromDate = DateTime.now();
  String _type = 'receivable';
  String _stationName = '';
  String _groupName = '';
  String _searchText = '';

  // Loading/Error states
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _error;

  // Getters
  List<OutstandingItem> get reportItems => _reportItems;
  OutstandingSummary? get summary => _summary;
  List<String> get stations => _stations;
  List<String> get groups => _groups;
  Set<int> get selectedIndices => _selectedIndices;

  DateTime get fromDate => _fromDate;
  String get type => _type;
  String get stationName => _stationName;
  String get groupName => _groupName;
  String get searchText => _searchText;

  bool get isLoading => _isLoading;
  bool get hasSearched => _hasSearched;
  String? get error => _error;

  // Setters
  void setFromDate(DateTime date) {
    _fromDate = date;
    notifyListeners();
  }

  void setType(String type) {
    _type = type;
    notifyListeners();
  }

  void setStationName(String name) {
    _stationName = name;
    notifyListeners();
  }

  void setGroupName(String name) {
    _groupName = name;
    notifyListeners();
  }

  void setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  // Row Selection logic
  void toggleSelection(int index) {
    if (_selectedIndices.contains(index)) {
      _selectedIndices.remove(index);
    } else {
      _selectedIndices.add(index);
    }
    notifyListeners();
  }

  void toggleSelectAll(bool select) {
    if (select) {
      _selectedIndices.clear();
      for (int i = 0; i < _reportItems.length; i++) {
        _selectedIndices.add(i);
      }
    } else {
      _selectedIndices.clear();
    }
    notifyListeners();
  }

  bool isSelected(int index) => _selectedIndices.contains(index);
  bool get isAllSelected => _reportItems.isNotEmpty && _selectedIndices.length == _reportItems.length;

  // Fetch Options
  Future<void> fetchOptions() async {
    try {
      final results = await Future.wait([
        _service.getStations(),
        _service.getGroups(),
      ]);
      _stations = results[0];
      _groups = results[1];
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching outstanding options: $e");
    }
  }

  // Fetch Report
  Future<void> fetchReport() async {
    _isLoading = true;
    _error = null;
    _selectedIndices.clear();
    notifyListeners();

    try {
      final params = {
        'type': _type,
        'fromDate': _fromDate.toIso8601String().split('T')[0],
        'stationName': _stationName.isNotEmpty ? _stationName : null,
        'groupName': _groupName.isNotEmpty ? _groupName : null,
        'search': _searchText.isNotEmpty ? _searchText : null,
      };

      final res = await _service.getOutstandingReport(params);
      final responseObj = OutstandingReportResponse.fromJson(res);
      
      _reportItems = responseObj.data;
      _summary = responseObj.summary;
      _hasSearched = true;
    } catch (e) {
      _error = e.toString();
      debugPrint("Error fetching outstanding report: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset Filters
  void resetFilters() {
    _fromDate = DateTime.now();
    _type = 'receivable';
    _stationName = '';
    _groupName = '';
    _searchText = '';
    _reportItems = [];
    _summary = null;
    _hasSearched = false;
    _selectedIndices.clear();
    _error = null;
    notifyListeners();
  }
}
