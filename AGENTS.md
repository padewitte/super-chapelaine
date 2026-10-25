# 🤖 Instructions pour les agents IA — Super Chapelaine

> Ce fichier contient les instructions complètes pour tout agent IA travaillant
> sur le projet Super Chapelaine (club de handball La Chapelaine).

---

## Pré-requis : Superpower

Avant toute session de travail, vérifier que **superpower** est configuré.

Si superpower n'est pas accessible :

> Ce projet utilise OpenCode en CLI. Superpower doit être configuré :
>
> ```bash
> opencode plugin add git+https://github.com/obra/superpowers.git
> ```
>
> Si le fichier `.github/copilot-instructions.md` est absent, exécuter :
>
> ```bash
> ~/.copilot/superpowers/install.sh
> ```

Utiliser `make superpower-verifier` pour vérifier l'installation.

---

## Architecture et stack technique

### Principes fondamentaux

- **JavaScript vanilla ES Modules** uniquement — pas de bundler, pas de transpileur
- **Aucun backend** — tout fonctionne côté client dans le navigateur
- **CSS natif** avec variables CSS (`--orange`, `--dark`, etc.)
- **HTML déclaratif** dans `index.html`
- **Hébergement** : GitHub Pages
- **Librairies externes** : uniquement via CDN (jamais de `node_modules`)

### Ce qu'on n'utilise PAS

- ❌ `package.json`, `npm`, `yarn`, `pnpm`
- ❌ Webpack, Vite, Rollup, esbuild
- ❌ TypeScript, Babel, PostCSS
- ❌ React, Vue, Angular, Svelte
- ❌ Serveur backend, API, base de données

---

## Structure des fichiers

```
super-chapelaine/
├── index.html              ← Point d'entrée unique (SPA)
├── Makefile                ← Harness et commandes du projet
├── AGENTS.md               ← Ce fichier (instructions agents IA)
├── README.md               ← Documentation pour humains
│
├── js/                     ← Modules JavaScript ES6+
│   ├── app.js              ← Point d'entrée JS
│   ├── config/             ← Configuration et constantes
│   ├── renderers/          ← Fonctions de rendu DOM
│   ├── extracteurs/        ← Extraction de données (CSV, etc.)
│   ├── parsers/            ← Analyse de formats (GestHand, etc.)
│   └── nettoyeurs/         ← Nettoyage et validation de données
│
├── css/                    ← Feuilles de style
│   └── styles.css          ← Styles principaux avec variables CSS
│
├── ressources/             ← Modèles et données
│   ├── attestation-de-paiement/  ← CSV et DOCX pour attestations
│   └── com-hebdo/          ← Données communication hebdomadaire
│
├── mail/                   ← Scripts utilitaires autonomes (mails)
├── matchs/                 ← Scripts utilitaires autonomes (matchs)
├── docs/                   ← Documentation détaillée
│   ├── architecture.md     ← Architecture avec diagrammes Mermaid
│   └── developpement.md    ← Guide de développement
│
├── .sessions/              ← Logs des sessions IA (Markdown)
└── .github/
    └── copilot-instructions.md  ← Renvoi vers AGENTS.md
```

---

## Modules du projet

### 1. `attestation-paiement` — Générateur d'attestations de paiement de licences

Génère des attestations de paiement à partir de fichiers CSV de licenciés
et d'un modèle DOCX. Tout se fait dans le navigateur.

### 2. `com-hebdo` — Communication hebdomadaire

Gestion des calendriers et communication hebdomadaire. Pipeline :
1. Import d'un CSV GestHand (programmes ou résultats)
2. Extraction et parsing des données
3. Génération d'un planning formaté
4. Export vers Google Sheets

Code migré depuis le projet `chapelaine-com-hebdo`.

### 3. `frais-km` — Fiches de frais kilométriques *(à venir)*

Génération de fiches de frais kilométriques pour les bénévoles et
encadrants du club.

### 4. `assistance` — Gestion assistance membres *(à venir)*

Outil de gestion de l'assistance aux membres du club.

---

## Conventions CSV GestHand

Les fichiers CSV exportés depuis GestHand suivent ces conventions :

- **Séparateur** : point-virgule `;`
- **Encodage** : UTF-8
- **Deux types de fichiers** à distinguer :
  - **Programmes** : calendrier des matchs à venir
  - **Résultats** : scores et résultats des matchs passés
- Toujours vérifier le type de fichier avant le parsing

---

## Règles de code

### Style

| Règle                        | Valeur                                      |
|------------------------------|---------------------------------------------|
| Indentation                  | **2 espaces** (jamais de tabulations)        |
| Guillemets JS                | **Simples** `'…'` sauf template literals     |
| Points-virgules              | **Obligatoires** en fin d'instruction        |
| Modules                      | **ES6+ natif** navigateur (`import`/`export`)|
| Variables CSS                | Respecter les variables existantes            |
| Langue                       | **Tout en français** (voir ci-dessous)       |

### Langue française

**Tout** doit être en français :
- Commentaires dans le code
- Noms de variables et fonctions
- Documentation et fichiers Markdown
- Noms de fichiers de documentation
- Messages dans la console
- Texte affiché à l'utilisateur

### Exemple de code conforme

```javascript
// Extraction des données de licenciés depuis le fichier CSV
const extraireLicencies = (contenuCsv) => {
  const lignes = contenuCsv.split('\n');
  const enTete = lignes[0].split(';');

  return lignes.slice(1).map((ligne) => {
    const valeurs = ligne.split(';');
    return {
      nom: valeurs[0]?.trim() || '',
      prenom: valeurs[1]?.trim() || '',
      categorie: valeurs[2]?.trim() || '',
    };
  });
};

export { extraireLicencies };
```

---

## Makefile

Un `Makefile` est maintenu à la racine du projet. Il contient :
- Les commandes de développement (`make servir`, `make verifier`)
- Les harness et étapes superpower
- La gestion des sessions IA et worktrees git

Utiliser `make help` pour lister les commandes disponibles.

**Toujours maintenir le Makefile à jour** lors de l'ajout de nouvelles
fonctionnalités ou commandes.

---

## Sessions IA

Chaque session de travail avec un agent IA doit être enregistrée :

- **Répertoire** : `.sessions/`
- **Format** : Markdown (`.md`)
- **Nommage** : `YYYY-MM-DD_HHhMM_modele.md` (ex. `2024-03-15_14h30_claude.md`)
- **Commande** : `make session MODELE=claude`

Le fichier de session doit contenir :
- Date et heure
- Modèle IA utilisé
- Branche git active
- Objectifs de la session
- Résumé des actions
- Décisions prises

---

## Workflow Git avec worktrees

Utiliser des **worktrees git** pour travailler en parallèle sur plusieurs
fonctionnalités :

```bash
# Créer un worktree pour une nouvelle fonctionnalité
make worktree-creer NOM=ma-fonctionnalite

# Travailler dans le worktree
cd ../super-chapelaine--ma-fonctionnalite

# Supprimer le worktree une fois terminé
make worktree-supprimer NOM=ma-fonctionnalite
```

Faire une **revue native pas à pas** du code avant chaque merge.

---

## Règles de comportement

1. **Clarification** : toujours demander des précisions si les instructions
   ne sont pas claires ou trop floues. Ne pas deviner.

2. **Vérification visuelle** : toujours proposer de faire une expérience
   et une vérification visuelle quand c'est pertinent (ouvrir dans le
   navigateur, capture d'écran, etc.).

3. **Documentation** : mettre à jour la documentation quand le code change.

4. **Commits** : messages de commit en français, clairs et descriptifs.
