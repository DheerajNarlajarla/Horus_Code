// ==UserScript==
// @name           Custom Theme Loader
// @namespace      CustomVSCode
// @version        1.0
// @description    Loads custom themes for VSCode
// @match          *
// @grant          none
// ==/UserScript==

(function() {
    'use strict';

    // Load the custom theme CSS
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.type = 'text/css';
    link.href = 'out/vs/workbench/browser/media/my-custom-theme.css';
    document.head.appendChild(link);
})();
