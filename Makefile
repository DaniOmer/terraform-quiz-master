.PHONY: help install validate format syntax tflint checkov clean plan apply-dev apply-test apply-prod

# Variables
TERRAFORM_VERSION = 1.5.7
TFLINT_VERSION = 0.48.0
CHECKOV_VERSION = 2.5.0
SCRIPT_DIR = scripts

# Couleurs pour les messages
BLUE = \033[0;34m
GREEN = \033[0;32m
YELLOW = \033[1;33m
RED = \033[0;31m
NC = \033[0m # No Color

# Aide par défaut
help: ## Afficher l'aide
	@echo "$(BLUE)🚀 Commandes disponibles pour le projet Terraform CI/CD$(NC)"
	@echo ""
	@echo "$(GREEN)Installation et configuration:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E "(install|setup)" | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(BLUE)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Validation et tests:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E "(validate|format|syntax|tflint|checkov|test)" | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(BLUE)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Déploiement:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E "(plan|apply)" | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(BLUE)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Maintenance:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E "(clean|maintenance)" | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(BLUE)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""

# Installation des outils
install: ## Installer les outils requis (Terraform, TFLint, Checkov)
	@echo "$(BLUE)📦 Installation des outils requis...$(NC)"
	@if ! command -v terraform &> /dev/null; then \
		echo "$(YELLOW)Installation de Terraform $(TERRAFORM_VERSION)...$(NC)"; \
		wget -q -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_linux_amd64.zip; \
		unzip -q /tmp/terraform.zip -d /tmp; \
		sudo mv /tmp/terraform /usr/local/bin/; \
		rm /tmp/terraform.zip; \
	fi
	@if ! command -v tflint &> /dev/null; then \
		echo "$(YELLOW)Installation de TFLint $(TFLINT_VERSION)...$(NC)"; \
		curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash; \
	fi
	@if ! command -v checkov &> /dev/null; then \
		echo "$(YELLOW)Installation de Checkov $(CHECKOV_VERSION)...$(NC)"; \
		pip3 install checkov==$(CHECKOV_VERSION); \
	fi
	@echo "$(GREEN)✅ Installation terminée!$(NC)"

# Validation complète
validate: ## Exécuter toutes les validations (format, syntaxe, TFLint, Checkov)
	@echo "$(BLUE)🔍 Validation complète du code Terraform...$(NC)"
	@$(SCRIPT_DIR)/local-validation.sh

# Format du code
format: ## Valider et corriger le format Terraform
	@echo "$(BLUE)✨ Validation du format Terraform...$(NC)"
	@$(SCRIPT_DIR)/local-validation.sh format

# Validation syntaxique
syntax: ## Valider la syntaxe Terraform
	@echo "$(BLUE)🔍 Validation de la syntaxe Terraform...$(NC)"
	@$(SCRIPT_DIR)/local-validation.sh syntax

# TFLint
tflint: ## Exécuter TFLint pour les bonnes pratiques
	@echo "$(BLUE)🔧 Exécution de TFLint...$(NC)"
	@$(SCRIPT_DIR)/local-validation.sh tflint

# Checkov
checkov: ## Exécuter Checkov pour les contrôles de sécurité
	@echo "$(BLUE)🔒 Exécution de Checkov...$(NC)"
	@$(SCRIPT_DIR)/local-validation.sh checkov

# Plans Terraform
plan-dev: ## Créer un plan Terraform pour l'environnement dev
	@echo "$(BLUE)📋 Création du plan Terraform pour DEV...$(NC)"
	@cd envs/dev && terraform init && terraform plan -out=tfplan-dev

plan-test: ## Créer un plan Terraform pour l'environnement test
	@echo "$(BLUE)📋 Création du plan Terraform pour TEST...$(NC)"
	@cd envs/test && terraform init && terraform plan -out=tfplan-test

plan-prod: ## Créer un plan Terraform pour l'environnement prod
	@echo "$(BLUE)📋 Création du plan Terraform pour PROD...$(NC)"
	@cd envs/prod && terraform init && terraform plan -out=tfplan-prod

# Application des changements (avec confirmation)
apply-dev: plan-dev ## Appliquer les changements pour l'environnement dev
	@echo "$(YELLOW)⚠️  Vous allez appliquer les changements sur l'environnement DEV$(NC)"
	@echo "$(YELLOW)Êtes-vous sûr? [y/N] $(NC)" && read ans && [ $${ans:-N} = y ]
	@cd envs/dev && terraform apply tfplan-dev
	@echo "$(GREEN)✅ Déploiement DEV terminé!$(NC)"

apply-test: plan-test ## Appliquer les changements pour l'environnement test
	@echo "$(YELLOW)⚠️  Vous allez appliquer les changements sur l'environnement TEST$(NC)"
	@echo "$(YELLOW)Êtes-vous sûr? [y/N] $(NC)" && read ans && [ $${ans:-N} = y ]
	@cd envs/test && terraform apply tfplan-test
	@echo "$(GREEN)✅ Déploiement TEST terminé!$(NC)"

apply-prod: plan-prod ## Appliquer les changements pour l'environnement prod
	@echo "$(RED)🚨 ATTENTION: Vous allez appliquer les changements sur l'environnement PRODUCTION$(NC)"
	@echo "$(RED)Cette action est irréversible et peut avoir des conséquences importantes.$(NC)"
	@echo "$(YELLOW)Êtes-vous absolument sûr? [y/N] $(NC)" && read ans && [ $${ans:-N} = y ]
	@cd envs/prod && terraform apply tfplan-prod
	@echo "$(GREEN)✅ Déploiement PROD terminé!$(NC)"

# Nettoyage
clean: ## Nettoyer les fichiers temporaires
	@echo "$(BLUE)🧹 Nettoyage des fichiers temporaires...$(NC)"
	@$(SCRIPT_DIR)/local-validation.sh clean
	@find . -name "*.tfplan" -delete 2>/dev/null || true
	@find . -name "tfplan-*" -delete 2>/dev/null || true
	@echo "$(GREEN)✅ Nettoyage terminé!$(NC)"

# Tests complets avant push
test-before-push: validate ## Tests complets avant push (alias pour validate)
	@echo "$(GREEN)🎉 Code prêt à être poussé!$(NC)"

# Vérifier les versions des outils
versions: ## Afficher les versions des outils installés
	@echo "$(BLUE)📋 Versions des outils installés:$(NC)"
	@echo -n "Terraform: " && terraform version -json | jq -r '.terraform_version' 2>/dev/null || echo "Non installé"
	@echo -n "TFLint: " && tflint --version 2>/dev/null || echo "Non installé"
	@echo -n "Checkov: " && checkov --version 2>/dev/null || echo "Non installé"

# Initialiser le projet
init: ## Initialiser le projet (créer les dossiers manquants)
	@echo "$(BLUE)🚀 Initialisation du projet...$(NC)"
	@mkdir -p scripts logs tmp
	@chmod +x $(SCRIPT_DIR)/local-validation.sh
	@echo "$(GREEN)✅ Projet initialisé!$(NC)"

# Maintenance des dépendances
maintenance: ## Mettre à jour les dépendances et nettoyer
	@echo "$(BLUE)🔧 Maintenance du projet...$(NC)"
	@$(MAKE) clean
	@echo "$(YELLOW)Mise à jour des plugins TFLint...$(NC)"
	@tflint --init 2>/dev/null || true
	@echo "$(GREEN)✅ Maintenance terminée!$(NC)" 