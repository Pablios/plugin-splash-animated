import { SplashAnimatedPlugin } from 'plugin-splash-animated';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    SplashAnimatedPlugin.echo({ value: inputValue })
}
