# ╔════════════════════════════════════════════════════════════════╗
# ║  Super Chapelaine — Makefile de gestion du projet             ║
# ║  Club de handball · Site web statique (SPA)                   ║
# ╚════════════════════════════════════════════════════════════════╝
#
# Utilisation : make <cible>
# Aide        : make help (ou simplement make)

# ── Variables ──────────────────────────────────────────────────────
PORT          := 8080
REPERTOIRE_SESSIONS := .sessions
REPERTOIRE_WORKTREES := ..
NOM_PROJET    := super-chapelaine
DATE_SESSION  := $(shell date '+%Y-%m-%d_%Hh%M')
MODELE        := claude

# ── Fichiers attendus dans le projet ──────────────────────────────
FICHIERS_REQUIS := index.html css/styles.css js/app.js

# ── Cibles déclarées (pas de fichiers correspondants) ─────────────
.PHONY: help servir verifier session worktree-creer worktree-supprimer \
        superpower-verifier superpower-installer nettoyer

# ══════════════════════════════════════════════════════════════════
# Aide — cible par défaut
# ══════════════════════════════════════════════════════════════════
help:
	@echo ""
	@echo "╔════════════════════════════════════════════════════════════╗"
	@echo "║       🤾 Super Chapelaine — Outils de gestion            ║"
	@echo "╠════════════════════════════════════════════════════════════╣"
	@echo "║                                                          ║"
	@echo "║  make servir                — Serveur local (:$(PORT))      ║"
	@echo "║  make verifier              — Vérifier la structure      ║"
	@echo "║  make session               — Nouvelle session IA        ║"
	@echo "║  make worktree-creer NOM=x  — Créer un worktree git     ║"
	@echo "║  make worktree-supprimer NOM=x — Supprimer un worktree  ║"
	@echo "║  make superpower-verifier   — Vérifier superpower        ║"
	@echo "║  make superpower-installer  — Installer superpower       ║"
	@echo "║  make nettoyer              — Nettoyer les temporaires   ║"
	@echo "║                                                          ║"
	@echo "╚════════════════════════════════════════════════════════════╝"
	@echo ""

# ══════════════════════════════════════════════════════════════════
# Serveur — lancer un serveur HTTP local pour le développement
# ══════════════════════════════════════════════════════════════════
servir:
	@echo "🌐 Démarrage du serveur local sur le port $(PORT)…"
	@echo "   → http://localhost:$(PORT)"
	@echo "   Ctrl+C pour arrêter."
	@echo ""
	@python3 -m http.server $(PORT)

# ══════════════════════════════════════════════════════════════════
# Vérifier — contrôler que la structure du projet est correcte
# ══════════════════════════════════════════════════════════════════
verifier:
	@echo "🔍 Vérification de la structure du projet…"
	@echo ""
	@ERREURS=0; \
	for fichier in $(FICHIERS_REQUIS); do \
		if [ -f "$$fichier" ]; then \
			echo "  ✅  $$fichier"; \
		else \
			echo "  ❌  $$fichier — MANQUANT"; \
			ERREURS=$$((ERREURS + 1)); \
		fi; \
	done; \
	echo ""; \
	if [ -d ".git" ]; then \
		echo "  ✅  Dépôt git initialisé"; \
	else \
		echo "  ❌  Pas de dépôt git"; \
		ERREURS=$$((ERREURS + 1)); \
	fi; \
	if [ -d "$(REPERTOIRE_SESSIONS)" ]; then \
		echo "  ✅  Répertoire sessions présent"; \
	else \
		echo "  ⚠️   Répertoire sessions absent (make session le créera)"; \
	fi; \
	echo ""; \
	if [ $$ERREURS -eq 0 ]; then \
		echo "  🎉 Tout est en ordre !"; \
	else \
		echo "  ⚠️  $$ERREURS problème(s) détecté(s)."; \
	fi; \
	echo ""

