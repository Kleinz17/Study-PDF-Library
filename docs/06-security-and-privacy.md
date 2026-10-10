# Security and privacy

**Last checked:** 2026-10-09

## What this app stores

Study PDF Library is a local-first app. Everything it stores stays on the user's device.

| Data | Where it lives | Who can see it |
| --- | --- | --- |
| PDF library metadata (file names, folder assignments, reading progress) | On the device, in a local Drift (SQLite) database | Only that user |
| The PDF files the user imports | On the device (the user's own files) | Only that user |
| Kanban tasks and their status, linked to PDFs | On the device, in the same local database | Only that user |
| App settings | On the device | Only that user |

The app has no accounts, no sign-in and no analytics. No user data is sent to any server.

## Secrets

- Values my app needs at run time: none. The app has no backend, so there are no API keys, tokens or passwords.
- Where they live locally: not applicable.
- Where the deploy workflow gets them: not applicable.
- Anything my deployed web build carries that a visitor could read, and why that is acceptable: nothing. The build contains only app code and assets.

## What protects the data on the service side

Nothing leaves the device, so there is no Firestore, Supabase or other service to protect. The data is protected by the device's own storage and the operating system's app sandboxing.

## Checklist

- [ ] `.env` (or `env.json`) is in `.gitignore`, and `.env.example` is committed *(or: the app has no env file at all)*
- [ ] `git log -p | grep -i "api_key\|secret\|password\|token"` finds nothing real
- [ ] No service account file, keystore or `service_role` key anywhere in the repo
- [ ] Security rules or RLS policies written and tested, not left open *(not applicable: no service side)*
- [ ] No real personal data in sample data, screenshots or the video
- [ ] No course or university credentials anywhere
- [ ] Anyone whose data appears in a test was asked first

## Keys found and revoked

None Found
