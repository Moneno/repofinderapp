part of 'webview_bloc.dart';

abstract class WebViewEvent extends Equatable {
  const WebViewEvent();

  @override
  List<Object> get props => [];
}

class WebViewInitiateEvent extends WebViewEvent {}

class WebViewLoadEvent extends WebViewEvent {
  final String url;
  final String reposName;
  WebViewLoadEvent(this.url, this.reposName);
  @override
  List<Object> get props => [url, reposName];
}

class WebViewSubmittedEvent extends WebViewEvent {
  WebViewSubmittedEvent(this.url, this.reposName);
  final String url;
  final String reposName;
  @override
  List<Object> get props => [url, reposName];
}
