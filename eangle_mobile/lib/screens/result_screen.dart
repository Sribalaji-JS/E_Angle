import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';

class ResultScreen extends StatefulWidget {
  final RecommendationResult result;
  final double inputCapacity;
  final int inputBolts;
  final int inputRows;

  const ResultScreen({
    super.key,
    required this.result,
    required this.inputCapacity,
    required this.inputBolts,
    required this.inputRows,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerCtrl;
  late AnimationController _cardsCtrl;
  late Animation<double> _headerAnim;
  late Animation<double> _cardsAnim;

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _cardsCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _headerAnim =
        CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _cardsAnim =
        CurvedAnimation(parent: _cardsCtrl, curve: Curves.easeOutCubic);

    _headerCtrl.forward().then((_) => _cardsCtrl.forward());
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _cardsCtrl.dispose();
    super.dispose();
  }

  Color get _accuracyColor {
    final acc = widget.result.accuracy.toLowerCase();
    if (acc.contains('high')) return const Color(0xFF2D7A4F);
    if (acc.contains('medium')) return const Color(0xFF7A5C1E);
    return const Color(0xFFB91C1C);
  }

  Color get _accuracyBg {
    final acc = widget.result.accuracy.toLowerCase();
    if (acc.contains('high')) return const Color(0xFFE8F5EE);
    if (acc.contains('medium')) return const Color(0xFFFDF3DC);
    return const Color(0xFFFEE2E2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                FadeTransition(
                  opacity: _cardsAnim,
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, 0.1), end: Offset.zero)
                        .animate(_cardsAnim),
                    child: Column(
                      children: [
                        _buildTechnicalSummary(),
                        const SizedBox(height: 16),
                        _buildDiagramCard(),
                        const SizedBox(height: 16),
                        _buildTechnicalGrid(),
                        const SizedBox(height: 16),
                        _buildAlternativeSection(),
                        const SizedBox(height: 24),
                        _buildActionButtons(context),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader() {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.primaryGradient,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'DESIGN RECOMMENDATION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.result.recommendedSection,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.result.recommendedCapacity.toStringAsFixed(0),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -2,
                        height: 1,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 6, left: 4),
                      child: Text(
                        'kN',
                        style: TextStyle(
                          color: Color(0xFFA8C4E8),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Tensile Capacity',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Widget _buildTechnicalSummary() {
    return _Card(
      headerIcon: Icons.analytics_rounded,
      headerTitle: 'Result Section',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.result.recommendedSection,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _accuracyBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _accuracyColor.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user_rounded,
                        color: _accuracyColor, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      widget.result.accuracy,
                      style: TextStyle(
                        color: _accuracyColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Failure Mode: ${widget.result.failureMode}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'The selected ISA section provides the most material-efficient design satisfying IS 800:2007 requirements.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagramCard() {
    return _Card(
      headerIcon: Icons.image_aspect_ratio_rounded,
      headerTitle: 'Bolt Connection Reference',
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/bolt_connection.jpeg',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey.shade100,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image_outlined, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Diagram Asset Not Found',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Reference Connection Diagram (ISO)',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalGrid() {
    return _Card(
      headerIcon: Icons.grid_view_rounded,
      headerTitle: 'Technical Specification',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth - 12) / 2;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildParamBox('T (MM)', widget.result.t.toString(), itemWidth),
              _buildParamBox(
                  'D - BOLT Ø', widget.result.d.toString(), itemWidth),
              _buildParamBox(
                  'Dh - HOLE Ø', widget.result.dh.toString(), itemWidth),
              _buildParamBox(
                  'P - PITCH', widget.result.p.toString(), itemWidth),
              _buildParamBox('E - EDGE', widget.result.e.toString(), itemWidth),
              _buildParamBox('N - BOLTS', widget.result.n.toString(), itemWidth),
              _buildParamBox('Nr - ROWS', widget.result.nr.toString(), itemWidth),
              _buildParamBox(
                  'SIZE (MM)',
                  '${widget.result.A.toInt()}x${widget.result.B.toInt()}',
                  itemWidth),
            ],
          );
        },
      ),
    );
  }

  Widget _buildParamBox(String label, String value, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.textLight,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeSection() {
    if (widget.result.alternatives.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        _Card(
          headerIcon: Icons.compare_arrows_rounded,
          headerTitle: 'Similar Sections (Alternatives)',
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.result.alternatives.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final alt = widget.result.alternatives[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alt.designation,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${alt.designation} mm · t=${alt.t.toStringAsFixed(0)}mm · d=${alt.d.toStringAsFixed(0)}mm · n=${alt.n} · Nr=${alt.nr} · Failure governed by ${alt.failure}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${alt.capacity.toStringAsFixed(0)} kN',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _exportToPDF,
              borderRadius: BorderRadius.circular(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.picture_as_pdf_rounded, 
                                    color: Color(0xFFF1F5F9), size: 20),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'EXPORT TECHNICAL REPORT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.refresh_rounded, size: 20),
            label: const Text('New Parameter Search'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _exportToPDF() async {
    final pdf = pw.Document();

    // Load assets
    pw.MemoryImage? logoImage;
    pw.MemoryImage? diagramImage;
    try {
      final logoBytes = await rootBundle.load('assets/images/eangle_app_icon.png');
      logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
      
      final diagBytes = await rootBundle.load('assets/images/bolt_connection.jpeg');
      diagramImage = pw.MemoryImage(diagBytes.buffer.asUint8List());
    } catch (e) {
      debugPrint('Error loading images for PDF: $e');
    }

    // Modern technical style colors
    const primaryBlue = PdfColor.fromInt(0xFF1A2E52);
    const accentBlue = PdfColor.fromInt(0xFF2C4A7C);
    const lightBlue = PdfColor.fromInt(0xFFF8FAFC);
    const dividerColor = PdfColor.fromInt(0xFFE2E8F0);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        footer: (pw.Context context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
          decoration: const pw.BoxDecoration(
            border: pw.Border(top: pw.BorderSide(color: dividerColor, width: 0.5)),
          ),
          child: pw.Padding(
            padding: const pw.EdgeInsets.only(top: 5),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('IS 800:2007 Compliant Design Report',
                    style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                pw.Text('Generated by EAngle Assistant - Page ${context.pageNumber} of ${context.pagesCount}',
                    style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
              ],
            ),
          ),
        ),
        build: (pw.Context context) {
          return [
            // 1. Branding Header (Centered)
            pw.Center(
              child: pw.Column(
                children: [
                  if (logoImage != null)
                    pw.Container(
                      height: 50,
                      width: 50,
                      child: pw.Image(logoImage),
                    ),
                  pw.SizedBox(height: 8),
                  pw.Text('E_Angle',
                      style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryBlue)),
                  pw.Text('PRECISION STEEL DESIGN',
                      style: pw.TextStyle(
                          fontSize: 9,
                          letterSpacing: 2,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey600)),
                ],
              ),
            ),
            pw.SizedBox(height: 24),
            pw.Divider(color: primaryBlue, thickness: 1.5),
            pw.SizedBox(height: 12),

            // 2. Report Title
            pw.Center(
              child: pw.Text('TECHNICAL DESIGN REPORT',
                  style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryBlue,
                      letterSpacing: 1)),
            ),
            pw.SizedBox(height: 6),
            pw.Center(
              child: pw.Text('Date: ${DateTime.now().toString().split(' ')[0]} | Analysis ID: ${widget.result.recommendedSection}_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
            ),
            pw.SizedBox(height: 32),

            // 3. Design Input Summary
            _pwBuildSectionTitle('1. DESIGN PARAMETERS', primaryBlue),
            pw.SizedBox(height: 12),
            pw.Row(
              children: [
                _pwBuildParamBox('Target Capacity', '${widget.inputCapacity} kN', 130),
                pw.SizedBox(width: 12),
                _pwBuildParamBox('Total Bolts (n)', '${widget.inputBolts}', 130),
                pw.SizedBox(width: 12),
                _pwBuildParamBox('Rows (nr)', '${widget.inputRows}', 130),
              ],
            ),
            pw.SizedBox(height: 32),

            // 4. Recommendation (Hero)
            _pwBuildSectionTitle('2. OPTIMAL RECOMMENDATION', primaryBlue),
            pw.SizedBox(height: 12),
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: lightBlue,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                border: pw.Border.all(color: const PdfColor.fromInt(0x4D2C4A7C), width: 1),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Recommended ISA Section',
                              style: pw.TextStyle(fontSize: 10, color: accentBlue)),
                          pw.Text(widget.result.recommendedSection,
                              style: pw.TextStyle(
                                  fontSize: 22,
                                  fontWeight: pw.FontWeight.bold,
                                  color: primaryBlue)),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text('Achieved Capacity',
                              style: pw.TextStyle(fontSize: 10, color: accentBlue)),
                          pw.Text('${widget.result.recommendedCapacity} kN',
                              style: pw.TextStyle(
                                  fontSize: 22,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.green800)),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 12),
                  pw.Divider(color: dividerColor, thickness: 0.5),
                  pw.SizedBox(height: 8),
                  pw.Text('Failure Governance: ${widget.result.failureMode}',
                      style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey800)),
                ],
              ),
            ),
            pw.SizedBox(height: 32),

            // 5. Technical Specifications & Diagram
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _pwBuildSectionTitle('3. TECHNICAL SPECIFICATIONS', primaryBlue),
                      pw.SizedBox(height: 12),
                      pw.Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _pwBuildSmallSpec('Thickness (t)', '${widget.result.t} mm'),
                          _pwBuildSmallSpec('Bolt Dia (d)', '${widget.result.d} mm'),
                          _pwBuildSmallSpec('Hole Dia (dh)', '${widget.result.dh} mm'),
                          _pwBuildSmallSpec('Pitch (p)', '${widget.result.p} mm'),
                          _pwBuildSmallSpec('Edge Dist (e)', '${widget.result.e} mm'),
                          _pwBuildSmallSpec('Section A', '${widget.result.A} mm'),
                          _pwBuildSmallSpec('Section B', '${widget.result.B} mm'),
                          _pwBuildSmallSpec('Accuracy', widget.result.accuracy),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 20),
                if (diagramImage != null)
                  pw.Expanded(
                    flex: 2,
                    child: pw.Column(
                      children: [
                        _pwBuildSectionTitle('REFERENCE', primaryBlue),
                        pw.SizedBox(height: 12),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(4),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: dividerColor),
                            borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                          ),
                          child: pw.Image(diagramImage, height: 140),
                        ),
                        pw.SizedBox(height: 6),
                        pw.Text('Bolt Connection Diagram',
                            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
                      ],
                    ),
                  ),
              ],
            ),
            pw.SizedBox(height: 32),

