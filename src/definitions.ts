export interface SplashAnimatedPluginPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
