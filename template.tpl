___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "CMP by Dhananjay Lochave",
  "categories": [
    "UTILITY",
    "ANALYTICS",
    "ADVERTISING"
  ],
  "description": "",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "consentDefaults",
    "displayName": "Default Consent State",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "SELECT",
        "name": "ad_storage",
        "displayName": "ad_storage",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": "granted",
            "displayValue": "granted"
          },
          {
            "value": "denied",
            "displayValue": "denied"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "denied",
        "help": "Advertising cookies/storage. Should default to denied for opt-in consent regimes (GDPR, DPDP, UK GDPR)."
      },
      {
        "type": "SELECT",
        "name": "ad_user_data",
        "displayName": "ad_user_data",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": "granted",
            "displayValue": "granted"
          },
          {
            "value": "denied",
            "displayValue": "denied"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "denied",
        "help": "Consent to send user data to Google for advertising purposes."
      },
      {
        "type": "SELECT",
        "name": "ad_personalization",
        "displayName": "ad_personalization",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": "granted",
            "displayValue": "granted"
          },
          {
            "value": "denied",
            "displayValue": "denied"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "denied",
        "help": "Consent for personalized advertising / remarketing."
      },
      {
        "type": "SELECT",
        "name": "analytics_storage",
        "displayName": "analytics_storage",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": "granted",
            "displayValue": "granted"
          },
          {
            "value": "denied",
            "displayValue": "denied"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "denied",
        "help": "Analytics cookies/storage (e.g. GA4)."
      },
      {
        "type": "SELECT",
        "name": "personalization_storage",
        "displayName": "personalization_storage",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": "granted",
            "displayValue": "granted"
          },
          {
            "value": "denied",
            "displayValue": "denied"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "denied",
        "help": "Storage related to non-ad personalization (e.g. recommendations)."
      },
      {
        "type": "SELECT",
        "name": "functionality_storage",
        "displayName": "functionality_storage",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": "granted",
            "displayValue": "granted"
          },
          {
            "value": "denied",
            "displayValue": "denied"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "denied",
        "help": "Strictly necessary: site functionality (e.g. language settings). Denied by default on first visit like every other type; the banner script grants it automatically the moment the visitor makes any choice (Accept All / Reject All / Necessary Only), since it isn\u0027t user-configurable."
      },
      {
        "type": "SELECT",
        "name": "security_storage",
        "displayName": "security_storage",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": "granted",
            "displayValue": "granted"
          },
          {
            "value": "denied",
            "displayValue": "denied"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "denied",
        "help": "Strictly necessary: security/fraud-prevention. Denied by default on first visit like every other type; the banner script grants it automatically the moment the visitor makes any choice (Accept All / Reject All / Necessary Only), since it isn\u0027t user-configurable."
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "waitForUpdate",
    "displayName": "Wait for Update (ms)",
    "simpleValueType": true,
    "valueUnit": "milliseconds",
    "defaultValue": 500,
    "help": "How long Google tags wait for an update command before firing with the default (denied) state.",
    "valueValidators": [
      {
        "type": "NON_NEGATIVE_NUMBER"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "loadBanner",
    "checkboxText": "Load the consent banner script on this page",
    "simpleValueType": true,
    "defaultValue": true,
    "help": "Uncheck if the banner script is already being loaded another way (e.g. hardcoded in the site template) and you only want this tag to set consent defaults."
  },
  {
    "type": "TEXT",
    "name": "bannerScriptUrl",
    "displayName": "Banner script URL",
    "simpleValueType": true,
    "help": "The hosted URL of cmp-banner.js. Must also be added under this template\u0027s Permissions tab (inject_script → urls) or the tag will fail with a permission error.",
    "enablingConditions": [
      {
        "paramName": "loadBanner",
        "paramValue": true,
        "type": "EQUALS"
      }
    ],
    "valueValidators": [
      {
        "type": "NON_EMPTY",
        "errorMessage": "Enter the hosted URL of cmp-banner.js"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "cookieName",
    "displayName": "Consent cookie name",
    "simpleValueType": true,
    "defaultValue": "cmp_consent",
    "help": "Must match the cookie name allow-listed under this template\u0027s Permissions tab (get_cookies)."
  },
  {
    "type": "TEXT",
    "name": "cookieDays",
    "displayName": "Cookie retention (days)",
    "simpleValueType": true,
    "valueUnit": "days",
    "defaultValue": 180,
    "valueValidators": [
      {
        "type": "NON_NEGATIVE_NUMBER"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const setDefaultConsentState = require('setDefaultConsentState');
const updateConsentState = require('updateConsentState');
const getCookieValues = require('getCookieValues');
const injectScript = require('injectScript');
const setInWindow = require('setInWindow');
const makeNumber = require('makeNumber');
const JSON = require('JSON');

// 1. Set the default consent state from the dropdowns above. All 7
//    types default to denied on a visitor's first page load — nothing
//    fires (not even "necessary" storage) until they interact with the
//    banner (Accept All / Reject All / Necessary Only).
setDefaultConsentState({
  ad_storage: data.ad_storage,
  ad_user_data: data.ad_user_data,
  ad_personalization: data.ad_personalization,
  analytics_storage: data.analytics_storage,
  personalization_storage: data.personalization_storage,
  functionality_storage: data.functionality_storage,
  security_storage: data.security_storage,
  wait_for_update: makeNumber(data.waitForUpdate)
});

// 2. If a returning visitor already made a choice (stored by the banner
//    script in a cookie), apply it immediately so they don't see denied
//    state flash before the banner script runs.
const cookieName = data.cookieName || 'cmp_consent';
const cookieValues = getCookieValues(cookieName);

if (cookieValues && cookieValues.length > 0) {
  const stored = JSON.parse(cookieValues[0]);
  if (stored && stored.consent) {
    updateConsentState({
      ad_storage: stored.consent.ad_storage,
      ad_user_data: stored.consent.ad_user_data,
      ad_personalization: stored.consent.ad_personalization,
      analytics_storage: stored.consent.analytics_storage,
      personalization_storage: stored.consent.personalization_storage,
      functionality_storage: 'granted',
      security_storage: 'granted'
    });
  }
}

// 3. Optionally load the banner script, passing it the cookie config via
//    a small window global so both pieces agree on cookie name/retention.
if (data.loadBanner) {
  setInWindow('__cmpConfig', {
    cookieName: cookieName,
    cookieDays: makeNumber(data.cookieDays)
  }, true);

  injectScript(data.bannerScriptUrl, data.gtmOnSuccess, data.gtmOnFailure);
} else {
  data.gtmOnSuccess();
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_user_data"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_personalization"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "analytics_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "personalization_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "functionality_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "security_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "cmp_consent"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "__cmpConfig"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://static.staticsave.com/csahavasmn/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created for a custom, self-hosted Consent Mode CMP: sets Google Consent
Mode default state via native per-type dropdowns and optionally loads an
externally hosted banner script (cmp-banner.js) that implements the
Accept All / Reject All / Necessary Only (expandable, per-category
checkboxes) UI.

IMPORTANT before use:
1. Edit the "get_cookies" permission above (or in the Permissions tab
   after import) so "cmp_consent" matches whatever you set in the
   "Consent cookie name" field, if you change it from the default.
2. Edit the "inject_script" permission's URL pattern to match wherever
   you actually host cmp-banner.js (see README.md).


