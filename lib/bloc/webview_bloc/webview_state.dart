part of 'webview_bloc.dart';

enum WebViewStatus { initial, submitted, loading, success, failure }

class WebViewState extends Equatable {
  final String url;
  final String reposName;
  final WebViewStatus status;
  final WebViewController? controller;
  final String error;
//
  const WebViewState(
    this.controller, {
    this.url = '',
    this.reposName = '',
    this.status = WebViewStatus.initial,
    this.error = '',
  });

  WebViewState copyWith({
    WebViewController? controller,
    WebViewStatus? status,
    String? url,
    String? reposName,
    String? error,
  }) {
    return WebViewState(controller ?? this.controller,
        reposName: reposName ?? this.reposName,
        url: url ?? this.url,
        status: status ?? this.status,
        error: error ?? this.error);
  }

  @override
  List<Object> get props => [status, url, reposName, error];
}