            // 6. Alternatives
            if (widget.result.alternatives.isNotEmpty) ...[
              _pwBuildSectionTitle('4. SIMILAR SECTIONS (ALTERNATIVES)', primaryBlue),
              pw.SizedBox(height: 12),
              pw.Column(
                children: widget.result.alternatives.map((alt) {
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: dividerColor),
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(alt.designation,
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 12,
                                    color: primaryBlue)),
                            pw.Text(
                                't=${alt.t} | d=${alt.d} | n=${alt.n} | nr=${alt.nr} | ${alt.failure}',
                                style: const pw.TextStyle(
                                    fontSize: 9, color: PdfColors.grey700)),
                          ],
                        ),
                        pw.Text('${alt.capacity.toStringAsFixed(1)} kN',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 13,
                                color: accentBlue)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'EAngle_Report_${widget.result.recommendedSection}.pdf',
    );
  }

  pw.Widget _pwBuildSectionTitle(String title, PdfColor color) {
    return pw.Text(title,
        style: pw.TextStyle(
            fontSize: 11, fontWeight: pw.FontWeight.bold, color: color, letterSpacing: 0.5));
  }

  pw.Widget _pwBuildParamBox(String label, String value, double width) {
    return pw.Container(
      width: width,
      padding: const pw.EdgeInsets.all(8),
      decoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFF1F5F9),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
          pw.SizedBox(height: 2),
          pw.Text(value,
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColor.fromInt(0xFF1E293B))),
        ],
      ),
    );
  }

  pw.Widget _pwBuildSmallSpec(String label, String value) {
    return pw.Container(
      width: 85,
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: const PdfColor.fromInt(0xFFE2E8F0)),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600)),
          pw.SizedBox(height: 2),
          pw.Text(value,
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),
        ],
      ),
    );
  }
}

// ── Reusable Card widget ─────────────────────────────────
class _Card extends StatelessWidget {
  final IconData headerIcon;
  final String headerTitle;
  final Widget child;
  final Gradient? gradient;

  const _Card({
    required this.headerIcon,
    required this.headerTitle,
    required this.child,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final hasGradient = gradient != null;
    return Container(
      decoration: BoxDecoration(
        color: hasGradient ? null : AppColors.surface,
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        border: hasGradient
            ? null
            : Border.all(color: const Color(0xFFDDE2EC)),
        boxShadow: [
          BoxShadow(
            color: hasGradient
                ? const Color(0xFF4338CA).withOpacity(0.2)
                : AppColors.primary.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(headerIcon,
                    color: hasGradient ? Colors.white : AppColors.primary,
                    size: 18),
                const SizedBox(width: 8),
                Text(
                  headerTitle,
                  style: TextStyle(
                    color: hasGradient ? Colors.white : AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: hasGradient
                ? Colors.white.withOpacity(0.15)
                : const Color(0xFFDDE2EC),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}