# ══════════════════════════════════════════════════════════════════
# Session — créer un fichier de session IA avec date/heure
# ══════════════════════════════════════════════════════════════════
session:
	@mkdir -p $(REPERTOIRE_SESSIONS)
	@FICHIER="$(REPERTOIRE_SESSIONS)/$(DATE_SESSION)_$(MODELE).md"; \
	echo "📝 Création de la session : $$FICHIER"; \
	echo "# Session IA — $(DATE_SESSION)" > "$$FICHIER"; \
	echo "" >> "$$FICHIER"; \
	echo "- **Date** : $$(date '+%A %d %B %Y à %Hh%M')" >> "$$FICHIER"; \
	echo "- **Modèle** : $(MODELE)" >> "$$FICHIER"; \
	echo "- **Branche** : $$(git branch --show-current 2>/dev/null || echo 'inconnue')" >> "$$FICHIER"; \
	echo "" >> "$$FICHIER"; \
	echo "## Objectifs" >> "$$FICHIER"; \
	echo "" >> "$$FICHIER"; \
	echo "- [ ] …" >> "$$FICHIER"; \
	echo "" >> "$$FICHIER"; \
	echo "## Résumé" >> "$$FICHIER"; \
	echo "" >> "$$FICHIER"; \
	echo "…" >> "$$FICHIER"; \
	echo "" >> "$$FICHIER"; \
	echo "## Décisions prises" >> "$$FICHIER"; \
	echo "" >> "$$FICHIER"; \
	echo "…" >> "$$FICHIER"; \
	echo ""; \
	echo "  ✅ Session créée : $$FICHIER"

# ══════════════════════════════════════════════════════════════════
# Worktree — créer un worktree git pour travailler en parallèle
# ══════════════════════════════════════════════════════════════════
worktree-creer:
ifndef NOM
	@echo "❌ Erreur : préciser NOM=nom-de-branche"
	@echo "   Exemple : make worktree-creer NOM=refonte-accueil"
	@exit 1
endif
	@echo "🌿 Création du worktree « $(NOM) »…"
	@git worktree add $(REPERTOIRE_WORKTREES)/$(NOM_PROJET)--$(NOM) -b $(NOM) 2>/dev/null \
		|| git worktree add $(REPERTOIRE_WORKTREES)/$(NOM_PROJET)--$(NOM) $(NOM)
	@echo "  ✅ Worktree créé : $(REPERTOIRE_WORKTREES)/$(NOM_PROJET)--$(NOM)"
	@echo "  → cd $(REPERTOIRE_WORKTREES)/$(NOM_PROJET)--$(NOM)"

# ══════════════════════════════════════════════════════════════════
# Worktree — supprimer un worktree existant
# ══════════════════════════════════════════════════════════════════
worktree-supprimer:
ifndef NOM
	@echo "❌ Erreur : préciser NOM=nom-de-branche"
	@echo "   Exemple : make worktree-supprimer NOM=refonte-accueil"
	@exit 1
endif
	@echo "🗑️  Suppression du worktree « $(NOM) »…"
	@git worktree remove $(REPERTOIRE_WORKTREES)/$(NOM_PROJET)--$(NOM) --force 2>/dev/null \
		&& echo "  ✅ Worktree supprimé." \
		|| echo "  ❌ Worktree introuvable : $(REPERTOIRE_WORKTREES)/$(NOM_PROJET)--$(NOM)"

# ══════════════════════════════════════════════════════════════════
# Superpower — vérifier que l'outil superpower est configuré
# ══════════════════════════════════════════════════════════════════
superpower-verifier:
	@echo "🔌 Vérification de superpower…"
	@if command -v superpower >/dev/null 2>&1; then \
		echo "  ✅ superpower est installé : $$(superpower --version 2>/dev/null || echo 'version inconnue')"; \
	else \
		echo "  ❌ superpower n'est pas installé."; \
		echo "     → make superpower-installer"; \
	fi

# ══════════════════════════════════════════════════════════════════
# Superpower — installer l'outil superpower
# ══════════════════════════════════════════════════════════════════
superpower-installer:
	@echo "📦 Installation de superpower…"
	@if command -v npm >/dev/null 2>&1; then \
		npm install -g superpower && echo "  ✅ superpower installé avec succès."; \
	else \
		echo "  ❌ npm introuvable. Installer Node.js d'abord."; \
		exit 1; \
	fi

# ══════════════════════════════════════════════════════════════════
# Nettoyer — supprimer les fichiers temporaires
# ══════════════════════════════════════════════════════════════════
nettoyer:
	@echo "🧹 Nettoyage des fichiers temporaires…"
	@rm -rf tmp/ dist/
	@find . -name '*.swp' -delete 2>/dev/null || true
	@find . -name '*.swo' -delete 2>/dev/null || true
	@find . -name '.DS_Store' -delete 2>/dev/null || true
	@echo "  ✅ Nettoyage terminé."
