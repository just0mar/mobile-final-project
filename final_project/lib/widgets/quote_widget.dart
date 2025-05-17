import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/viewmodels/quote_viewmodel.dart';

class QuoteWidget extends StatefulWidget {
  const QuoteWidget({super.key});

  @override
  State<QuoteWidget> createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget> {
  @override
  void initState() {
    super.initState();
    // Fetch quote when widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuoteViewModel>(context, listen: false).fetchQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuoteViewModel>(
      builder: (context, quoteViewModel, child) {
        if (quoteViewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (quoteViewModel.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Failed to load quote',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        final quote = quoteViewModel.currentQuote;
        if (quote == null) {
          return const SizedBox.shrink();
        }

        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"${quote.quote}"',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '- ${quote.author}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      quote.category,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 