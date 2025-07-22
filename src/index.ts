import { registerPlugin } from '@capacitor/core';

import type { SplashAnimatedPluginPlugin } from './definitions';

const SplashAnimatedPlugin = registerPlugin<SplashAnimatedPluginPlugin>('SplashAnimatedPlugin', {
  web: () => import('./web').then((m) => new m.SplashAnimatedPluginWeb()),
});

export * from './definitions';
export { SplashAnimatedPlugin };
