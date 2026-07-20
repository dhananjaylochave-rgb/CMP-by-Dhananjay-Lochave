# Custom CMP as a GTM Template — deployment guide

Files:

- `template.tpl` — importable GTM Tag Template. Sets Consent Mode defaults
  via per-type dropdowns and (optionally) loads the banner script.
- `cmp-banner.js` — the banner itself: Accept All / Reject All / Necessary
  Only (expands into checkboxes). Hosted externally, loaded by the tag.
- `cmp-banner.css` — banner + preferences-panel styling.
- `demo.html` — standalone page to test `cmp-banner.js` locally, no GTM
  needed.
- `LICENSE` — Apache 2.0, required verbatim by the Community Template
  Gallery. **Edit the copyright line** (`Copyright [yyyy] [name of
  copyright owner]`, near the bottom) before committing.
- `metadata.yaml` — required by the gallery. **Edit the placeholders**
  (`homepage`, `documentation`, and the commit `sha`) before submitting
  — see "Publish to the Community Template Gallery" below.

---

## 0. Publish to the Community Template Gallery

This repo is already structured for gallery submission (`template.tpl`,
`metadata.yaml`, `LICENSE` at the root — the three files the Gallery
requires). To actually publish:

1. **Agree to the Gallery Terms of Service.** Open `template.tpl` in
   GTM's own Template Editor (Templates → import it if you haven't
   already), go to the **Info** tab, and check **"Agree to the
   Community Template Gallery Terms of Service."** This can only be
   done from inside the GTM UI, not by editing the file directly.
   Re-export afterward if you make any further changes.
