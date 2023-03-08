import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repofinderapp/bloc/webview_bloc/webview_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebViewBloc, WebViewState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        // context.read<WebViewCubit>().onLoadUrl();

        context
            .read<WebViewBloc>()
            .add(WebViewLoadEvent(state.url, state.reposName));

        if (state.status == WebViewStatus.success) {
          return Scaffold(
            appBar: AppBar(
              title: Text(state.reposName),
              centerTitle: true,
              actions: [
                _NavigationControls(
                    controller: state.controller!,
                    messenger: ScaffoldMessenger.of(context))
              ],
            ),
            body: WebViewWidget(controller: state.controller!),
          );
        } else if (state.status != WebViewStatus.failure) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text(state.error),
            ),
          );
        }
      },
    );
  }
}

class _NavigationControls extends StatelessWidget {
  const _NavigationControls({
    super.key,
    required this.controller,
    required this.messenger,
  });

  final WebViewController controller;
  final ScaffoldMessengerState messenger;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              messenger.showSnackBar(
                const SnackBar(
                    content: Text('Начальная вкладка текущей сессии')),
              );
              return;
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await controller.canGoForward()) {
              await controller.goForward();
            } else {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Последняя вкладка текущей сессии'),
                ),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () {
            controller.reload();
          },
        ),
      ],
    );
  }
}
