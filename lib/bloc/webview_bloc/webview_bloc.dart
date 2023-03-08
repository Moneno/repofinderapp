import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'webview_event.dart';
part 'webview_state.dart';

class WebViewBloc extends Bloc<WebViewEvent, WebViewState> {
  WebViewBloc() : super(const WebViewState(null)) {
    on<WebViewLoadEvent>(_onLoadUrl);
    on<WebViewSubmittedEvent>(_onTap);
  }

  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://github.com/')) {
            return NavigationDecision.navigate;
          }
          return NavigationDecision.prevent;
        },
      ),
    );

  void _onLoadUrl(WebViewLoadEvent event, Emitter<WebViewState> emit) {
    if (state.status == WebViewStatus.success) return;

    emit(state.copyWith(status: WebViewStatus.loading));
    try {
      controller.loadRequest(Uri.parse(event.url));
      emit(state.copyWith(
          controller: controller,
          status: WebViewStatus.success,
          error: '',
          url: event.url,
          reposName: event.reposName));
    } catch (e) {
      emit(state.copyWith(status: WebViewStatus.failure, error: e.toString()));
    }
  }

  void _onTap(WebViewSubmittedEvent event, Emitter<WebViewState> emit) {
    emit(state.copyWith(
        status: WebViewStatus.submitted,
        url: event.url,
        reposName: event.reposName));
  }
}
