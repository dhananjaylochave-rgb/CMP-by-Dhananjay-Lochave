/*
  CUSTOM CMP BANNER SCRIPT
  ========================
  Loaded by the GTM template (template.tpl) via injectScript, OR can be
  self-hosted directly on the site (see README "Option B").

  Reads config (cookie name / retention) from window.__cmpConfig, which
  the GTM template sets via setInWindow before injecting this script. If
  loaded standalone (not via the GTM tag), sensible defaults are used.

  Buttons:
  - "Accept All"   -> everything granted.
  - "Reject All"   -> everything non-essential denied.
  - "Necessary Only" -> toggles an inline panel with a checkbox per
    consent type (analytics_storage checked by default). Both the
    "Update" button AND the "x" close icon in that panel apply whatever
    is currently checked — closing the panel is not a cancel, it's a
    save-and-close, same as clicking Update.

  functionality_storage and security_storage are always "granted"
  (strictly necessary) and are not shown as checkboxes.
*/

(function () {
  'use strict';

  var cfg = window.__cmpConfig || {};
  var COOKIE_NAME = cfg.cookieName || 'cmp_consent';
  var COOKIE_DAYS = cfg.cookieDays || 180;

  // Configurable categories shown as checkboxes in the "Necessary Only" panel.
  var CONSENT_FIELDS = [
    { key: 'analytics_storage', label: 'Analytics (site usage measurement)', defaultChecked: true },
    { key: 'ad_storage', label: 'Advertising storage', defaultChecked: false },
    { key: 'ad_user_data', label: 'Advertising: share data with Google', defaultChecked: false },
    { key: 'ad_personalization', label: 'Advertising: personalization', defaultChecked: false },
    { key: 'personalization_storage', label: 'Personalization (non-ad)', defaultChecked: false }
  ];

  function setCookie(name, value, days) {
    var expires = '';
    if (days) {
      var date = new Date();
      date.setTime(date.getTime() + days * 24 * 60 * 60 * 1000);
      expires = '; expires=' + date.toUTCString();
    }
    document.cookie = name + '=' + encodeURIComponent(value) + expires + '; path=/; SameSite=Lax';
  }

  function getCookie(name) {
    var match = document.cookie.match(new RegExp('(?:^|; )' + name + '=([^;]*)'));
    return match ? decodeURIComponent(match[1]) : null;
  }

  function pushConsent(consent) {
    window.dataLayer = window.dataLayer || [];
    function gtag() { window.dataLayer.push(arguments); }
    gtag('consent', 'update', consent);
    window.dataLayer.push({ event: 'cmp_consent_update', cmp_consent_state: consent });
  }

  function fullConsent(mode) {
    var granted = mode === 'accept_all';
    var c = {};
    CONSENT_FIELDS.forEach(function (f) { c[f.key] = granted ? 'granted' : 'denied'; });
    c.functionality_storage = 'granted';
    c.security_storage = 'granted';
    return c;
  }

  function consentFromCheckboxes(panel) {
    var c = {};
    CONSENT_FIELDS.forEach(function (f) {
      var box = panel.querySelector('[data-key="' + f.key + '"]');
      c[f.key] = box && box.checked ? 'granted' : 'denied';
    });
    c.functionality_storage = 'granted';
    c.security_storage = 'granted';
    return c;
  }

  function saveAndApply(consent, mode) {
    pushConsent(consent);
    setCookie(
      COOKIE_NAME,
      JSON.stringify({ mode: mode, consent: consent, ts: Date.now() }),
      COOKIE_DAYS
    );
    hideBanner();
  }

  function hideBanner() {
    var el = document.getElementById('cmp-banner');
    if (el && el.parentNode) el.parentNode.removeChild(el);
  }

  function buildPanelHTML() {
    var rows = CONSENT_FIELDS.map(function (f) {
      return (
        '<label class="cmp-check">' +
          '<input type="checkbox" data-key="' + f.key + '"' + (f.defaultChecked ? ' checked' : '') + '>' +
          '<span>' + f.label + '</span>' +
        '</label>'
      );
    }).join('');

    return (
      '<div class="cmp-panel" id="cmp-panel" hidden>' +
        '<div class="cmp-panel__header">' +
          '<span>Manage preferences</span>' +
          '<button type="button" class="cmp-panel__close" id="cmp-panel-close" aria-label="Save and close">&times;</button>' +
        '</div>' +
        '<div class="cmp-panel__body">' + rows + '</div>' +
        '<div class="cmp-panel__footer">' +
          '<button type="button" class="cmp-btn cmp-btn--solid" id="cmp-panel-update">Update</button>' +
        '</div>' +
      '</div>'
    );
  }

  function showBanner() {
    if (document.getElementById('cmp-banner')) return;

    var wrap = document.createElement('div');
    wrap.id = 'cmp-banner';
    wrap.setAttribute('role', 'dialog');
    wrap.setAttribute('aria-live', 'polite');
    wrap.setAttribute('aria-label', 'Cookie consent');

    wrap.innerHTML =
      '<div class="cmp-banner__inner">' +
        '<p class="cmp-banner__text">' +
          'We use cookies to run this site, and, with your permission, for analytics and advertising. ' +
          '<a href="/privacy-policy" class="cmp-banner__link">Learn more</a>' +
        '</p>' +
        '<div class="cmp-banner__actions">' +
          '<button type="button" class="cmp-btn cmp-btn--ghost" id="cmp-necessary-toggle" aria-expanded="false">Necessary Only</button>' +
          '<button type="button" class="cmp-btn cmp-btn--outline" data-cmp="reject_all">Reject All</button>' +
          '<button type="button" class="cmp-btn cmp-btn--solid" data-cmp="accept_all">Accept All</button>' +
        '</div>' +
      '</div>' +
      buildPanelHTML();

    document.body.appendChild(wrap);

    wrap.addEventListener('click', function (e) {
      var acceptRejectBtn = e.target.closest ? e.target.closest('[data-cmp]') : null;
      if (acceptRejectBtn) {
        var mode = acceptRejectBtn.getAttribute('data-cmp');
        saveAndApply(fullConsent(mode), mode);
        return;
      }

      if (e.target.id === 'cmp-necessary-toggle') {
        var panel = document.getElementById('cmp-panel');
        var isHidden = panel.hidden;
        panel.hidden = !isHidden;
        e.target.setAttribute('aria-expanded', String(isHidden));
        return;
      }

      // Both "Update" and the "x" close icon save + apply the current
      // checkbox state — closing is not a cancel.
      if (e.target.id === 'cmp-panel-update' || e.target.id === 'cmp-panel-close') {
        var panelEl = document.getElementById('cmp-panel');
        var consent = consentFromCheckboxes(panelEl);
        saveAndApply(consent, 'necessary_custom');
        return;
      }
    });
  }

  function init() {
    var stored = getCookie(COOKIE_NAME);
    if (stored) {
      try {
        var parsed = JSON.parse(stored);
        if (parsed && parsed.consent) {
          pushConsent(parsed.consent);
          return; // don't show the banner again
        }
      } catch (e) {
        // malformed cookie, fall through and show the banner again
      }
    }
    showBanner();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // Public API for a "Cookie Settings" link anywhere on the site:
  // <a href="#" onclick="CMP.open(); return false;">Cookie Settings</a>
  window.CMP = {
    open: showBanner
  };
})();
