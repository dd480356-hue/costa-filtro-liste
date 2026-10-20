# Hébergement de l'app (public, managé, sans installation)

Architecture : front statique (Netlify) + backend managé Supabase (Postgres + Auth), région EU. Données passagers (noms) NON stockées en cloud par défaut.

## 1. Créer le backend Supabase
1. Va sur https://supabase.com → **New project**. Région : **EU (Frankfurt)**. Note le mot de passe DB.
2. Menu **SQL Editor** → **New query** → colle tout le contenu de `SUPABASE_SCHEMA.sql` → **Run**.
3. Menu **Authentication → Providers** : garde **Email** activé.
4. **Authentication → Providers → Email** : désactive **"Allow new users to sign up"** (seul toi crées les comptes).
5. **Authentication → Users → Add user** : crée un compte (email + mot de passe) pour chaque membre de l'équipe.
6. Menu **Project Settings → API** : copie **Project URL** et la clé **anon public**.

## 2. Configurer l'app
Dans `Filtro_Liste_Navi.html`, trouve la ligne :
```
const CLOUD_CFG = { url: '', anonKey: '', storePII: false };
```
Remplis :
```
const CLOUD_CFG = { url: 'https://XXXX.supabase.co', anonKey: 'eyJ....', storePII: false };
```
- `storePII: false` (recommandé) : les noms des passagers restent sur le PC, ne partent jamais en base. Les listes par scalo se génèrent alors depuis les listes chargées dans la session.
- `storePII: true` : noms stockés en base partagée (nécessite base légale RGPD + DPA Supabase).

## 3. Mettre en ligne (HTTPS)
1. Va sur https://app.netlify.com → **Add new site → Deploy manually**.
2. Glisse le fichier `Filtro_Liste_Navi.html` (renomme-le `index.html` d'abord, ou dépose un dossier le contenant).
3. Netlify donne une URL HTTPS (ex. `https://xxx.netlify.app`). (Option : domaine perso.)

## 4. Utilisation
- Ouvre l'URL → écran **Accesso** → email + mot de passe du compte Supabase.
- Le GENERALE et les RÈGLES sont partagés entre tous les utilisateurs connectés.
- Ouvert en local (`file://`) sans config → mode hors-ligne par PC (IndexedDB), comme avant.

## RGPD
- Région EU, HTTPS (Netlify), comptes nominatifs, RLS (seuls les utilisateurs authentifiés accèdent).
- Signe le DPA Supabase (Settings → Legal) si tu actives `storePII: true`.

## Phase 2 — email/IMAP (à faire ensuite)
Récupération automatique des pièces jointes : via Supabase Edge Function + API de la messagerie (Gmail API / Microsoft Graph, en OAuth). À implémenter selon ta messagerie.
