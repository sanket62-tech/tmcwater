import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
 import 'package:water_collector/src/features/sample_form/presentation/screens/sample_form.dart' hide AppTheme;
import 'package:water_collector/src/features/history/data/models/sample_history_model.dart';
import 'package:water_collector/src/features/history/data/services/history_api_service.dart';
import 'package:water_collector/src/core/services/storage_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryApiService _historyApi = HistoryApiService();
  final StorageService _storage = StorageService();

  final int _rowsPerPage = 10;
  int _currentPage = 0;
  String _searchQuery = '';
  
  List<WaterSampleDetails> _allHistory = [];
  bool _isLoading = false;
  String? _errorMessage;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userData = await _storage.getUserData();
      if (userData != null && userData.userId != null) {
        _userId = userData.userId;
        final results = await _historyApi.getWaterSampleDetails(userData.userId!);
        if (mounted) {
          setState(() {
            _allHistory = results;
            _isLoading = false;
          });
        }
      } else {
        throw 'User session not found. Please login again.';
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  List<WaterSampleDetails> get _filteredHistory {
    if (_searchQuery.isEmpty) return _allHistory;
    return _allHistory
        .where((record) =>
            record.originalNo.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            record.wardName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            record.sourceType.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<WaterSampleDetails> get _currentData {
    final startIndex = _currentPage * _rowsPerPage;
    return _filteredHistory.skip(startIndex).take(_rowsPerPage).toList();
  }

  int get _totalPages => _filteredHistory.isEmpty ? 1 : (_filteredHistory.length / _rowsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF), // AppTheme.surface from sample_form
      appBar: _buildAppBar(),
      body: SafeArea(
        child: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
            ? _buildErrorState()
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchField(),
                    const SizedBox(height: 20),
                    _buildHistoryCard(),
                  ],
                ),
              ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0D47A1), // AppTheme.primaryDark from sample_form
      foregroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('TMC',
                style: TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jal Namuna',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5)),
              Text('Sample History',
                  style: TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: _fetchHistory,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _fetchHistory, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (v) => setState(() {
          _searchQuery = v;
          _currentPage = 0;
        }),
        decoration: InputDecoration(
          hintText: 'Search by Original No, Ward...',
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF1565C0)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: const Color(0xFF1565C0).withOpacity(0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: const Color(0xFF1565C0).withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF1565C0), width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildHistoryCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.1),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFF1565C0).withOpacity(0.15), width: 1.2),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                const Icon(Icons.history_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                const Text(
                  'Recent Submissions',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${_filteredHistory.length} Records',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Table Header
          _buildTableHeader(),
          
          // List
          _filteredHistory.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: _buildEmptyState(),
                )
              : Column(
                  children: [
                    ...List.generate(_currentData.length, (index) {
                      return _buildHistoryRow(_currentData[index], index == _currentData.length - 1);
                    }),
                    if (_totalPages > 1) ...[
                      const SizedBox(height: 10),
                      _buildPaginationControls(),
                    ],
                    const SizedBox(height: 10),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: const Color(0xFF1565C0).withOpacity(0.04),
      child: Row(
        children: [
          _headerCell('Original No.', 2),
          _headerCell('Ward', 2),
          _headerCell('Type', 2),
          _headerCell('Date', 2),
          _headerCell('Details', 1, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _headerCell(String label, int flex, {TextAlign textAlign = TextAlign.start}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: textAlign,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 11,
          color: Color(0xFF0D47A1), // AppTheme.primaryDark from sample_form
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildHistoryRow(WaterSampleDetails record, bool isLast) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        border: isLast ? null : Border(bottom: BorderSide(color: const Color(0xFF1565C0).withOpacity(0.06))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              record.originalNo,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1565C0)), // AppTheme.primary from sample_form
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(record.wardName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 2,
            child: Text(record.sourceType,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis),
          ),
          Expanded(
            flex: 2,
            child: Text(record.collectionDate, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.visibility_rounded, size: 20, color: Color(0xFF1565C0)), // AppTheme.primary from sample_form
                onPressed: () => _showDetailDialog(record),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(WaterSampleDetails record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFF1565C0), // AppTheme.primary from sample_form
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: Colors.white),
              const SizedBox(width: 10),
              const Text('Sample Details', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailSection('General Info', [
                  _detailRow('Original No', record.originalNo),
                  _detailRow('Status', record.status),
                  _detailRow('Date', record.collectionDate),
                  _detailRow('Time', record.collectedTime),
                ]),
                _detailSection('Collector Info', [
                  _detailRow('Name', record.collectorName),
                  _detailRow('Mobile', record.mobileNumber),
                  _detailRow('Email', record.email),
                ]),
                _detailSection('Location & Source', [
                  _detailRow('Ward', record.wardName),
                  _detailRow('Area', record.areaName),
                  _detailRow('Source Type', record.sourceType),
                  _detailRow('Agency', record.agencyName),
                  _detailRow('Code ID', record.codeId),
                  _detailRow('Code Name', record.codeName),
                  _detailRow('Weather', record.weatherConditions),
                  _detailRow('Lat/Long', '${record.latitude}, ${record.longitude}'),
                ]),
                _detailSection('Testing Info', [
                  _detailRow('Residual Chlorine', record.residualChlorine),
                  _detailRow('Enquiry Type', record.enquiryType),
                  _detailRow('Special Request', record.specialRequestWithReason),
                  _detailRow('Additional Info', record.additionalRelevantInformation),
                  _detailRow('Specific Params', record.specificParametersToBeTested),
                ]),
                _detailSection('Uploaded Documents', [
                  FutureBuilder<List<DocumentModel>>(
                    future: _historyApi.getDocuments(record.originalNo, _userId ?? 0),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('No documents found.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        );
                      }

                      return Column(
                        children: snapshot.data!.map((doc) => _buildDocumentRow(doc)).toList(),
                      );
                    },
                  ),
                ]),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1565C0))),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(DocumentModel doc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.image_rounded, size: 16, color: Color(0xFF1565C0)),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () async {
                try {
                  final uri = Uri.parse(doc.fileUrl);
                  print('Attempting to launch URL: ${doc.fileUrl}');
                  
                  // Try to launch directly if canLaunchUrl is being strict
                  final launched = await launcher.launchUrl(
                    uri, 
                    mode: launcher.LaunchMode.externalApplication,
                  );
                  
                  if (!launched) {
                    print('Could not launch ${doc.fileUrl}');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not open the document link.')),
                      );
                    }
                  }
                } catch (e) {
                  print('Error launching URL: $e');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: Text(
                doc.documentName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1565C0), fontSize: 14)),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TextStyle(fontSize: 12, color: const Color(0xFF37474F).withOpacity(0.7), fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value.isEmpty ? 'N/A' : value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Page ${_currentPage + 1} of $_totalPages',
            style: TextStyle(
              fontSize: 11,
              color: const Color(0xFF37474F).withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              _pageButton(
                icon: Icons.chevron_left_rounded,
                onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
              ),
              const SizedBox(width: 8),
              _pageButton(
                icon: Icons.chevron_right_rounded,
                onPressed: _currentPage < _totalPages - 1 ? () => setState(() => _currentPage++) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pageButton({required IconData icon, VoidCallback? onPressed}) {
    final bool isEnabled = onPressed != null;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isEnabled ? const Color(0xFF1565C0) : const Color(0xFF90A4AE).withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: isEnabled ? Colors.white : const Color(0xFF90A4AE), size: 18),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.search_off_rounded,
          size: 60,
          color: const Color(0xFF90A4AE).withOpacity(0.4),
        ),
        const SizedBox(height: 16),
        Text(
          _searchQuery.isEmpty ? 'No records found' : 'No results for "$_searchQuery"',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF37474F).withOpacity(0.6),
          ),
        ),
        if (_searchQuery.isNotEmpty) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => setState(() {
              _searchQuery = '';
              _currentPage = 0;
            }),
            child: const Text('Clear Search'),
          ),
        ],
      ],
    );
  }
}
