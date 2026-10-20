# Importer les listes depuis la boîte Microsoft 365 (flux delegated, 100% navigateur)

Tu te connectes avec TON compte M365, l'app lit TA boîte via Microsoft Graph et importe les pièces jointes `.zip/.xlsx`. Aucun secret, aucun serveur : tout dans le navigateur (MSAL + Graph).

## 1. Enregistrer une app Azure (Entra ID)
1. https://portal.azure.com → **Microsoft Entra ID** → **App registrations** → **New registration**.
   - Name : `Filtro Liste Mail`.
   - Supported account types : **Single tenant** (ce répertoire seulement).
   - Redirect URI : plateforme **Single-page application (SPA)** → l'URL exacte de ton app en ligne, ex. `https://xxx.netlify.app/`.
2. **Register**. Note **Application (client) ID** et **Directory (tenant) ID**.
3. **API permissions** → **Add a permission** → **Microsoft Graph** → **Delegated permissions** → coche **Mail.Read** → **Add**.
   - Si le bouton **Grant admin consent** est présent, clique-le. Sinon, la 1ʳᵉ connexion demandera ton consentement ; si le tenant le bloque, un admin doit consentir une fois.

> Si ton tenant interdit aux utilisateurs d'enregistrer des apps, demande à l'IT de faire l'étape 1 et de te donner le **client ID** + **tenant ID**. Mail.Read (delegated) ne lit **que** la boîte de la personne connectée.

## 2. Configurer l'app
Dans `Filtro_Liste_Navi.html` :
```
const MS_CFG = { clientId: '', tenantId: 'common', filterFrom: '', filterSubject: '', sinceDays: 10 };
```
Remplis :
```
const MS_CFG = {
  clientId: 'xxxxxxxx-....',        // Application (client) ID
  tenantId: 'yyyyyyyy-....',        // Directory (tenant) ID
  filterFrom: 'liste@fornitore.it', // (option) ne garder que cet expéditeur
  filterSubject: 'FLIGHT',          // (option) l'objet doit contenir ce texte
  sinceDays: 10                     // ne regarde que les 10 derniers jours
};
```

## 3. Important — Redirect URI
L'URI de redirection dans Azure doit être **exactement** l'URL de la page (origine + chemin). Le plus simple : renomme le fichier **`index.html`** et déploie-le à la racine → l'URL est `https://xxx.netlify.app/` (= ce que tu as mis en étape 1).

## 4. Utilisation
Onglet **Generale assistenze** → **Importa da email (Microsoft)** → fenêtre de login Microsoft → l'app récupère les pièces jointes récentes (zip déchiffrés avec `#ENJOYHAPPINES2`), les filtre et alimente le generale.

## Limites
- Flux delegated : il faut se connecter (pas d'auto-fetch sans toi). Pour un fetch automatique programmé il faudrait le flux application (admin + boîte de service).
- Ne lit que les `sinceDays` derniers jours, 50 messages max par appel.
