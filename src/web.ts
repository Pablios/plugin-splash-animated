import { WebPlugin } from '@capacitor/core';

import type { SplashAnimatedPluginPlugin } from './definitions';

export class SplashAnimatedPluginWeb extends WebPlugin implements SplashAnimatedPluginPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
