# 🏗️ Architecture du projet Super Chapelaine

## Vue d'ensemble

Super Chapelaine est une **application web statique mono-page (SPA)** qui
regroupe plusieurs outils de gestion pour le club de handball La Chapelaine.

L'architecture repose sur des principes simples :
- **Zéro backend** : tout s'exécute dans le navigateur
- **JavaScript vanilla** : ES Modules natifs, aucun bundler
- **CSS natif** : variables CSS pour la cohérence visuelle
- **Modularité** : chaque outil est un module indépendant

---

## Architecture des modules

```mermaid
flowchart TD
    ENTREE["index.html<br/>Point d'entrée unique"]
    ENTREE --> APP["js/app.js<br/>Routeur principal"]

    APP --> MOD_ATT["Module<br/>Attestation de paiement"]
    APP --> MOD_COM["Module<br/>Com' hebdo"]
    APP --> MOD_FRM["Module<br/>Frais km 🔜"]
    APP --> MOD_ASS["Module<br/>Assistance 🔜"]

    MOD_ATT --> RES_ATT["ressources/<br/>attestation-de-paiement/"]
    MOD_COM --> RES_COM["ressources/<br/>com-hebdo/"]

    style ENTREE fill:#f96,stroke:#333,color:#fff
    style APP fill:#69b,stroke:#333,color:#fff
    style MOD_ATT fill:#5a5,stroke:#333,color:#fff
    style MOD_COM fill:#5a5,stroke:#333,color:#fff
    style MOD_FRM fill:#999,stroke:#333,color:#fff
    style MOD_ASS fill:#999,stroke:#333,color:#fff
    style RES_ATT fill:#fc5,stroke:#333,color:#333
    style RES_COM fill:#fc5,stroke:#333,color:#333
```

---

## Flux de données — Attestation de paiement

```mermaid
flowchart LR
    CSV_LIC["CSV licenciés<br/>(GestHand)"]
    CSV_TAR["CSV tarifs"]
    DOCX["Modèle DOCX<br/>attestation"]

    CSV_LIC --> EXTRACT["Extracteur<br/>CSV → données"]
    CSV_TAR --> EXTRACT

    EXTRACT --> NETTOY["Nettoyeur<br/>validation"]
    NETTOY --> RENDER["Renderer<br/>génération"]
    DOCX --> RENDER

    RENDER --> PDF["📄 Attestation<br/>PDF/DOCX"]

    style CSV_LIC fill:#fc5,stroke:#333,color:#333
    style CSV_TAR fill:#fc5,stroke:#333,color:#333
    style DOCX fill:#fc5,stroke:#333,color:#333
    style EXTRACT fill:#69b,stroke:#333,color:#fff
    style NETTOY fill:#69b,stroke:#333,color:#fff
    style RENDER fill:#69b,stroke:#333,color:#fff
    style PDF fill:#5a5,stroke:#333,color:#fff
```

---

## Flux de données — Communication hebdomadaire

```mermaid
flowchart LR
    CSV_GH["CSV GestHand<br/>(programmes ou résultats)"]

    CSV_GH --> PARSER["Parser<br/>GestHand"]
    PARSER --> TYPE{Type ?}

    TYPE -->|Programmes| PROG["Extraction<br/>matchs à venir"]
    TYPE -->|Résultats| RES["Extraction<br/>scores"]

    PROG --> PLAN["Planning<br/>hebdomadaire"]
    RES --> PLAN

    PLAN --> GSHEET["📊 Export<br/>Google Sheets"]
    PLAN --> MAIL["📧 Contenu<br/>mail"]

    style CSV_GH fill:#fc5,stroke:#333,color:#333
    style PARSER fill:#69b,stroke:#333,color:#fff
    style TYPE fill:#fff,stroke:#333,color:#333
    style PROG fill:#69b,stroke:#333,color:#fff
    style RES fill:#69b,stroke:#333,color:#fff
    style PLAN fill:#69b,stroke:#333,color:#fff
    style GSHEET fill:#5a5,stroke:#333,color:#fff
    style MAIL fill:#5a5,stroke:#333,color:#fff
```

---

## Structure des répertoires

```
super-chapelaine/
│
├── index.html                  ← SPA : point d'entrée unique
├── Makefile                    ← Commandes du projet
├── AGENTS.md                   ← Instructions agents IA
├── README.md                   ← Documentation générale
│
├── js/                         ← Code JavaScript (ES Modules)
│   ├── app.js                  ← Initialisation et routage
│   ├── config/                 ← Constantes, configuration
│   ├── renderers/              ← Rendu DOM et mise en page
│   ├── extracteurs/            ← Lecture et extraction de données
│   ├── parsers/                ← Analyse de formats spécifiques
│   └── nettoyeurs/             ← Validation et nettoyage
│
├── css/                        ← Styles
│   └── styles.css              ← Variables CSS et styles globaux
│
├── ressources/                 ← Données et modèles
│   ├── attestation-de-paiement/
│   │   ├── tarifs.csv
│   │   ├── modele-licencie-adresse.csv
│   │   ├── exemple-licencies-valide.csv
│   │   └── modele-attestation-de-paiement-chapelaine.docx
│   └── com-hebdo/
│
├── mail/                       ← Scripts utilitaires (mails)
├── matchs/                     ← Scripts utilitaires (matchs)
├── docs/                       ← Documentation
├── .sessions/                  ← Logs des sessions IA
└── .github/
    └── copilot-instructions.md
```

---

## Conventions et décisions techniques

### Variables CSS

Le projet utilise des variables CSS définies dans `css/styles.css` pour
maintenir une identité visuelle cohérente :

| Variable   | Utilisation                         |
|------------|-------------------------------------|
| `--orange` | Couleur principale du club          |
| `--dark`   | Texte et arrière-plans sombres      |
| …          | Voir `css/styles.css` pour la liste |

### Modules JavaScript

- Chaque fichier exporte ses fonctions via `export`
- Les imports utilisent des chemins relatifs avec extension `.js`
- Un module = une responsabilité (extracteur, parser, renderer…)

### Données CSV

- Séparateur : `;` (standard GestHand)
- Encodage : UTF-8
- Parsing côté client uniquement

### Librairies externes

Toute librairie tierce est chargée via CDN dans `index.html`.
Aucune dépendance locale (`node_modules`) n'est utilisée.
