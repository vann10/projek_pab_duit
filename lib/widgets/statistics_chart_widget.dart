import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:projek_pab_duit/themes/colors.dart';
import 'package:projek_pab_duit/screens/statistic_page.dart';

class StatisticsChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final List<String> titles;
  final StatPeriod selectedPeriod;
  final StatType selectedType;

  const StatisticsChartWidget({
    super.key,
    required this.spots,
    required this.titles,
    required this.selectedPeriod,
    required this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    // Kalkulasi nilai min dan max secara dinamis
    double minX = 0;
    double maxX = _getMaxX();
    double minY = 0;
    double maxY = _getMaxY();

    return Stack(
      children: [
        LineChart(
          LineChartData(
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              drawHorizontalLine: true,
              horizontalInterval: maxY > 0 ? maxY / 5 : 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.2),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 60,
                  interval: maxY > 0 ? maxY / 4 : 1,
                  getTitlesWidget: (value, meta) => _buildLeftTitle(value, meta),
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 60,
                  interval: 1,
                  getTitlesWidget: (value, meta) => _buildBottomTitle(value, meta),
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineTouchData: _buildLineTouchData(),
            lineBarsData: [_buildLineChartBarData()],
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  // Kalkulasi maxX berdasarkan data yang ada
  double _getMaxX() {
    if (spots.isEmpty) return 13; // fallback
    
    switch (selectedPeriod) {
      case StatPeriod.Daily:
        return 29; // 30 hari (0-29)
      case StatPeriod.Monthly:
        return 13; // 12 bulan + padding (0-13)
      case StatPeriod.Yearly:
        return 6; // 5 tahun + padding (0-6)
    }
  }

  // Kalkulasi maxY berdasarkan nilai tertinggi dalam data
  double _getMaxY() {
    if (spots.isEmpty) return 10; // fallback
    
    double maxValue = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    
    // Tambahkan margin 20% untuk tampilan yang lebih baik
    return maxValue * 1.2;
  }

  // Widget untuk label kiri (nilai)
  Widget _buildLeftTitle(double value, TitleMeta meta) {
    if (value == 0) return const SizedBox();
    
    String text = _formatYAxisValue(value);
    
    return SideTitleWidget(
      meta: meta,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // Format nilai Y-axis berdasarkan periode
  String _formatYAxisValue(double value) {
    switch (selectedPeriod) {
      case StatPeriod.Daily:
        // Nilai dalam ribuan
        if (value >= 1) {
          return '${value.toInt()}K';
        } else {
          return '${(value * 1000).toInt()}';
        }
      case StatPeriod.Monthly:
      case StatPeriod.Yearly:
        // Nilai dalam jutaan
        if (value >= 1) {
          return '${value.toInt()}M';
        } else {
          return '${(value * 1000).toInt()}K';
        }
    }
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    // Kondisi untuk memastikan hanya menggambar di titik bilangan bulat
    if (value != value.roundToDouble()) {
      return const SizedBox();
    }

    // Guard clause untuk memastikan indeks tidak di luar jangkauan
    if (value.toInt() >= titles.length || value.toInt() < 0) {
      return const SizedBox();
    }

    // Tentukan highlighting berdasarkan periode
    bool isHighlighted = _shouldHighlight(value.toInt());
    
    // Untuk daily, tampilkan label setiap 5 hari
    if (selectedPeriod == StatPeriod.Daily && value.toInt() % 5 != 0) {
      return const SizedBox();
    }

    return SideTitleWidget(
      meta: meta,
      space: 10,
      angle: selectedPeriod == StatPeriod.Daily ? 0.8 : 0.3, // rotasi berdasarkan periode
      child: Text(
        titles[value.toInt()],
        style: TextStyle(
          color: isHighlighted ? const Color(0xFF00E5FF) : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: selectedPeriod == StatPeriod.Daily ? 10 : 12,
        ),
      ),
    );
  }

  // Tentukan item mana yang harus di-highlight
  bool _shouldHighlight(int index) {
    switch (selectedPeriod) {
      case StatPeriod.Daily:
        // Highlight hari ini (index terakhir dengan data)
        return index == 29;
      case StatPeriod.Monthly:
        // Highlight bulan saat ini
        return index == DateTime.now().month;
      case StatPeriod.Yearly:
        // Highlight tahun saat ini
        return index == 5; // index terakhir untuk tahun current
    }
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => Colors.black87,
        tooltipBorderRadius: BorderRadius.all(Radius.zero),
        tooltipPadding: const EdgeInsets.all(8),
        getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            String value = _formatTooltipValue(spot.y);
            String period = _getTooltipPeriod(spot.x.toInt());
            
            return LineTooltipItem(
              '$period\n$value',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          }).toList();
        },
      ),
      getTouchedSpotIndicator: (barData, spotIndexes) {
        return spotIndexes.map((spotIndex) {
          return TouchedSpotIndicatorData(
            FlLine(
              color: const Color(0xFF00E5FF),
              strokeWidth: 2,
              dashArray: [5, 5],
            ),
            FlDotData(
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 6,
                  color: const Color(0xFF00E5FF),
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
          );
        }).toList();
      },
    );
  }

  // Format nilai untuk tooltip
  String _formatTooltipValue(double value) {
    switch (selectedPeriod) {
      case StatPeriod.Daily:
        double actualValue = value * 1000; // Convert back from K
        return 'Rp${_formatNumber(actualValue)}';
      case StatPeriod.Monthly:
      case StatPeriod.Yearly:
        double actualValue = value * 1000000; // Convert back from M
        return 'Rp${_formatNumber(actualValue)}';
    }
  }

  // Format angka dengan separator
  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }

  // Dapatkan label periode untuk tooltip
  String _getTooltipPeriod(int index) {
    if (index >= titles.length || index < 0) return '';
    return titles[index];
  }

  LineChartBarData _buildLineChartBarData() {
    // Ubah warna berdasarkan tipe
    Color lineColor = selectedType == StatType.Income 
        ? const Color(0xFF4CAF50) 
        : const Color(0xFF00E5FF);
    
    Color gradientStart = selectedType == StatType.Income
        ? const Color(0xFF4CAF50).withOpacity(0.3)
        : const Color(0xFF00A6C2).withOpacity(0.3);

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.3,
      barWidth: 3,
      color: lineColor,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: lineColor,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            gradientStart,
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}