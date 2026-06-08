import 'package:flutter/material.dart';
import 'package:water_collector/src/features/sample_form/presentation/screens/sample_form.dart';
import 'package:water_collector/src/features/history/presentation/screens/history_screen.dart';
import 'package:water_collector/src/features/settings/presentation/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0; // Start with the Home (History)
  final PageController _pageController = PageController(initialPage: 0);
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void setPage(int index) {
    if (_currentIndex == index) return;
    
    // Always unfocus when switching pages to ensure keyboard is closed
    FocusScope.of(context).unfocus();

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Trigger selection animation
    _animationController.forward(from: 0.0);
  }

  void _onItemTapped(int index) {
    setPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HistoryScreen(),
          SampleCollectionFormPage(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home'),
              _buildNavItem(1, Icons.assignment_rounded, 'Form'),
              _buildNavItem(2, Icons.settings_outlined, 'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        splashColor: AppTheme.primary.withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: ScaleTransition(
          scale: isSelected ? _scaleAnimation : const AlwaysStoppedAnimation(1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(isSelected ? 8 : 0),
                decoration: isSelected 
                  ? BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.primaryDark, AppTheme.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    )
                  : null,
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : AppTheme.hintColor,
                  size: 24,
                ),
              ),
              if (!isSelected) const SizedBox(height: 4),
              if (isSelected) const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppTheme.primary : AppTheme.hintColor,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