2. **Fill in the two placeholder files:**
   - `LICENSE` — replace `[yyyy] [name of copyright owner]` with the
     year and your name/organization.
   - `metadata.yaml` — replace the `homepage` URL (your org's site) and
     `documentation` URL (can just be this repo's README on GitHub).
     Leave `sha` for step 4.
3. **Create a public GitHub repository** and push `template.tpl`,
   `metadata.yaml`, `LICENSE`, and this `README.md` to its **root**
   (not a subfolder) on the **main** branch. One `template.tpl` per
   repo. Make sure **Issues** are enabled on the repo (the gallery
   listing links to it for bug reports) and that you have email
   notifications on for it.
4. **Get the commit SHA** of the commit containing the final files —
   open that commit on GitHub, click the clipboard icon next to the
   SHA — and paste it into `metadata.yaml`'s `sha` field. Commit that
   change too.
5. **Submit**: go to
   [tagmanager.google.com/gallery](https://tagmanager.google.com/gallery),
   signed in with the GitHub account that has access to the repo, click
   the **⋮ menu → Submit Template**, and paste the repository URL.
6. Google reviews submissions manually (security/policy check) before
   they go live — there's no fixed SLA, and a template can be rejected
   if functionality overlaps too closely with an existing one already
   in the gallery (there are several other consent-management templates
   there already, so review may take this into account).
7. **To ship an update later**: commit the change, copy the new SHA,
   add it as a new entry at the *top* of `metadata.yaml`'s `versions`
   list (most recent first) with `changeNotes` describing what changed,
   commit. Propagates to users in ~2–3 days.
8. **To pull the template from the gallery**: delete `LICENSE` or
   `metadata.yaml` from the repo — the gallery detects this and removes
   the listing automatically.

One thing worth knowing going in: the `inject_script` permission (which
governs where the banner script can be loaded from) is locked in by
whoever adds this template to *their own* container — same manual step
you just did for your own site. There's no way to make that automatic
for every future adopter; it's a deliberate security control in GTM's
permission model, not a bug in this template.

---

## 1. Prerequisites

- GTM container with Publish access.
- A place to host `cmp-banner.js` and `cmp-banner.css` as static files
  (the client's own domain/CDN, or your agency's static hosting) — you
  need a stable HTTPS URL for each before importing the template.
- GA4 / Google Ads / other tags already in the container.
- A privacy/cookie policy URL to link from the banner.
- Confirm consent model with the client: this defaults to **opt-in**
  (deny until the visitor chooses) for GDPR/UK-GDPR/India DPDP-style
  regimes.
- GTM Preview mode + GA4 DebugView for QA before publishing.

---

## 2. Host the banner files

Upload `cmp-banner.js` and `cmp-banner.css` to wherever the client hosts
static assets, e.g.:

```
https://cdn.clientdomain.com/cmp/cmp-banner.js
https://cdn.clientdomain.com/cmp/cmp-banner.css
```

You'll need the `cmp-banner.js` URL in step 3. Add `cmp-banner.css` as a
stylesheet link in the site's `<head>` directly (templates can't inject
`<link>` tags, only scripts) — this is the one manual code change still
needed on the site itself.

---

## 3. Import and configure the GTM template

1. In GTM: **Templates → Tag Templates → New → ⋮ (top right) → Import**,
   select `template.tpl`.
2. Open the imported template's **Permissions** tab and update two
   placeholder values to match your setup:
   - **get_cookies**: change `cmp_consent` if you're using a different
     cookie name than the field default.
   - **inject_script**: replace
     `https://your-cdn-or-domain.example.com/cmp/*` with the actual URL
     pattern for where you hosted `cmp-banner.js` in step 2 (keep the
     trailing `*` wildcard).
3. Save the template.
4. Go to **Tags → New**, pick this template.
5. Configure the tag:
   - **Default Consent State** group — dropdowns per consent type. Leave
     `ad_storage`, `ad_user_data`, `ad_personalization`,
     `analytics_storage`, `personalization_storage` on **denied**;
     `functionality_storage`/`security_storage` on **granted**. This is
     the native dropdown-based consent config — no manual JS to edit.
   - **Wait for Update (ms)**: 500 is a sensible default.
   - **Load the consent banner script on this page**: checked.
   - **Banner script URL**: the `cmp-banner.js` URL from step 2.
   - **Consent cookie name** / **Cookie retention (days)**: defaults are
     fine unless you changed the permission in step 2.
6. **Trigger**: create (or reuse) a trigger of type
   **Consent Initialization - All Pages** and attach it here. This is
   GTM's built-in mechanism to guarantee the tag fires before every
   other tag — no custom trigger logic needed.
7. Save, publish.

---

## 4. Gate your other tags on consent (native GTM feature)

This is already built into every tag in GTM — nothing to install:

1. Open any tag (GA4 config, Ads, a Custom HTML tag, etc.) → scroll to
   **Consent Settings** at the bottom.
2. Toggle **"Require additional consent for tag to fire"**.
3. Pick the relevant consent type(s) from the dropdown/checkbox list —
   e.g. `analytics_storage` for analytics tags, `ad_storage` /
   `ad_user_data` / `ad_personalization` for ad tags. This list is
   populated from the same built-in Consent Mode types the template
   above manages — no extra wiring required.
4. **Admin → Container Settings → Consent Overview** flags any tags
   still missing consent checks — clear these before publishing.

Most native GA4/Google Ads tags added since late 2023 already respect
Consent Mode automatically even without this step, but it's good
practice to set it explicitly, especially for Custom HTML tags and
third-party pixels.

---

## 5. Test before publishing

1. Enable **GTM Preview**, load the site.
2. First load (no cookie): confirm `analytics_storage`/`ad_storage` show
   **denied** in the Consent tab, no GA4/Ads hits fire yet, and the
   banner appears.
3. Click **Accept All** → consent `update` fires with everything
   granted, GA4 hits appear in **DebugView**.
4. Clear the `cmp_consent` cookie, reload, click **Reject All** →
   confirm no analytics/ads hits fire.
5. Clear the cookie again, reload, click **Necessary Only** → panel
   expands, `analytics_storage` is pre-checked, others unchecked.
   - Click **Update** without touching anything → confirm
     `analytics_storage` still ends up **granted**, everything else
     **denied**.
   - Repeat but close via the **✕** icon instead of Update → same
     result (this confirms "close" isn't treated as cancel).
   - Uncheck `analytics_storage` before saving → confirm it's **denied**
     this time.
6. Reload after any choice → banner should **not** reappear, and the
   Consent tab in Preview should already show the stored state without
   any click.
7. Test on a mobile viewport width.
8. Test the "Cookie Settings" reopen link if you added one
   (`CMP.open()`).

---

## 6. Go live

1. Publish the GTM container.
2. Deploy `cmp-banner.css` (and its `<link>` tag) alongside the GTM
   publish — same release, so there's no window where the tag expects
   styling that isn't there yet.
3. Monitor GA4 Realtime and Google Ads diagnostics for the first few
   hours — expect **modeled conversions** for denied users, not a
   tracking bug.
4. Once volume builds, check the accept/reject/necessary-only split for
   the client conversation about data completeness.

---

## 7. Optional hardening

- **Region-specific defaults**: extend the sandboxed JS in `template.tpl`
  to pass a `region` array into `setDefaultConsentState`, or add a
  region field to the template, if the client needs different defaults
  for EEA/UK/India vs. rest of world.
- **Consent Mode v2 "advanced" vs "basic"**: this build is advanced mode
  (tags fire in a cookieless/pinged state even when denied, enabling
  modeling). Flag it if the client specifically wants tags not to fire
  at all when denied — that's a different configuration choice with
  different modeled-conversion behavior in Ads/GA4.
- **IAB TCF**: if programmatic ad partners require TCF strings, this
  custom banner won't satisfy that on its own — you'd need a
  TCF-certified CMP instead.
