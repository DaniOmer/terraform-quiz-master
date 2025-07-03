#!/bin/bash

# Script de validation locale pour Terraform
# Utilise TFLint et Checkov pour valider les fichiers avant push
# Configuré pour DigitalOcean

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher des messages colorés
print_message() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Vérifier si les outils sont installés
check_tools() {
    print_message "Vérification des outils requis..."
    
    # Vérifier Terraform
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform n'est pas installé. Veuillez l'installer depuis https://www.terraform.io/downloads.html"
        exit 1
    fi
    
    # Vérifier TFLint
    if ! command -v tflint &> /dev/null; then
        print_warning "TFLint n'est pas installé. Installation en cours..."
        # Installation de TFLint
        curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
    fi
    
    # Vérifier Checkov
    if ! command -v checkov &> /dev/null; then
        print_warning "Checkov n'est pas installé. Installation en cours..."
        pip install checkov
    fi
    
    print_success "Tous les outils sont disponibles"
}

# Valider le format Terraform
validate_format() {
    print_message "Validation du format Terraform..."
    
    if terraform fmt -check -recursive; then
        print_success "Format Terraform validé"
    else
        print_error "Erreurs de format détectées"
        print_message "Correction automatique du format..."
        terraform fmt -recursive
        print_success "Format corrigé automatiquement"
    fi
}

# Valider la syntaxe Terraform
validate_syntax() {
    print_message "Validation de la syntaxe Terraform..."
    
    # Valider chaque environnement
    for env in envs/*/; do
        if [ -d "$env" ]; then
            env_name=$(basename "$env")
            print_message "Validation de l'environnement: $env_name"
            
            cd "$env"
            
            # Initialiser sans backend pour la validation
            if terraform init -backend=false > /dev/null 2>&1; then
                if terraform validate; then
                    print_success "Syntaxe validée pour $env_name"
                else
                    print_error "Erreurs de syntaxe dans $env_name"
                    cd - > /dev/null
                    exit 1
                fi
            else
                print_error "Impossible d'initialiser $env_name"
                cd - > /dev/null
                exit 1
            fi
            
            cd - > /dev/null
        fi
    done
}

# Exécuter TFLint
run_tflint() {
    print_message "Exécution de TFLint..."
    
    # Initialiser TFLint
    if [ -f .tflint.hcl ]; then
        print_message "Initialisation de TFLint..."
        tflint --init
    fi
    
    # Analyser les modules
    print_message "Analyse des modules DigitalOcean..."
    for module in modules/*/; do
        if [ -d "$module" ]; then
            module_name=$(basename "$module")
            print_message "Analyse du module: $module_name"
            
            if tflint --chdir="$module" --format=compact; then
                print_success "Module $module_name validé"
            else
                print_error "Erreurs TFLint détectées dans le module $module_name"
                exit 1
            fi
        fi
    done
    
    # Analyser les environnements
    print_message "Analyse des environnements..."
    for env in envs/*/; do
        if [ -d "$env" ]; then
            env_name=$(basename "$env")
            print_message "Analyse de l'environnement: $env_name"
            
            if tflint --chdir="$env" --format=compact; then
                print_success "Environnement $env_name validé"
            else
                print_error "Erreurs TFLint détectées dans l'environnement $env_name"
                exit 1
            fi
        fi
    done
    
    print_success "TFLint terminé avec succès"
}

# Exécuter Checkov
run_checkov() {
    print_message "Exécution de Checkov pour DigitalOcean..."
    
    if checkov -d . --framework terraform --compact --quiet; then
        print_success "Checkov terminé avec succès"
    else
        print_error "Checkov a détecté des problèmes de sécurité"
        print_message "Consultez les détails ci-dessus et corrigez les problèmes"
        print_message "Vérifiez notamment :"
        print_message "- Configuration des Droplets (monitoring, private networking)"
        print_message "- Sécurité des buckets Spaces"
        print_message "- Configuration des firewalls"
        print_message "- Clés SSH et accès"
        exit 1
    fi
}

# Fonction de nettoyage
cleanup() {
    print_message "Nettoyage des fichiers temporaires..."
    
    # Supprimer les fichiers .terraform dans les environnements
    find envs/ -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
    find envs/ -name "terraform.tfstate*" -type f -delete 2>/dev/null || true
    find envs/ -name ".terraform.lock.hcl" -type f -delete 2>/dev/null || true
    
    print_success "Nettoyage terminé"
}

# Fonction principale
main() {
    print_message "🚀 Début de la validation locale Terraform (DigitalOcean)"
    echo "================================================"
    
    # Vérifier les outils
    check_tools
    
    # Valider le format
    validate_format
    
    # Valider la syntaxe
    validate_syntax
    
    # Exécuter TFLint
    run_tflint
    
    # Exécuter Checkov
    run_checkov
    
    # Nettoyage
    cleanup
    
    echo "================================================"
    print_success "🎉 Validation terminée avec succès!"
    print_message "Votre infrastructure DigitalOcean est prête à être déployée"
}

# Gestion des arguments
case "${1:-}" in
    "format")
        validate_format
        ;;
    "syntax")
        validate_syntax
        ;;
    "tflint")
        run_tflint
        ;;
    "checkov")
        run_checkov
        ;;
    "clean")
        cleanup
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [OPTION]"
        echo ""
        echo "Script de validation Terraform pour DigitalOcean"
        echo ""
        echo "Options:"
        echo "  format    Valider et corriger le format Terraform"
        echo "  syntax    Valider la syntaxe Terraform"
        echo "  tflint    Exécuter TFLint (bonnes pratiques)"
        echo "  checkov   Exécuter Checkov (sécurité DigitalOcean)"
        echo "  clean     Nettoyer les fichiers temporaires"
        echo "  help      Afficher cette aide"
        echo ""
        echo "Sans option, exécute toutes les validations"
        echo ""
        echo "Contrôles de sécurité inclus :"
        echo "- Droplets : monitoring, private networking, backups"
        echo "- Spaces : chiffrement, versioning, ACL"
        echo "- Kubernetes : auto-upgrade, maintenance"
        echo "- Firewalls : règles d'accès sécurisées"
        ;;
    *)
        main
        ;;
esac 